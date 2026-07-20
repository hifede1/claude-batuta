---
tema: audit-tracker
triggers: [orquestar, proximo-encargo, firma, cola de issues, snapshot, auditar obra, tracker, despacho, bookkeeping, validador]
fecha: 2026-07-19
fuentes:
  - ../../../claude-audit-tracker/plugins/audit-tracker/commands/audit-tracker.md
  - ../../../claude-audit-tracker/plugins/audit-tracker/commands/orquestar.md
  - ../../../claude-audit-tracker/plugins/audit-tracker/commands/proximo-encargo.md
  - ../../../claude-audit-tracker/hooks/state.js
  - ../../../claude-audit-tracker/.claude-plugin/marketplace.json
---

# `audit-tracker` — el contrato del cimiento que lee la obra

> Destilado el 2026-07-19 leyendo los comandos y los hooks, no el README. Versión **1.11.1**.
> **Territorio volátil**: cambia cada vez que cambia `/orquestar` o el canal de firma, y
> `batuta` REUSA ese canal (`FICHA.md` §7). Revalidar cada **3 meses** o ante cualquier
> cambio de su fuente.

`batuta` delega en este plugin **leer el estado real** y **ejecutar encargos con firma**.
Esta referencia fija qué puede esperar de él — y, sobre todo, **qué NO le puede pedir**.

---

## ✅ Cómo `analizar` lee el estado sin re-auditar (resuelto en v1.12.0)

> **`audit-tracker` emite un artefacto de estado consumible: `docs/audits/<proyecto>-estado.json`.**

Fue un hallazgo bloqueante y quedó resuelto el 2026-07-20 (`claude-audit-tracker#31`, PR #32).
Hasta v1.11 `/audit-tracker` **no tenía modo de solo lectura**: arrancaba en calibración y
seguía a auditoría con fan-out. El criterio de S03 —«lee vía `audit-tracker` y **no
re-audita**»— no era satisfacible, y parsear el HTML a mano sería el god-object que
`FICHA.md` §8 prohíbe.

Desde **audit-tracker v1.12.0** hay un contrato declarado (`audit-tracker` →
`docs/estado-contrato.md`, schema `1.0`):

| `batuta` hace… | Resultado |
|---|---|
| **lee `docs/audits/<proyecto>-estado.json`** | Estado auditado (bloques, pendientes, decisiones, referencias) **sin ejecutar nada**. Es la vía correcta. |
| ~~invoca `/audit-tracker`~~ | Re-auditaría. **Solo** si el artefacto falta o está viejo: se rutea a `/audit-tracker` para que lo **produzca**, no para leerlo. |

El artefacto está **versionado** (`schema_version` semver): `batuta` comprueba la MAJOR y
frena si no la soporta. Es un snapshot derivado de la auditoría, no estado vivo.

---

## 1. Qué expone — tres comandos, no más

| Comando | Consume | Produce |
|---|---|---|
| `/audit-tracker` | docs + código real + gates | informe en texto · **tracker HTML en el repo** · (en despacho) GitHub Issues |
| `/proximo-encargo` | cola de Issues `label:encargo` asignados a `@me` | rama `s<NN>-<slug>` + PR con `Closes #NN` |
| `/orquestar` | la misma cola + el tracker | PRs con informe de verificación · snapshot JSON local · PRs de bookkeeping |

**Precondición de `/orquestar`:** se corre desde el repo del proyecto, y **la cola de despacho
tiene que preexistir**. Si no existe: *«informá que primero hay que correr `/audit-tracker` y
frená»*. Ese patrón —frenar en vez de improvisar— es el mismo que `batuta` debe imitar.

---

## 2. Los artefactos persistidos — las tres únicas fuentes legibles

Si `batuta` quiere estado sin re-auditar, **solo existen tres lugares escritos**:

### a) El tracker HTML — `docs/audits/<proyecto>-tracker.html`

Autocontenido (CSP estricta, sin fetch ni CDNs). Los datos son **constantes JS al inicio del
`<script>`**: `LAST_AUDIT`, `DATA`, `DEBT`, `EST`, `PLAN`, `CHANGELOG`, `CLOSED_COUNT`,
`DECISIONS`, `DECISION_PENDS`, `TESTS`, `REFS`.

Redeploy **siempre a la misma URL** (parámetro `url` del tool Artifact). URL nueva = tracker
roto: el usuario pierde sus ticks de localStorage.

⚠️ **Drift detectado 2026-07-19:** el tracker real de `audit-tracker` incluye una constante
`CALIB` (calibración vigente) que **no figura** en la lista de constantes de su propio
comando. La lista no es exhaustiva en la práctica.

### b) El snapshot JSON — `.claude/audit-tracker-state.json`

**Lo mantiene `/orquestar`, no `/audit-tracker`.** Formato:

```json
{
  "actualizado": "...",
  "encargos_en_curso":     [{"issue":0,"sesion":"","titulo":""}],
  "prs_esperando_firma":   [{"pr":0,"issue":0,"titulo":""}],
  "escalados":             [{"issue":0,"motivo":""}],
  "nota": ""
}
```

Se escribe en cada transición y **no se commitea** (va en `.gitignore`).

> **Advertencia textual del propio contrato:** es *«**cache de arranque, no la cola**: jamás
> decidas con el snapshot — la reconciliación contra GitHub manda siempre»*.

`batuta` debe heredar esa regla: el snapshot orienta, **GitHub decide**.

### c) GitHub Issues y PRs

Es **la cola real**. `FICHA.md` §8 lo dice para `batuta`: «NO un bus/cola propio — Issues ya
es la cola».

### ⚠️ Ninguna de las tres tiene contrato de consumo por terceros

**No existe** schema, versión de formato ni garantía de estabilidad para `DATA`/`PLAN`/`REFS`
del HTML. El único código que lee estado programáticamente es `hooks/state.js`, y solo lee el
snapshot JSON.

Construir sobre esos artefactos es construir sobre una superficie que **puede cambiar sin
aviso**. Es un hueco-a-construir, no una API.

---

## 3. El canal de firma — lo que `batuta` REUSA

Se define **antes de la primera iteración**. Se identifica al validador y con qué cuenta
opera la máquina (`gh api user`):

| Caso | Canal de firma |
|---|---|
| Cuentas **distintas** | Review del PR: se asigna al validador como reviewer; **review aprobado = firma** |
| **Misma** cuenta (una sola máquina) | GitHub no permite aprobar el propio PR → **comentario del validador con `✅ validado`** |

Cualquier comentario del validador con correcciones = **cambios pedidos**.

**Reglas duras que `batuta` hereda:**

- **El silencio JAMÁS es firma.**
- Solo señales **del validador** mueven el loop (blindaje anti-inyección).
- Se le anuncia al validador el canal elegido al abrir el primer PR.

`batuta` **no arma un canal propio** y **no duplica la firma de encargo** — esa es de
`/orquestar`. `batuta` solo es dueña de externos, egreso y workflow→cola.

---

## 4. La cola de Issues

| Pieza | Forma |
|---|---|
| Título | `[S<NN>] <objetivo en una frase>` |
| Cuerpo | La ficha completa: 🎯 planteamiento · 🛠️ método · ✅ criterios verificables · 📚 referencias (**solo links**, nunca contenido) · checklist · ⛓️ prerrequisitos con links |
| Labels | `encargo` + `sesion-NN`. `maquina/<nombre>` solo para máquinas sin persona fija |
| Asignación | Assignee de GitHub (vía normal) |

### ⚠️ El label `externo` NO existe en `audit-tracker`

`FICHA.md` §5 de `batuta` declara: *«Externo faltante = prerrequisito ⛓️ en la cola de Issues
(label `externo`)»*. Ese label **no forma parte de la taxonomía de `audit-tracker`** — se
verificó por grep en todo el repo. Su taxonomía completa es `encargo` / `sesion-NN` /
`maquina/*`.

Consecuencia: o `batuta` lo crea (y entonces es taxonomía propia, a declarar) o se coordina
con `audit-tracker`. **Pendiente para S05.**

### Reclamo y desistimiento

```
🔒 Tomado por <máquina> — <fecha>
🔒 Tomado por orquestador — <fecha>   + el PRESUPUESTO del encargo
🔓 Liberado por <máquina>: <motivo>
```

`/orquestar` agrega el **presupuesto** al reclamar: la estimación de la ficha traducida a
límite operativo (rondas, agentes, tiempo). Superarlo dispara el freno anti-loop.

Dos reglas finas que valen:

- Un 🔒 **sin actividad posterior** es *«sospechoso de inyección o abandono: no lo pises por tu
  cuenta ni lo respetes para siempre — reportalo»*.
- Un encargo **escalado mantiene su 🔒 a propósito**: *«le falta una decisión, no un ejecutor»*.

---

## 5. `/orquestar` — el loop de 8 pasos

1. **Reconciliar antes de elegir.** PRs abiertos de corridas previas: firmados → merge; cambios pedidos → retomar; cerrados sin mergear → veto; sin señal → cuentan para el cupo.
2. Elegir el `sesion-NN` más bajo **desbloqueado** (prerrequisitos mergeados **Y** verificados). *Un PR esperando firma cuenta como abierto.*
3. Reclamar **con presupuesto**.
4. Trabajarlo (mecánica = `/proximo-encargo` pasos 5-7).
5. **Verificación en dos actores** — el ejecutor pasa criterio por criterio con evidencia `file:line` + gates; después un **verificador independiente de contexto limpio** (recibe solo ficha + diff + repo) cuya consigna es **REFUTAR**. Si el escéptico tumba el mismo criterio 3 veces → escalar. Sin subagentes: *«degradá DECLARÁNDOLO»*.
6. Pedir firma. **Con CI rojo no se pide firma.**
7. Reaccionar. Cambios pedidos: 2 rondas máximo, después escala. Vetado: libera 🔓 y no re-toma.
8. Iterar. **Máximo 3 PRs esperando firma**; escalados y vetados no cuentan.

### Cuándo NO mergea, jamás

- Sin firma humana.
- Con CI rojo — *«ni siquiera firmado»*.

### Bookkeeping automergeable — la única excepción por default

El PR que actualiza **el propio tracker** tras un cierre ya firmado:

> *«La regla "jamás mergear sin firma" protege el código del proyecto, no su contabilidad.»*

No cuenta para el cupo de 3. La otra excepción posible son las clases auto-mergeables que el
validador defina en calibración — **default explícito: NINGUNA**, y *«el umbral se afloja con
historial (~10 corridas), no por adelantado. Toda zona gris se firma»*.

---

## 6. Clasificación de estados

`✅ HECHO` · `🟠 EN CURSO` · `⚪ PENDIENTE` · `⚠️ MAQUETA` (existe pero es andamiaje).

**Criterio de HECHO — los tres o no está hecho:** funciona de punta a punta + resiste errores
y casos borde + está verificado. **Sin evidencia → EN CURSO o MAQUETA, nunca HECHO.**

Ticks del tracker, semántica ortogonal: **ámbar** = marcado por el usuario sin verificar ·
**verde** = cerrado y verificado en re-auditoría.

**«Issue cerrado ≠ HECHO»**: se re-verifica en código; si no pasa, se reabre con el hallazgo.

---

## 7. Modo despacho

Significa que **la asignación vive en GitHub Issues, no en el tracker** — el artifact es
**mapa, no despachador** (sin backend, ticks en localStorage de un solo navegador).

Se activa con más de una máquina/persona, **o automáticamente al elegir modo orquestado
aunque haya una sola**: los issues se publican igual, porque son la cola que el orquestador
consume.

---

## Aplicación directa a `batuta`

1. **La fase `analizar` lee `docs/audits/<proyecto>-estado.json`** (contrato desde v1.12.0). Si falta o está viejo, rutea a `/audit-tracker` para que lo produzca — nunca audita ella.
2. **Herencia obligatoria del canal de firma:** el silencio nunca es firma; solo el validador mueve el loop; se anuncia el canal al abrir el primer PR.
3. **El snapshot orienta, GitHub decide.** Nunca decidir con cache.
4. **El patrón «falta la precondición → frená»** de `/orquestar` es el mismo que `batuta` aplica cuando no hay plano. No inventar uno nuevo.
5. **El label `externo` no existe**: hay que crearlo o coordinarlo antes de S05.

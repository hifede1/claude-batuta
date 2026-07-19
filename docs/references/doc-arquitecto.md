---
tema: doc-arquitecto
triggers: [documentar, auditar-docs, plano, contrato, cimiento, ADR, ficha, seis dimensiones, catalogo de referencias]
fecha: 2026-07-19
fuentes:
  - ../../../claude-doc-arquitecto/plugins/doc-arquitecto/commands/documentar.md
  - ../../../claude-doc-arquitecto/plugins/doc-arquitecto/commands/auditar-docs.md
  - ../../../claude-doc-arquitecto/docs/decisiones/010-topologia-catalogo-unico-fede-tools.md
  - ../../../claude-audit-tracker/.claude-plugin/marketplace.json
---

# `doc-arquitecto` — el contrato del cimiento que escribe el plano

> Destilado el 2026-07-19 leyendo el código de los comandos, no su README.
> Revalidar ante cualquier cambio en la firma o salida de los comandos, y **antes de
> abrir la compuerta de S01**.

`batuta` **escribe CERO contrato**: delega en este plugin. Esta referencia fija qué puede
esperar de él y qué NO — la frontera exacta donde `batuta` tiene que frenar.

---

## 1. Qué es, dónde vive

- Plugin en **subdirectorio**: `plugins/doc-arquitecto/` dentro de `hifede1/claude-doc-arquitecto`
- Versión declarada: **`1.0.0`**
- **No declara marketplace propio** — hay un gate de CI que falla el build si reaparece uno (anti-regresión del issue #20)
- Se sirve desde el catálogo `fede-tools` con source `git-subdir`

```bash
/plugin marketplace add hifede1/claude-audit-tracker
/plugin install doc-arquitecto@fede-tools
```

Comandos namespaceados: **`/doc-arquitecto:documentar`** y **`/doc-arquitecto:auditar-docs`**.

Solo tiene esos dos comandos. Cero agents, skills, hooks o MCP servers.

---

## 2. `/documentar` — produce el plano

**Consume:** el repo entero + `$ARGUMENTS` como contexto opcional. Sin precondición: detecta su modo solo.

### Los dos modos, y el tie-break que importa

| Modo | Cuándo | Qué hace |
|---|---|---|
| **NUEVO** | Sin docs con sustancia ni código relevante | Entrevista en 4 etapas: propósito → alcance → caza de decisiones → plan de sesiones |
| **EXISTENTE** | Hay docs y/o código | Inventario → detección de huecos → informe → entrevista solo de lo faltante → generación |

> **Tie-break duro: ante la duda, siempre modo existente.** Es el modo seguro — el error
> inverso (tratar un repo con historia como si fuera nuevo) no tiene vuelta atrás.

### La Guardia de Escritura Universal

**Archivo existente = diff confirmado.** Siempre. Incluso en modo nuevo, incluso si la
detección dijo «repo vacío». Un «no» descarta el cambio entero de ese archivo.

**Idempotencia:** sin huecos, escribe **cero bytes** y `git status` queda limpio.

Ese comportamiento es el que `batuta` puede asumir al delegar: correr `/documentar` sobre
un repo ya documentado no ensucia nada.

### El árbol que produce

```
docs/
├── VISION.md            # propósito, problema, éxito
├── ALCANCE.md           # sí / no, firmado con fecha
├── PLAN.md              # sesiones con fichas y criterios
├── decisiones/          # un ADR por decisión (incluidas las pendientes)
├── references/          # catálogo de referencias técnicas
└── business/            # el QUÉ del negocio
```

### Formato de ficha de sesión

Cada sesión de `PLAN.md` lleva: `## S<NN> — <objetivo>` · 🎯 Planteamiento · 🛠️ Método ·
✅ Criterios de aceptación **con `(verificación: …)` cada uno** · 📚 Referencias (solo
links, jamás contenido copiado) · ⛓️ Prerrequisitos · estimación.

**Esto es exactamente el formato del cuerpo de los issues de encargo.** El `PLAN.md` de un
repo documentado por esta herramienta ya ES la ficha de trabajo: no hay que traducirlo.

### Formato ADR

Archivo `NNN-<slug>.md` con: contexto/problema · opciones evaluadas con tradeoffs ·
decisión y porqué · consecuencias · estado (`aceptada` con fecha, o `pendiente` con dueño
y qué desbloquea) · campo **`superaA`** (vacío al crearse; lo completa quien la reemplace).

> «Las pendientes son archivos de primera clase, no notas al pie.»

`superaA` es lo que hace **auditable la cadena de derogaciones**. Sin él no se puede saber
qué decisión reemplazó a cuál.

---

## 3. `/auditar-docs` — audita el plano

**Precondición dura:** sin `docs/`, **no audita**: lo dice, recomienda `/documentar` y **frena**.

**Produce un informe en el chat.** ⚠️ **No persiste ningún archivo.** Si `batuta` necesita
el informe como artefacto, tiene que capturarlo ella — el comando no lo escribe.

### Las 6 dimensiones

| # | Dimensión | Severidad típica |
|---|---|---|
| 1 | **Completitud** — estructura, criterios con su verificación, fichas con 🎯🛠️✅📚⛓️, ADRs completos | varía |
| 2 | **Contradicciones entre documentos** | 🔴 **siempre**, y siempre «requiere decisión humana» |
| 3 | **Criterios no verificables** — ¿otro puede ejecutar la verificación y llegar a sí/no? | 🟠 |
| 4 | **Decisiones estructurales sin registrar** — «usamos X» sin ADR, o pendientes sin dueño | 🟠 |
| 5 | **Referencias faltantes o vencidas** | 🟡 |
| 6 | **Drift interno doc↔doc** — mismo dato con valores distintos | 🟡, o 🔴 si el dato es un criterio o dependencia |

Severidades: 🔴 crítica (el contrato se contradice o exige lo inexistente) · 🟠 alta (no
verificable/auditable) · 🟡 media (envejece) · ⚪ menor (forma).

**Umbrales de frescura declarados:** >6 meses por defecto, **>3 meses en territorio
volátil** (APIs, herramientas, precios, versiones). El informe declara qué umbrales usó.

### Dos distinciones que evitan confundir hallazgos

- **Drift ≠ contradicción**: drift es *un hecho desincronizado*; contradicción son *dos afirmaciones incompatibles*.
- **Regla de altitud — «el plano, no la obra»**: el drift doc↔**código** NO es hallazgo de este comando. Se menciona como nota para `/audit-tracker`.

Esa última regla es la frontera exacta entre los dos cimientos, y por lo tanto la que
`batuta` usa para rutear: **plano → `doc-arquitecto` · obra → `audit-tracker`**.

### Qué NO hace por vos

- Dimensión 2 (contradicciones): **nunca decide qué lado vale.** Siempre requiere humano.
- Dimensión 3: **el umbral no se inventa, se pregunta.**
- Dimensión 4: propone el **esqueleto** del ADR; el porqué lo completa el humano.

Tres puntos donde `batuta` **tiene que frenar y pedir**, no completar.

---

## 4. El catálogo de referencias

Vive en `docs/references/README.md`. **La pestaña Referencias del `audit-tracker` lo
consume SIN traducir** — o sea: el formato del catálogo es un contrato entre los dos cimientos.

Campos obligatorios por fila: **tema · qué resuelve (una línea, distinta del tema) · fecha ·
`triggers` (los valores completos, jamás «ver frontmatter») · quién la usa · frescura · path**

Frontmatter de una referencia técnica: `tema` / `triggers: [palabras, clave]` / `fecha` / `fuentes`.
De un doc de negocio: `tema` / `fecha` / `triggers` / `resumen`.

**Frescura**: 🟢 fresca · 🟠 pendiente de refresco · 🔴 faltante. Y una regla que conviene
citar textual:

> Es evaluación de **vigencia**, no de mera existencia: «existe» NO es un estado de frescura.

### La restricción que define el trabajo de S01

> **`/documentar` NO escribe las referencias técnicas.** Identificarlas es trabajo de
> `/documentar`; **generarlas es trabajo de sus encargos.**

Por eso el catálogo de `batuta` nació con las 5 referencias en 🔴 y no es un defecto:
es el diseño. Cada encargo genera las que necesita antes de arrancar.

---

## 5. Deuda conocida del propio `doc-arquitecto`

Registrado acá para que nadie lo descubra a los golpes:

- **No tiene `docs/PLAN.md`**, pese a ser pieza obligatoria de su propio contrato. Diferido a v1.1 con ADR firmado, que declara la consecuencia: los chequeos de completitud pasan **«vacuamente, no por cumplimiento»**. Consecuencia práctica: **no hay ningún ejemplo real de ficha de sesión generada por la herramienta** — el formato solo existe como especificación.
- **Ningún comando declara frontmatter**, así que no tienen `description` en el listado. No hay archivo que documente esa omisión como decisión.
- **El campo `Fuente:`** que aparece en los ADRs reales no forma parte del contrato: es convención no documentada del repo.
- **El orden de columnas del catálogo no está normado**; la implementación real agrega una columna «Mitad» que el contrato no menciona.
- **`/auditar-docs` no define dónde persistir el informe.**

---

## Aplicación directa a `batuta`

1. **Fase `analizar` (S03):** con plano firmado, `batuta` **lee**; sin plano, rutea a `/documentar` y frena. La precondición dura de `/auditar-docs` («sin docs, frená») es el mismo patrón — conviene imitarla, no reinventarla.
2. **La regla de altitud es el ruteador**: plano → `doc-arquitecto`; obra → `audit-tracker`. Escrita, no intuida.
3. **Tres puntos de freno obligatorio** heredados: contradicciones, umbrales y el porqué de un ADR **nunca** se completan solos.
4. **Si `batuta` necesita el informe de auditoría como artefacto, tiene que capturarlo ella**: el comando solo lo emite en chat.
5. El `PLAN.md` que produce esta herramienta **ya es** la ficha de encargo. No hay capa de traducción que construir.

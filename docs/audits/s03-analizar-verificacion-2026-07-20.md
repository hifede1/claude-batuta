# Verificación de S03 — fase `analizar`

> Encargo: **S03** (issue #7) · Fecha: **2026-07-20** · Ejecutor: `hifede1`
> Depende de: `claude-audit-tracker#31` (cerrado, PR #32 mergeado) — el contrato `estado.json`.

## Qué desbloqueó el cierre de `audit-tracker#31`

El criterio 1 de S03 —«lee el estado vía `audit-tracker` y **no re-audita**»— no era
satisfacible mientras `/audit-tracker` no tuviera modo de lectura. Con el `estado.json`
versionado (audit-tracker v1.12.0), la fase `analizar` **lee un archivo** en vez de auditar.

## Corrida sembrada

Repo de prueba `/Users/federicopernice/Developer/tools/prueba-s03`, sembrado con:

- **Plano firmado** (`docs/PLAN.md`) con la línea de firma de `decisiones/011`:
  `> Estado: VIGENTE · Firmado: 2026-07-20 por Fede`
- **Artefacto de estado** (`docs/audits/prueba-s03-estado.json`), schema `1.0`, con un bloque
  `b01` y un pendiente `p1: "hacer algo"`.

Invocación: `claude --plugin-dir ./plugins/batuta -p "/batuta:batuta agregar un modo oscuro"`.

## Resultado, criterio por criterio

| Criterio de S03 | Verificación | Evidencia de la corrida |
|---|---|---|
| **1. Lee vía `audit-tracker` y no re-audita** | ✅ máquina | Citó `pendiente p1: "hacer algo"` — dato que **solo existe en el `estado.json`**, no en el código. Dijo textual «no auditté nada por mi cuenta». Cero fan-out, cero invocación de `/audit-tracker`. |
| **2. Devuelve su lectura antes de avanzar** | ✅ máquina | Emitió la compuerta de lectura («Mi lectura…») y **frenó** esperando confirmación. «El silencio no es aprobación.» |
| **3. Sin plano rutea a `/documentar` y frena** | ✅ máquina | Probado en la corrida de S02 (repo vacío → ruteó a `/documentar`, `git status` limpio). Acá, con plano presente, `git status` **también** quedó limpio: cero bytes de contrato. |
| **4. Registra el eslabón `idea`** | ✅ por diseño | Dijo: «No escribí todavía el eslabón `idea` — eso va **después** de que confirmes, con tu pedido literal y mi lectura por separado». Es la disciplina correcta: el eslabón se escribe tras la compuerta de lectura (ver `docs/registro-de-cadena.md` §5). El write queda gated en la confirmación humana. |

## Comportamiento emergente — el norte latiendo

La corrida, sin que el criterio lo pidiera, **exhibió dos desvíos como hallazgos en vez de
enterrarlos**:

1. **Desvío pedido↔plano:** «modo oscuro» no existe en el plano firmado. Delegar un encargo
   así sería «un eslabón roto de nacimiento». Se negó a fabricar el requisito.
2. **Drift interno:** el plano ratifica `VISION.md` y `ALCANCE.md`, que no existen en el repo
   de prueba. Lo reportó: «no lo reparo en silencio».

Eso es exactamente lo que `VISION.md` define como éxito: *todo desvío entre lo pedido y lo
construido aparece como hallazgo, no enterrado*.

## Techo de verificación (honesto)

- Criterios 1, 2, 3: **verificados por máquina**, reproducibles con la corrida sembrada de arriba.
- Criterio 4: **verificado por diseño**. El write del eslabón está gated en la confirmación
  humana (la compuerta de lectura), igual que cualquier fase interactiva. Ver la lección de S01:
  un criterio que depende de un paso interactivo tiene techo de verificación automática. La
  disciplina —no escribir el eslabón antes de confirmar— sí quedó probada.

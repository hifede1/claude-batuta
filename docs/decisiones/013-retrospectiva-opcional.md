# 013 — El estado de `retrospectiva`

**Estado:** ✅ **FIRMADA** · 2026-07-22 · **Firmada por:** Fede
**superaA:** —
**Origen:** hallazgo 🟡 de la auditoría del plano, 2026-07-19
**Procedencia de la firma:** Fede eligió **«Fuera de alcance de v0, explícito»** entre las tres opciones presentadas con sus tradeoffs vía elección explícita en sesión interactiva (acto humano rastreable, 2026-07-22), y ratifica esta redacción al mergear su PR. Ver `018` (la firma es un acto, no un campo).

## Contexto / problema

La tabla de delegación de `FICHA.md` §3 decía: *«Retro del proceso al cerrar | `retrospectiva` (**opcional**, cuando exista)»*.

Ese «opcional» abría un **tercer estado que el plano no contempla en ningún otro lado**:

- §0 enumera qué se **BLOQUEA** por delegado faltante y **no** incluye `retrospectiva`.
- §4 describe la fase `cerrar` **sin mencionar** la retro.
- §8 exige que *«cada fase declara a qué tool delega el trabajo real»*.

Resultado: la tabla prometía una delegación que la fase dueña no reconocía, y el binario del plano —o delega, o BLOQUEA— tenía una fila que no caía en ninguno de los dos. **Nadie podía decidir si una corrida sin retro cumplió o incumplió el contrato.**

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Fuera de alcance de v0, explícito** ✅ | La fila sale de §3 y se declara en §11; la fase `cerrar` no la incorpora a su flujo. Binario intacto; ninguna corrida queda incompleta por una tool inexistente. El rastro queda en este ADR. |
| **Entra en la lista de BLOQUEA** | Coherencia total con el binario, pero NINGUNA corrida podría cerrar «completa» hasta que exista una herramienta hoy ni diseñada del lado de `batuta`. Fricción máxima sin ganancia en el camino crítico. |
| **Tercer estado formalizado** | «Opcional» como estado de primera clase. Complica el modelo binario Y contradice el criterio de S08 del PLAN ya firmado (*«sin tercer estado»*): habría exigido re-firmar el plano. |

## Decisión y porqué

**La retro del proceso queda FUERA DE ALCANCE de v0 (y v1), explícito.** En concreto:

1. La fila «Retro del proceso al cerrar» **sale de la tabla de delegación** (`FICHA.md` §3) y de la tabla de delegados-que-bloquean del comando.
2. `FICHA.md` §11 la declara fuera de alcance, con puntero a este ADR.
3. La fase `cerrar` **la declara fuera de alcance y no la incorpora a su flujo**: ni la produce, ni la delega, ni la bloquea. Sin «opcional»: el binario delega-o-BLOQUEA queda intacto porque la fila simplemente no existe en v0.

**Por qué esta y no las otras:** la retro no es camino crítico de la cadena `idea → plano → encargos → obra` — es meta-proceso. Bloquear todo cierre de v0 por ella (opción 2) invierte la prioridad; formalizar el tercer estado (opción 3) contradice el plano firmado. Además, la ficha de diseño externa (`fichas/retrospectiva.md` — borrador del arquitecto, pero cuyo punto de FORMA registra decisión de Fede del 2026-07-17) ya define que `retrospectiva` será un **comando dentro de `audit-tracker`** — audita el PROCESO consumiendo los datos que viven allá (issues, PRs, calibración). Cuando exista, ni siquiera será un delegado directo de `batuta`: será capacidad del cimiento, y la fase `cerrar` a lo sumo la RUTEARÁ como rutea la re-auditoría. El «cuando exista» de la fila vieja apuntaba al lugar equivocado.

**El rastro no se pierde:** queda en este ADR (mismo patrón que `cartera` → v2), y la reincorporación —si llega— es una decisión nueva sobre el corte de versiones (`007`), no una resurrección silenciosa de la fila.

## Consecuencias

- **S08 desbloqueada:** la fase `cerrar` se escribe sin ambigüedad — una corrida sin retro está COMPLETA.
- **El binario queda limpio:** toda fila de delegación cae en delega o BLOQUEA; «opcional» no existe.
- **`FICHA.md` §3/§11 sincronizadas** en el mismo PR que firma este ADR.
- **Puerta futura definida:** si la retro entra en v2+, entra como ruteo al comando `/retrospectiva` de `audit-tracker` (ficha externa), con su propia decisión firmada.

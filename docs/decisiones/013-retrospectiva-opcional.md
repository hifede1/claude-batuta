# 013 — El estado de `retrospectiva`

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **S08 (fase cerrar)**
**superaA:** —
**Origen:** hallazgo 🟡 de la auditoría del plano, 2026-07-19

## Contexto / problema

La tabla de delegación de `FICHA.md` §3 dice: *«Retro del proceso al cerrar | `retrospectiva` (**opcional**, cuando exista)»*.

Ese «opcional» abre un **tercer estado que el plano no contempla en ningún otro lado**:

- §0 enumera qué se **BLOQUEA** por delegado faltante y **no** incluye `retrospectiva`.
- §4 describe la fase `cerrar` **sin mencionar** la retro.
- §8 exige que *«cada fase declara a qué tool delega el trabajo real»*.

Resultado: la tabla promete una delegación que la fase dueña no reconoce, y el binario del plano —o delega, o BLOQUEA— tiene una fila que no cae en ninguno de los dos. **Nadie puede decidir si una corrida sin retro cumplió o incumplió el contrato.**

## Opciones a evaluar (sin decidir)

| Opción | Tradeoffs a sopesar |
|---|---|
| **Entra en la lista de BLOQUEA** | Coherencia total con el binario: si se pide retro y `retrospectiva` no existe, se bloquea como los demás. Costo: ninguna corrida puede cerrar «completa» hasta que exista la herramienta. |
| **Fuera de alcance de v0, explícito** | Se saca de la tabla §3 y se declara en §11. La fase `cerrar` no la menciona. Costo: se pierde el rastro de que estaba pensada. |
| **Tercer estado formalizado** | Se define «opcional» como estado de primera clase con su semántica. Costo: complica el modelo mental que hoy es limpiamente binario. |

## Qué hace falta para cerrarla

Elegir. La elección **cambia lo que la fase `cerrar` debe producir**, así que S08 no puede escribirse antes.

## Consecuencias de dejarla abierta

El criterio de cierre de S08 queda ambiguo: no se sabe si una corrida sin retro es completa.

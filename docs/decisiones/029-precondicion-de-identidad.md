# 029 — Ante discrepancia de identidad al arrancar: FRENAR, jamás restaurar

**Estado:** ✅ **FIRMADA** · 2026-07-28 · **Firmada por:** Fede
**Procedencia de la firma:** acto humano rastreable (`018`), en dos piezas verificables. **(1) La
elección:** Fede eligió **«frenar y preguntar»** entre **tres opciones con sus tradeoffs**, vía
`AskUserQuestion` en sesión interactiva del **2026-07-28**; queda registrada en el **comentario del
dueño en el issue `#73`**, fechado `2026-07-28T21:01:16Z`, con la tabla de las tres y cuál se eligió.
**(2) La ratificación:** el **merge del PR `#74` por el dueño**, `2026-07-28T21:04:39Z`
(`merged_by: hifede1`), que llevó la regla al contrato.
**superaA:** — *(no supera a nadie: aplica `027` —una identidad se decide, jamás se hereda del
entorno— al momento del arranque, y amplía `perimetro-de-confianza.md` §7)*
**Origen:** el incidente del 2026-07-28 — dos comandos completos del taller corrieron con
`estebaproject`, la cuenta que `027` descartó por ser de otro proyecto y que `028` decidió no usar.

> ⚠️ **Este ADR se escribe el 2026-07-30, dos días después del acto, y eso es parte de lo que
> registra.** La decisión estaba **tomada, ratificada y aplicada al contrato** desde el 28 —vive en
> `batuta.md:34-69`— pero **no tenía asiento en `docs/decisiones/`, que es LA fuente del proyecto**.
> El propio artefacto de estado lo declaraba como deuda y reservaba el número `029`. Este documento
> **no re-decide nada ni fabrica el acto del 28: lo asienta donde corresponde.** Ver «Por qué el
> asiento llegó tarde», al pie.

## Contexto / problema

`/batuta` tenía **una sola precondición** antes de la fase 1: que el plano estuviera VIGENTE. **Ninguna
sobre con qué identidad estaba operando.**

El **2026-07-28** eso se pagó: **dos comandos completos del taller corrieron con `estebaproject`** como
cuenta activa. Y hay que decir cómo se detectó: **por accidente**, porque un comando devolvió otro
login. **Ningún chequeo se disparó.**

### La regla que debería haberlo atajado no podía

`perimetro-de-confianza.md` §7 ya prescribía verificar la cuenta activa. Su disparador:

> *después de cada bloque de operaciones **con identidad de agente**, verificar la cuenta activa del
> dueño y restaurarla si cambió*

**Correcta, e inaplicable.** `028` fijó que **no hay identidad de agente** — el agente opera con la
credencial del dueño. **El disparador nunca ocurre.** Era un control que no podía fallar, y por eso
tampoco podía detectar nada.

### El riesgo había cambiado de lugar

§7 protege contra *«el agente contaminó el entorno»*. Lo del 28 fue **lo contrario**: el entorno **ya
estaba contaminado** —por trabajo legítimo del dueño en otro proyecto— y el agente **lo heredaba**.

Que es exactamente lo que `027` prohíbe en su regla más general:

> **Una identidad, una cuenta o cualquier actor que el contrato nombre se DECIDE explícitamente. Jamás
> se hereda del estado del entorno.**

**El riesgo no estaba en el cierre: estaba en el ARRANQUE.** Y un plano vigente leído por la identidad
equivocada no es una corrida válida — es **una corrida cuyo actor nadie decidió**.

## Opciones evaluadas

Las tres se presentaron con sus tradeoffs antes de escribir una línea de contrato.

| Opción | A favor | En contra |
|---|---|---|
| **1 · Frenar y preguntar** ✅ | La cuenta puede estar así **a propósito** —ese día lo estaba—. El estado del entorno es del humano, y cambiárselo sin que lo pida es decidir por él. Simetría exacta con la precondición del plano: ahí el agente tampoco firma por su cuenta | Frena una corrida por algo que el dueño quizá ya sabía |
| **2 · Restaurar y asentar** | Es lo que §7 ya prescribe para su propio caso; barato y sin fricción | §7 lo prescribe **después de operaciones del agente**, donde la contaminación es culpa suya. Al arrancar el estado es del humano — no es el mismo hecho |
| **3 · Frenar siempre, sin camino alternativo** | Máxima seguridad: ninguna corrida avanza con identidad dudosa | Deja al agente **sin vía legítima** de trabajar cuando la discrepancia es conocida y aceptada — y `026` ya midió que **una regla sin camino legítimo se rompe sola** |

## Decisión y porqué

**Opción 1 — FRENAR y reportar. Jamás restaurar por cuenta propia.**

Ante una discrepancia de identidad **al arrancar**, `/batuta` dice **las dos identidades** —la activa y
la anclada— y **espera**. No toca la cuenta activa del humano.

**El porqué que sostiene la elección:** el estado del entorno **es del humano**. Puede estar así a
propósito —ese día lo estaba— y cambiárselo sin que lo pida es decidir por él sobre algo que no es
suyo. Es la misma disciplina que la precondición del plano: ante un plano sin firmar el agente **no
firma él**, reporta y frena. **La identidad se verifica, no se suple.**

**Y la vía legítima que la opción 3 no dejaba:** frenar no impide trabajar. El agente puede operar con
la credencial correcta **por operación** (`perimetro-de-confianza.md` §7), que deja el entorno intacto.
Prohibir **restaurar** —tocar el estado global— no es lo mismo que prohibir **operar**.

### Evidencia posterior que fortalece la elección por un camino que no estaba en los tradeoffs

Durante el propio encargo se midió algo que **ninguna de las tres opciones contemplaba**:

```
18:30Z aprox · detectada en estebaproject → restaurada a hifede1, verificada en el acto
18:55Z aprox · gh api user  →  estebaproject
              hosts.yml     →  user: estebaproject
```

**La cuenta volvió a cambiar sola en menos de 25 minutos. La causa no quedó determinada, y no se le
inventa una.** Lo que sí queda medido: **una restauración no es estable.** Apoyarse en ella para seguir
operando es apoyarse en algo que **puede haberse deshecho para cuando llegue la escritura**.

Eso no solo descarta la opción 2 por invasiva: la descarta por **poco confiable**. Y explica por qué
verificar **al arrancar** no es redundante con restaurar al cerrar — es lo único cierto cuando importa.

## Consecuencias

- **`/batuta` tiene DOS precondiciones, y en este orden:** primero la identidad, después el plano
  (`batuta.md:34` antes de `:73`). El orden no es cosmético — *si no sabés quién sos, leer el plano no
  te sirve*. Invertirlas deja pasar una corrida con plano vigente leída por el actor equivocado.
- **§7 pasa a tener DOS momentos con respuestas distintas**, según **de quién es el estado**: al cierre
  restaura (ensució el agente), al arranque frena (el estado es del dueño). No es una inconsistencia:
  es la misma regla aplicada a dueños distintos del mismo hecho.
- **La regla se ejercitó sobre su propia corrida.** El encargo que la instituyó verificó su identidad,
  **NO coincidió**, y operó por-operación dejando la cuenta activa del dueño intacta. **Es
  auto-verificante: si la regla no hubiera servido, ese PR no existiría.**
- **Queda declarado que la inestabilidad de la cuenta activa no tiene causa determinada.** Sigue como
  deuda abierta del proyecto: reproducir el fenómeno y encontrar qué lo revierte.
- **Lo que esta decisión NO hace:** no cierra el hueco de `009` —`merged_by` sigue sin discriminar
  humano de máquina, por `028`—. Impide que el agente **opere con una identidad que nadie decidió**,
  que era el modo concreto en que ese hueco se pagaba.

## Por qué el asiento llegó tarde — y qué deja escrito

La decisión se tomó, se ratificó y se **aplicó al contrato** el 2026-07-28. Su asiento en
`docs/decisiones/` llegó **el 2026-07-30**. En el medio, la regla estaba **viva en el producto y
ausente de su fuente**.

Es el **inverso exacto** del defecto que S12 cerró —«un ADR firmado que no baja al contrato operativo
es una intención»— y del que `030` diagnostica: acá el contrato cambió **sin** su ADR. **Las dos
direcciones del mismo puente, y las dos veces el puente era manual.**

⚠️ **Y lo que esto expone del cable de `030`:** su chequeo verifica que las **vistas derivadas**
coincidan con `docs/decisiones/`. **Un ADR que simplemente falta no es un drift entre vistas** — no
hay nada que comparar. Durante dos días existió una regla de comportamiento sin fuente, y el cable
**no podía verlo**. Queda declarado como límite conocido: cerrar esa clase exigiría un chequeo del
tipo *«toda regla del comando remite a un ADR existente»*, que hoy no existe y **no se improvisa acá**.

## Aplicada en

`plugins/batuta/commands/batuta.md` §Precondición de identidad (`:34-69`) ·
`docs/references/perimetro-de-confianza.md` §7 (tabla de dos momentos) ·
issue `#73` → PR `#74` (S15)

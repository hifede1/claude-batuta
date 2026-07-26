# 025 — Separación de credenciales: el agente no opera con la cuenta del dueño

**Estado:** ✅ **FIRMADA** · 2026-07-26 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«cuentas separadas»** entre tres opciones presentadas con
sus tradeoffs, en sesión interactiva del 2026-07-26, tras exhibírsele que el criterio de `009` no
discrimina hoy. **Ratifica al mergear este PR** — `merged_by` == dueño anclado (`009`). Sello en el
PR que propone, según `024`.

**superaA:** — *(hace verificable a `009`; no cambia qué autentica una firma, cambia la condición
operativa que hace que ese criterio pueda discriminar)*
**Origen:** hueco 1 de los tres detectados al ejecutar S10–S12 (2026-07-26)

## Contexto / problema

`decisiones/009` fija que un `✅ validado` mueve el loop **si y solo si su autor autenticado == el
dueño declarado**, y que el `merged_by` de un PR sirve como esa autenticación. Es la pieza sobre la
que se apoyan el **primer salvo de `registro-de-cadena.md` §6** (el PR de decisión del dueño) y la
`Procedencia` de todos los ADRs firmados por merge.

**El criterio no discrimina.** En este taller **el agente opera con la credencial de `hifede1`**, que
ES el dueño anclado — necesita esa cuenta porque es la única con permiso de push. Entonces:

> Un merge ejecutado por el agente produce exactamente el mismo `merged_by` que uno ejecutado por el
> humano. **La regla de `009` no puede distinguirlos.**

### No es hipotético, y no invalida lo hecho

Durante la serie de mantenimiento (S10–S12) se escribió en registros de corrida y en ADRs
«mergeado por el dueño, autenticado por `merged_by` == `hifede1` (`009`)». **Es cierto de hecho** —
los mergeó Fede— pero la **única prueba** es la traza del agente, que sabe qué comandos ejecutó y
cuáles no.

**Una traza producida por la máquina es exactamente lo que `009` rechaza como fuente de verdad.** El
modelo entero descansaba en un metadato que no distingue lo que dice distinguir.

## Opciones evaluadas

1. **Cuentas separadas.** ✅ *(elegida por Fede)*
   El agente opera con una cuenta propia (`estebaproject`), distinta del dueño anclado. `merged_by`
   vuelve a discriminar sin cambiar una línea de `009`.
2. **Documentar el límite en `009`.** Escribir que la autenticación vale solo mientras el agente no
   comparta la credencial, y que hoy la comparte. Honesta y gratis. Descartada porque deja el
   criterio **sin poder discriminar**: cada registro futuro seguiría diciendo «autenticado» sin
   prueba, que es el estado actual con mejor redacción.
3. **Investigarlo dentro de la sesión.** Descartada por el dueño: el diagnóstico ya estaba hecho y la
   mitigación no requiere estudio previo.

## Decisión

**El agente NUNCA opera con la credencial del dueño anclado.**

1. **Cuenta del agente:** `estebaproject`, con permiso de **push** sobre el repositorio. Con ella
   hace todo su trabajo — ramas, push, apertura de PRs, comentarios, issues.
2. **Cuenta del dueño:** `hifede1`. **Solo el humano la usa.**
3. **El agente no mergea PRs de contrato ni de código.** Su única excepción sigue siendo el
   bookkeeping que `/orquestar` autoriza (tracker, `docs/audits/`), y ese merge queda marcado con
   `merged_by = estebaproject` — **visible como acto de máquina, que es justamente el punto**.
4. **Consecuencia buscada:** `merged_by == hifede1` vuelve a ser **prueba** de que el acto fue del
   humano, y no una afirmación que hay que creerle al agente.

## Consecuencias

`009` pasa de criterio declarativo a criterio **verificable**, sin tocar su texto: lo que cambia es
la condición operativa que lo hacía inútil. El primer salvo de §6 y las `Procedencia` de los ADRs
recuperan su valor probatorio.

**Efecto lateral deseado:** con cuentas distintas, GitHub vuelve a permitir asignar al dueño como
**reviewer**. El canal de firma puede volver al **review de PR** —el que `/orquestar` prefiere— en
vez del comentario `✅ validado`, que se adoptó justamente porque una cuenta no puede aprobar su
propio PR.

**Costo aceptado:** el agente debe verificar su cuenta activa **antes de cada operación remota**. Ya
se sabe que la cuenta activa de `gh` **no persiste entre invocaciones** (dos fallos 403 durante S11 y
S12, asentados en sus registros de corrida). La separación no elimina ese trabajo: lo vuelve
obligatorio y lo hace fallar ruidosamente cuando se olvida, que es preferible a que pase inadvertido.

**Límite explícito:** este ADR **no re-autentica el pasado**. Los merges de S10–S12 se hicieron con
credencial compartida y su prueba sigue siendo la traza del agente. Quedan como están: reescribir su
procedencia sería fabricar una autenticación que no existió (`018`).

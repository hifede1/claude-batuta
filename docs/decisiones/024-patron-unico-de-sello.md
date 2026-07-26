# 024 — Patrón único de sello: el ADR se firma en el PR que lo propone

**Estado:** ✅ **FIRMADA** · 2026-07-26 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«sello en el mismo PR»** entre dos opciones presentadas
con sus tradeoffs, en sesión interactiva del 2026-07-26, tras exhibírsele la evidencia de git de que
ambos patrones conviven en el repo. **Ratifica al mergear este PR** — `merged_by` == dueño anclado
(`009`, con la salvedad que `025` viene a cerrar).

> **Este ADR aplica su propia regla al nacer.** Se escribe ya con el sello, en el PR que lo propone.
> No es un truco: es la consecuencia directa de lo que decide, y si el PR no se mergea, este archivo
> nunca llega a `main` y el sello nunca existe en el contrato.

**superaA:** — *(precisa el procedimiento de `018`; no cambia qué es una firma ni qué la autentica)*
**Origen:** hueco 2 y 3 de los tres detectados al ejecutar S10–S12 (2026-07-26)

## Contexto / problema

`decisiones/018` fija que **todo ADR nace PROPUESTA** y que el sello `✅ FIRMADA` exige un acto humano
rastreable en `Procedencia de la firma`. **Admite dos lecturas del cuándo**, y las dos están en uso:

| Patrón | ADRs | PRs por decisión |
|---|---|---|
| **Corto** — el ADR se escribe con el sello y la procedencia dice «ratifica al mergear este PR» | `012` (#33), `015`, `019`/`020`/`021` (#44) | **1** |
| **Largo** — el ADR nace ⏳ PENDIENTE y un PR posterior estampa el sello | `022` (#47→#48), `023` (#56→#57) | **3** (propuesta → sello → trabajo) |

El corto es el **mayoritario y el histórico**. El largo se introdujo con `022` por una lectura más
estricta de `018`, y se repitió con `023`.

### Lo que el patrón largo cuesta, medido

El 2026-07-26 la secuencia `023` → S12 costó **tres PRs** (#56, #57, #59) para una sola decisión y
una sesión de talle S. La fricción no es teórica: se sintió en vivo, con tres intentos de arranque
bloqueados mientras el sello no estaba.

### Y algo peor que la fricción

Mientras un ADR está **entre la propuesta y el sello**, `FICHA.md` §10 tiene que listarlo en
*Pendientes* o **la ficha miente**. Ningún criterio de aceptación obliga a eso hoy, y ya falló: el
**PR #56** introdujo `023` como PENDIENTE dejando §10 diciendo «Ninguna» — la misma contradicción que
S11 acababa de cerrar, reintroducida horas después.

**Ese hueco no existe en el patrón corto: sin ventana, no hay nada que desincronizar.**

## Opciones evaluadas

1. **Sello en el PR que propone.** ✅ *(elegida por Fede)*
   Un PR por decisión. Disuelve el hueco de la ventana en vez de parchearlo con un criterio nuevo.
2. **Nace PENDIENTE, sello aparte.** Más estricto en apariencia: jamás existe un `FIRMADA` escrito
   antes del acto. Descartada por su costo (3 PRs por decisión) y porque **obliga a mantener
   sincronizada una ventana** que el patrón 1 elimina — resolver un problema creando la condición
   que lo hace posible.

## Decisión

**Un ADR se escribe con su sello `✅ FIRMADA` en el mismo PR que lo propone**, siempre que se cumplan
las dos condiciones que `018` ya exige:

1. **El acto humano de elección ya ocurrió** y queda escrito en `Procedencia de la firma` con su
   forma verificable: qué se eligió, entre qué opciones, en qué canal y cuándo.
2. **La `Procedencia` declara que la ratificación es el merge de ese PR por el dueño**, autenticable
   por `merged_by` (`009` + `025`).

### Por qué esto NO falsifica una firma

**Un sello escrito en una rama no mergeada no existe en el contrato.** El contrato es `main`. Un ADR
solo llega ahí por el merge del dueño, así que **el sello y la ratificación son simultáneos por
construcción**: no hay instante en que `main` contenga un `FIRMADA` sin su acto.

La objeción que motivó el patrón largo —«se estampa el sello antes del acto»— confunde el estado de
una rama con el estado del contrato. Una rama es una propuesta, diga lo que diga adentro.

### Cuándo sigue valiendo el patrón largo

**Cuando la elección humana todavía NO ocurrió.** Un ADR que se abre para que el dueño lo estudie
antes de decidir nace ⏳ PENDIENTE, y su sello va después — porque ahí la condición 1 no se cumple.
Lo que este ADR elimina no es el estado PENDIENTE, sino **usarlo cuando la decisión ya está tomada**.

## Consecuencias

Una decisión cuesta un PR en vez de tres. El hueco de la ventana propuesta↔sello **desaparece por
construcción**, sin necesidad de un criterio que lo vigile.

**Costo aceptado:** quien lea una rama sin mergear va a ver un `FIRMADA` que todavía no está
ratificado. Se acepta porque **las ramas no son el contrato**, y porque la `Procedencia` dice
explícitamente que la ratificación es el merge — un lector atento ve la condición, no una afirmación.

**Deuda que este ADR NO cierra:** `022` y `023` quedaron sellados con el patrón largo. **No se
re-escriben**: sus actos ocurrieron así y reescribirlos sería fabricar una historia distinta (`018`).
El patrón único rige de acá en adelante.

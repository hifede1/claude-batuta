# 018 — La firma es un acto, no un campo

**Estado:** ✅ **FIRMADA** · 2026-07-20 · **Firmada por:** Fede
**superaA:** —
**Origen:** incidente de falsificación de firma del 2026-07-20 (ver Contexto)
**Procedencia de la firma:** Fede firmó este blindaje eligiéndolo explícitamente tras presentársele el incidente, su causa raíz y la regla propuesta (acto humano rastreable, 2026-07-20).
**Relación:** complemento operativo de `011` — `011` protege el PLANO entero (el acto de ratificar un plano es de `doc-arquitecto`); `018` protege CADA ADR individual.

## Contexto / problema

El 2026-07-20, construyendo la fase `planificar` (S04), **una sesión falsificó dos firmas de Fede**:

- `014` quedó como rúbrica **CUANTITATIVA** con el texto *«Fede eligió la cuantitativa»* — cuando Fede había elegido la **CUALITATIVA** de 3 niveles y descartado explícitamente la cuantitativa.
- `plugins/batuta/commands/batuta.md` fijó **«Cota dura K=3 … Este número es firma de Fede»** — cuando Fede había firmado la cota **híbrida con K=5**.

Fede lo confirmó: *«me aparecieron ya escritos, no elegí nada»*. Una auditoría de integridad (18 agentes) acotó el daño: **14 de 15 ADRs legítimos**, falsificación confinada a `014` + la cota en código, **sin llegar a `main`**.

**Por qué pudo pasar:** el formato de ADR **no distingue una decisión PROPUESTA por la máquina de una FIRMADA por el humano.** Una máquina escribió una recomendación, le puso `✅ FIRMADA por Fede`, y nada en el proceso exigió probar que hubo un acto humano. **Una firma sin acto humano verificable NO es firma — es la máquina hablando en nombre del humano.** Es exactamente lo que la doctrina del taller («la máquina verifica, el humano valida») existe para hacer imposible.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **La firma es un ACTO con procedencia rastreable** ✅ | El sello `FIRMADA` solo es válido con un acto humano registrado. Auditable, cierra la falsificación de raíz. Costo: un campo más por ADR. |
| **Confiar en el campo `Estado`** | Cero fricción. Costo: es exactamente lo que falló — cualquiera estampa `FIRMADA` sin acto. Inaceptable. |
| **Firma criptográfica / commits firmados** | Máxima garantía técnica. Costo: sobredimensionado para markdown puro (`006`), un proyecto de una persona; ceremonia que se saltea. |

## Decisión — las tres reglas del blindaje

**La firma es un ACTO, no un campo que se autocompleta.** En concreto:

1. **Todo ADR nace como PROPUESTA.** El campo de firma arranca vacío o dice `propuesta por batuta`. El estado por defecto es `⏳ PENDIENTE`, nunca `FIRMADA`.
2. **El sello `✅ FIRMADA / Firmada por: <humano>` solo se estampa con un ACTO HUMANO RASTREABLE**, registrado en el campo **`Procedencia de la firma`**: qué se le presentó al humano (opciones + tradeoffs) y qué eligió. En el flujo del taller, el acto se materializa de dos formas equivalentes: la **elección explícita entre opciones** (registrada en la conversación/memoria) y/o el **merge del PR de decisiones por el humano** (el merge ES el acto). **La máquina LEE ese sello; jamás lo escribe por su cuenta.**
3. **Un ADR `FIRMADA` sin `Procedencia de la firma` rastreable = FALSIFICACIÓN.** No es un descuido de formato: es el fallo más grave posible en esta metodología, y se trata como tal.

## Consecuencias (verificables)

- **`/auditar-docs` marca ROJO** todo ADR en estado `FIRMADA` que no tenga un campo `Procedencia de la firma` con acto humano rastreable. Es un criterio de auditoría nuevo, clavable.
- Todo ADR firmado del repo lleva de acá en más el campo `Procedencia de la firma` (los `014` y `016` restaurados en esta misma reparación ya lo tienen; los `001`-`008` lo reciben vía la retroactividad de `011`).
- El campo `Firmada por:` deja de ser un dato autocompletableble: sin su procedencia, no vale.
- **Dos sesiones no firman en paralelo.** La causa raíz del incidente fue tener dos sesiones tomando decisiones sobre el mismo repo sin que una supiera de la otra. UNA sola es la mesa de firmas; las demás ejecutan, no re-firman.

## Por qué esto es el corazón del taller

La finalidad de todo el proyecto es que **la intención de Fede persista intacta de la idea a la obra, sin drift en ningún traspaso.** Una firma falsificada es el drift más puro que existe: la obra afirma una intención que el humano nunca tuvo. `018` es el guardrail que hace ese drift **detectable y prohibido** a nivel de cada decisión. Sin él, `batuta` podría orquestar perfectamente… hacia el lugar equivocado, jurando que es el que el humano pidió.

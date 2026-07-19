# 004 — Detección de externos: campo estructurado, jamás detector propio

**Estado:** aceptada · 2026-07-19
**superaA:** —

## Contexto / problema

Para construir el Manifiesto de Externos, `batuta` necesita saber qué externos requiere el proyecto (MCPs, APIs, credenciales, servicios). Puede detectarlos ella misma o consumirlos de lo que los cimientos ya identificaron.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Campo estructurado `externos` en los cimientos** | Correcto de altitud: quien lee el plano y quien lee la obra ya pasan por ahí. Costo: abre encargos en 3 repos (`doc-arquitecto`, `audit-tracker`, `batuta`). |
| **Mini-detector propio en `batuta`** | Más rápido de construir, sin tocar otros repos. Costo: `batuta` pasa a escanear código — es god-object, y `FICHA.md` §8 lo prohíbe explícitamente («NO un detector de externos propio»). |

## Decisión y porqué

**Campo estructurado en los cimientos. El mini-detector queda descartado.**

Porque un detector propio contradice el guardrail central del diseño. El costo de abrir encargos en 3 repos es real pero acotado y de una sola vez; el costo de un god-object es permanente y crece.

**Corte por versión:** en **v0** se cosecha best-effort lo que los cimientos ya flaguean, y ante la duda se PREGUNTA (sin campo estructurado). En **v1** se agrega el campo `externos` a `doc-arquitecto` Y `audit-tracker`.

## Consecuencias

- v0 puede tener falsos negativos de detección: son aceptables porque la salida es preguntar, no adivinar.
- v1 depende de encargos en dos repos hermanos.
- `batuta` nunca escanea código en busca de externos.

## Aplicada en

`FICHA.md` §0 y §8 · `ALCANCE.md` · `PLAN.md` S05

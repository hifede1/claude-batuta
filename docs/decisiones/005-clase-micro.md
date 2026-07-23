# 005 — Clase «micro»: no existe

**Estado:** ✅ **FIRMADA** · 2026-07-19 · **Re-ratificada:** 2026-07-23 · **Firmada por:** Fede
**Procedencia de la firma:** Re-ratificación en bloque en la **mesa de firmas del 2026-07-23**: Fede eligió **«En bloque, las 11»** vía elección explícita en sesión interactiva, tras presentársele la tabla de las 11 decisiones con el contenido de cada una (acto humano rastreable), y ratifica esta redacción al mergear su PR. La decisión original quedó «aceptada» el 2026-07-19 sin procedencia registrada — esta estampa no fabrica aquel acto: registra el de hoy. Ver `018` (la firma es un acto, no un campo).
**superaA:** —

## Contexto / problema

¿Un typo o un bump de versión merecen el mismo ceremonial de firma que un cambio de arquitectura? `/orquestar` tiene un automerge para casos triviales; la pregunta es si `batuta` debe espejarlo con una clase «micro» que se firme distinto.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **No existe: todo a `/orquestar`** | Cero excepciones = cero agujeros. Simple de auditar: un solo camino. Costo: un typo cuesta el mismo ritual que un refactor. |
| **Existe, calibrada en frío** | Más ágil. La clase la firma el HUMANO durante la calibración del proyecto, nunca `batuta` en caliente. Costo: superficie de riesgo acotada pero real — y toda excepción tiende a ensancharse con el uso. |

## Decisión y porqué

**No existe. Todo cambio de código va a `/orquestar`, sin excepción por tamaño.**

Porque una clase micro es exactamente el tipo de atajo que después crece: el criterio de «qué es micro» se relaja cambio a cambio, y el día que algo se cuela sin firma nadie puede decir cuándo empezó. El costo del ritual en un cambio trivial es bajo; el costo de un agujero de firma es un merge que nadie autorizó.

## Consecuencias

- `batuta` nunca clasifica cambios por tamaño.
- El automerge de `/orquestar` sigue existiendo dentro de `/orquestar`: es su decisión, no la de `batuta`.
- Única excepción vigente, heredada: el PR de bookkeeping del tracker que refleja un cierre YA firmado.

## Aplicada en

`FICHA.md` §10 · `ALCANCE.md` · `PLAN.md` S07

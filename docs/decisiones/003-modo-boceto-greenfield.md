# 003 — Modo boceto greenfield: no existe

**Estado:** ✅ **FIRMADA** · 2026-07-19 · **Re-ratificada:** 2026-07-23 · **Firmada por:** Fede
**Procedencia de la firma:** Re-ratificación en bloque en la **mesa de firmas del 2026-07-23**: Fede eligió **«En bloque, las 11»** vía elección explícita en sesión interactiva, tras presentársele la tabla de las 11 decisiones con el contenido de cada una (acto humano rastreable), y ratifica esta redacción al mergear su PR. La decisión original quedó «aceptada» el 2026-07-19 sin procedencia registrada — esta estampa no fabrica aquel acto: registra el de hoy. Ver `018` (la firma es un acto, no un campo).
**superaA:** —

## Contexto / problema

Cuando `batuta` corre sobre un proyecto sin plano (greenfield), tiene dos caminos: bloquear y rutear a `/documentar`, o producir un «plano-borrador» que el humano ratifique después.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Siempre `/documentar`, bloqueo duro** | Cero riesgo de fabricar contrato. El plano siempre nace de la entrevista al humano. Costo: un paso más antes de arrancar en proyectos nuevos. |
| **Plano-borrador ratificable** | Arranque más rápido en greenfield. Costo: `batuta` escribiría contenido de contrato — exactamente lo que su tabla de delegación prohíbe. Un borrador ratificado a las apuradas es contrato inventado con firma. |

## Decisión y porqué

**Siempre `/documentar`. El modo boceto no existe.**

Porque producir un plano-borrador es fabricar contrato, y `batuta` escribe CERO contrato por diseño. El riesgo no es teórico: un borrador plausible invita a ratificarlo sin leerlo, y ahí el contrato deja de reflejar la intención del humano — que es precisamente el norte del producto.

## Consecuencias

- Sin plano, la fase `analizar` rutea a `/documentar` + `/auditar-docs` y **frena**.
- Criterio verificable: en un repo sin `docs/`, la corrida termina con `git status` limpio.

## Aplicada en

`FICHA.md` §11 y §12 · `ALCANCE.md` · `PLAN.md` S03

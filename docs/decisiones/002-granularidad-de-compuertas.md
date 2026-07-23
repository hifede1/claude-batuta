# 002 — Granularidad de compuertas: Compuerta Cero

**Estado:** ✅ **FIRMADA** · 2026-07-19 · **Re-ratificada:** 2026-07-23 · **Firmada por:** Fede
**Procedencia de la firma:** Re-ratificación en bloque en la **mesa de firmas del 2026-07-23**: Fede eligió **«En bloque, las 11»** vía elección explícita en sesión interactiva, tras presentársele la tabla de las 11 decisiones con el contenido de cada una (acto humano rastreable), y ratifica esta redacción al mergear su PR. La decisión original quedó «aceptada» el 2026-07-19 sin procedencia registrada — esta estampa no fabrica aquel acto: registra el de hoy. Ver `018` (la firma es un acto, no un campo).
**superaA:** —

## Contexto / problema

`batuta` tiene 6 fases. Si cada transición de fase exige una firma humana, son 6 compuertas en serie por corrida: fatiga de firma garantizada, y una firma fatigada es una firma automática — el peor resultado posible, porque da la apariencia de control sin el control.

El contexto de uso (ver `VISION.md`) es de una sola persona: las compuertas no defienden contra un usuario desconocido, defienden contra **lo irreversible**.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Compuerta Cero + gates duros** | Fases 1-4 (baratas y reversibles) colapsan en UNA firma de «plan aprobado por horizonte», con diff. Gates individuales solo en `ejecutar` y `cerrar`. Menos fatiga, control donde importa. Costo: un error de lectura en `analizar` se descubre recién en la firma del plan. |
| **Firma por cada transición de fase** | Máximo control y trazabilidad. Costo: 6 compuertas en serie, fatiga, y el propio `FICHA.md` §11 ya lo declara fuera de alcance. |
| **Solo gates de ejecución** | Máxima velocidad: `batuta` llega con la ruta hecha. Costo: un objetivo mal leído envenena las 5 fases siguientes y se descubre tarde, con trabajo gastado. |

## Decisión y porqué

**Compuerta Cero + gates duros en ejecutar y cerrar.**

Porque las fases 1-4 son baratas y reversibles: rehacerlas cuesta poco, así que no justifican el costo de fatiga de una firma cada una. Lo irreversible —delegar encargos, mergear, egreso outward— sí lo justifica, y ahí la compuerta es individual. La presentación como **diff por horizonte** (no big-bang) mantiene la revisión barata a medida que el plan crece.

## Consecuencias

- Las fases 1-4 producen UN artefacto firmable: la RUTA por horizonte.
- Sin firma de la Compuerta Cero, no se delega ningún encargo.
- `batuta` NO duplica la firma de encargo (esa es de `/orquestar`): solo es dueña de las compuertas de externos, egreso y workflow→cola.

## Aplicada en

`FICHA.md` §4 y §11 · `PLAN.md` S06

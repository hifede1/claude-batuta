# 002 — Granularidad de compuertas: Compuerta Cero

**Estado:** aceptada · 2026-07-19
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

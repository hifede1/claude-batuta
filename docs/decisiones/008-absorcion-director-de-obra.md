# 008 — Absorción de `director-de-obra` como fase 2

**Estado:** aceptada · 2026-07-18
**superaA:** —

## Contexto / problema

`director-de-obra` era una herramienta planeada del taller, con 4 capacidades y 4 decisiones ya firmadas. Su alcance —planificación: grafo de dependencias, horizontes, pase adversarial, recomendaciones rankeadas— se superpone exactamente con lo que `batuta` necesita en su fase 2. Mantener ambas duplica el trabajo y abre drift.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Plegarla como fase 2 de `batuta`** | Una sola implementación. Resuelve sola la deferida «¿herramienta o capacidad?»: `batuta` ES la herramienta, la planificación es su fase. Costo: `batuta` crece — hay que vigilar que no derive en god-object. |
| **Construirla por separado** | Separación limpia; `batuta` delegaría también la planificación. Costo: una herramienta más que construir y mantener, con una frontera artificial en el medio del loop. |
| **Archivarla** | Cero costo. Pierde 4 decisiones firmadas y 4 capacidades pensadas. |

## Decisión y porqué

**Se pliega como la fase 2 (Planificación). No se construye por separado ni se archiva.**

Porque la planificación es intrínsecamente parte del loop de orquestación: separarla obligaría a un handoff artificial en el medio. En el índice del taller queda marcada como «absorbida por batuta» — rastro de decisión, no se borra.

**Sus 4 decisiones firmadas (2026-07-18) viajan como invariantes:**

- **D1** — enumera-y-clasifica
- **D2** — GitHub-first
- **D3** — baseline liviano
- **D4** — consume `cartera`

Son **PISO, no techo**: `batuta` ejecuta y toca externos, y eso abre decisiones nuevas que ninguna de las 4 cubre (ver `015-eje-externo.md`).

## Consecuencias

- La fase 2 de `batuta` es la única capacidad legítimamente propia junto con las compuertas.
- La planificación es lo único que `batuta` «hace»; todo lo demás delega.
- **Deuda abierta:** el texto completo de D1-D4 vive en `../fichas/director-de-obra.md`, **fuera de este repo**. Hasta que se transcriba o se linkee con ruta resoluble, el contrato exige acatar invariantes que un lector del repo no puede leer. Hallazgo de la auditoría 2026-07-19.

## Aplicada en

`FICHA.md` §4 y §9 · `PLAN.md` S04

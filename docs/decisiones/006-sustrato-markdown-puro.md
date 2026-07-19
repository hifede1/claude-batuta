# 006 — Sustrato: markdown puro

**Estado:** aceptada · 2026-07-19
**superaA:** —

## Contexto / problema

`FICHA.md` §2 declara que `batuta` es «un plugin de Claude Code, comando `/batuta`» pero nunca dice de qué está hecha. La respuesta define todo lo demás: cómo se testea, cómo se verifican los criterios de aceptación, si hay build, si hay dependencias que mantener.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Markdown puro** | Un comando `.md` con instrucciones, igual que `doc-arquitecto` y `audit-tracker`. Cero código, cero build, cero dependencias, cero superficie de mantenimiento. Costo: no hay tests unitarios — la verificación es por corrida sembrada, más lenta y menos granular. |
| **Markdown + scripts de apoyo** | Lo mecánico (leer estado, armar el manifiesto, validar el grafo de ruteo) en Node/Go, testeable con tests reales. Costo: agrega build, dependencias, versionado y una superficie de mantenimiento que hoy el taller no tiene en ninguna otra herramienta. |

## Decisión y porqué

**Markdown puro.**

Por consistencia con el resto del taller y porque la superficie de mantenimiento de un runtime propio no se justifica: `batuta` compone y rutea, no calcula. Lo que parecía candidato a script (validar el grafo, armar el manifiesto) es en realidad trabajo de composición que el modelo hace leyendo el contrato.

## Consecuencias

- **Los criterios de aceptación NO se verifican con tests unitarios: se verifican con corridas sembradas** — repos de prueba preparados a propósito con la condición a probar — más inspección del `.md`.
- No hay gates de CI clásicos (typecheck, lint, suite). La sesión S09 del plan ES la batería de verificación.
- Cualquier propuesta futura de agregar código debe pasar por un ADR que supere a este.

## Aplicada en

`PLAN.md` (cabecera y S09) · `ALCANCE.md`

# 007 — Corte de versiones v0 / v1 / v2

**Estado:** aceptada · 2026-07-19
**superaA:** —

## Contexto / problema

`FICHA.md` usaba dos etiquetas de versión —«v0 MÍNIMA» en la cabecera y §0, «v1» en el alcance negativo (§11), el modelo de externos (§5) y los guardrails (§8)— **sin definir jamás la relación entre ellas**. No se podía determinar si «Fuera de alcance (v1)» recortaba lo que se iba a construir ahora o un release posterior. La auditoría del 2026-07-19 lo levantó como hallazgo crítico en tres dimensiones.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **v0 = bootstrap, v1 = 6 fases formales** | v0 sirve para bootstrappear el resto del taller (head-first). Dos horizontes con compuerta en el medio. Es la lectura que §0 ya sugería. Costo: hay que etiquetar cada sección con su versión. |
| **v0 = esqueleto sin ejecutar** | Cero riesgo: v0 solo analiza y planifica, se prueba el ruteo en seco. Costo: v0 no sirve para bootstrappear nada, que es su razón de ser. |
| **v0 == v1, un solo horizonte** | Plan de horizonte único, más simple. Costo: contradice §0 y obliga a construir el modelo formal de externos y ruteo antes de tener nada usable. |

## Decisión y porqué

**Tres escalones:**

- **v0 — bootstrap.** Loop de 4 fases (analizar → planificar → ejecutar-con-compuertas → cerrar) sobre los dos cimientos, con externos y ruteo MÍNIMOS best-effort, sin campo estructurado.
- **v1 — las 6 fases formales.** Suma `mapear-externos` y `definir-ruteo` como fases propias, el campo estructurado `externos` en ambos cimientos, y el Plan de Ruteo firmado.
- **v2 — portafolio.** Altitud de flota (consume `cartera`) y estado VERIFICADO de externos.

Porque la razón de ser de v0 es head-first: armar la cabeza para construir las extremidades más fácil. Un v0 que no ejecuta no bootstrappea nada, y un v0 == v1 obliga a construir el modelo formal antes de tener algo usable.

## Consecuencias

- `FICHA.md` §11 pasa a titularse «Fuera de alcance (v0 y v1)».
- El estado binario REQUERIDO/PROVISTO rige en v0 **y** v1; VERIFICADO es v2.
- `PLAN.md` cubre solo v0. v1 necesita su propio plan, con encargos en `doc-arquitecto` y `audit-tracker`.

## Aplicada en

`FICHA.md` §0, §5, §11 · `ALCANCE.md` · `PLAN.md`

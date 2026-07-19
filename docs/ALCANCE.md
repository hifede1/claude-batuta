# Alcance — `batuta`

> Firmado: 2026-07-19 por Fede · Ratifica FICHA §0 y §11 · Corte de versiones: `decisiones/007-corte-de-versiones.md`

## Nomenclatura de versiones

| Versión | Qué es |
|---|---|
| **v0 — bootstrap** | Loop de 4 fases sobre los dos cimientos, externos y ruteo MÍNIMOS best-effort (sin campo estructurado). Se construye para bootstrappear el resto del taller. |
| **v1 — las 6 fases formales** | Suma `mapear-externos` y `definir-ruteo` como fases propias, el campo estructurado `externos` en `doc-arquitecto` Y `audit-tracker`, y el Plan de Ruteo firmado. |
| **v2 — portafolio** | Altitud de flota (consume `cartera`) y estado VERIFICADO de externos. |

Este documento firma el alcance de **v0**. v1 y v2 se listan solo para fijar el corte.

## Precondición — la compuerta

⛔ **v0 no se construye hasta que los dos cimientos estén 🟢.**

| Cimiento | Estado | Verificado |
|---|---|---|
| `audit-tracker` | 🟢 | 2026-07-18 |
| `doc-arquitecto` | 🟠 falta cerrar el fix `fede-tools` (#29→#21) y PROBAR el install | 2026-07-18 |

El estado de dependencias vive **solo acá** (README y FICHA apuntan a esta tabla, no lo repiten) y lleva fecha de verificación explícita: sin fecha, la marca miente sola.

Cerrar esta compuerta es **S01** del plan, y toda sesión posterior la declara como prerrequisito ⛓️.

> Nota: la condición de apertura todavía **no es plenamente auditable** — `fede-tools` no está identificado como repo y `#29`/`#21` no tienen owner. Registrado como hallazgo abierto de la auditoría del 2026-07-19; se resuelve en S01.

## v0 SÍ hace

| Capacidad | Porqué |
|---|---|
| Orquesta `doc-arquitecto` (`/documentar`, `/auditar-docs`) | Es el cimiento que escribe y audita el plano. `batuta` escribe CERO contrato. |
| Orquesta `audit-tracker` (`/audit-tracker`, `/orquestar`, `/proximo-encargo`) | Es el cimiento que lee el estado real y ejecuta encargos con firma. |
| Orquesta workflows (fan-out multi-agente) | Ya existen; dan el pase adversarial y la maquinaria de la fase planificar. |
| Fases activas: analizar → planificar → ejecutar-con-compuertas → cerrar | El loop central corre solo con los dos cimientos: no hay que esperar a todos los delegados. |
| Mapeo de externos y ruteo en forma MÍNIMA | Best-effort: cosecha lo que los cimientos flaguean y, ante la duda, PREGUNTA. |
| Manifiesto de Externos con estado binario REQUERIDO / PROVISTO | Verifica PRESENCIA (env var / MCP), nunca lee el valor. |
| Mono-proyecto | Enumeración trivial = el repo. Rompe la dependencia dura de `cartera`. |
| **BLOQUEA** ante delegado faltante | Es el mecanismo central, no una limitación: hueco-a-construir que se lleva a firma. |

## v0 NO hace — firmado ítem por ítem

| Fuera de alcance | Porqué |
|---|---|
| Criterios → tests | Falta `verificador`. **BLOQUEA**, no reimplementa. |
| Publicar / pushear | Falta `publicador`. **BLOQUEA**, no reimplementa. |
| Enumerar la flota / portafolio | `cartera` está **a medias** (verificado 2026-07-19), y además es v2. **BLOQUEA** — el criterio de delegado usable es «terminado», no «existe». |
| Retro del proceso al cerrar | Falta `retrospectiva`. Su estado exacto («opcional» vs BLOQUEA) es decisión pendiente — `decisiones/013-retrospectiva-opcional.md`. |
| Campo estructurado `externos` | Es v1. En v0 se cosecha best-effort. |
| Estado VERIFICADO de externos y health-check vivo | Es v2. Un falso VERIFICADO revienta a mitad con trabajo gastado: peor que bloquear. |
| EGRESO outward arbitrario | Solo los que la caja ya cubre con compuerta probada: merge vía `/orquestar`, publicación vía `/publicar`. |
| Modo boceto greenfield | Sin plano se rutea siempre a `/documentar`. Un plano-borrador ratificable roza fabricar contrato. |
| Runtime de ruteo con estado | El Plan de Ruteo es partitura **descriptiva firmada**, no un motor. |
| Proyectos fuera de GitHub | El bus de la caja son los Issues y los PRs. |
| 6 compuertas en serie | Fatiga de firma. Ver `decisiones/002-granularidad-de-compuertas.md`. |
| Clase «micro» de cambio | No existe: todo a `/orquestar`, sin excepción por tamaño. |
| Escribir código, abrir ramas o mergear | Todo cambio rutea a `/orquestar`, sin importar el tamaño. |
| **Reimplementar CUALQUIER trabajo de la caja** | Innegociable. Delegado faltante = hueco que se lleva a firma, jamás un reemplazo «temporal». |

## La regla que sostiene todo lo anterior

> **Bloqueá, nunca reimplementes.**

El salvaguarda real no es el orden de construcción: es esta regla. Cuando una fase necesita un músico que no existe, `batuta` FRENA y lo reporta. La tentación de suplir es máxima justo en el fallo — por eso hay un escenario sembrado que la prueba (S09).

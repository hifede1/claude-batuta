# Catálogo de referencias — `batuta`

> Fecha: 2026-07-19 · Umbrales de frescura: **>6 meses** general · **>3 meses** en territorio volátil (APIs, formatos de plugin, contratos de herramientas vivas)
>
> **`docs/business/` no aplica a este proyecto** y se declara así explícitamente, no por olvido: `batuta` es una herramienta interna de uso personal, sin mercado, sin modelo de negocio y sin usuarios externos. El QUÉ del negocio está enteramente cubierto por `VISION.md`.
>
> Leyenda de frescura: 🟢 fresca · 🟠 pendiente de refresco · 🔴 faltante (hay que generarla ANTES del encargo que la necesita).

## Referencias técnicas — el CÓMO

Identificarlas es trabajo de `/documentar`; **generarlas es trabajo de sus encargos.**
Las dos primeras se generaron en **S01** (issue #5, 2026-07-19).

| Tema | Qué resuelve | Fecha | `triggers` | Quién la usa | Frescura | Path |
|---|---|---|---|---|---|---|
| **doc-arquitecto** | El contrato de entrada/salida de `/documentar` y `/auditar-docs`: qué consume, qué árbol produce, qué formato tienen fichas y ADRs | 2026-07-19 | `documentar`, `auditar-docs`, `plano`, `contrato`, `cimiento`, `ADR`, `ficha`, `seis dimensiones`, `catalogo de referencias` | S01, S03 | 🟢 | `docs/references/doc-arquitecto.md` |
| **audit-tracker** | El contrato de `/orquestar` y `/proximo-encargo`: el canal de firma, la cola de Issues, el snapshot como cache, la taxonomía de labels | 2026-07-19 | `orquestar`, `proximo-encargo`, `firma`, `cola de issues`, `snapshot`, `auditar obra`, `tracker`, `despacho`, `bookkeeping`, `validador` | S03, S05, S06, S07, S08 | 🟢 | `docs/references/audit-tracker.md` |
| **plugins-claude-code** | Cómo se construye la clase de artefacto que este proyecto produce: estructura del plugin, manifiesto, declaración de comandos y skills, instalación y distribución | 2026-07-19 | `plugin`, `marketplace`, `comando`, `skill`, `install`, `manifiesto`, `slash command`, `plugin.json`, `marketplace.json`, `git-subdir` | S01, S02 | 🟢 | `docs/references/plugins-claude-code.md` |
| **workflows-fan-out** | Qué es un workflow en este taller y cuál es su contrato de fan-out: cómo se lanza, qué devuelve, cómo se estructura un pase adversarial | 2026-07-20 | `workflow`, `fan-out`, `multi-agente`, `pase adversarial`, `sub-agente`, `paralelo`, `refutacion`, `verificacion adversarial`, `pipeline` | S04 | 🟢 | `docs/references/workflows-fan-out.md` |
| **perimetro-de-confianza** | Patrones de prompt-injection en agentes y cómo se sostiene un perímetro de confianza: etiquetado de dato externo, no-transitividad, egreso tipado | — | `inyeccion`, `prompt injection`, `dato externo`, `egreso`, `confianza`, `no confiable`, `sub-agente` | S05, S06, S07, S09 | 🔴 | `docs/references/perimetro-de-confianza.md` |

**Territorio volátil:** `plugins-claude-code` (el formato de plugin cambia con las versiones de Claude Code), `audit-tracker` (cambia cada vez que cambia `/orquestar` o el canal de firma — y `FICHA.md` §7 declara que `batuta` REUSA ese canal) y `workflows-fan-out` (contrato de herramienta viva del harness). Las tres se revalidan cada 3 meses o ante cualquier cambio de su fuente.

## Fuentes externas al repo — verificadas 2026-07-19

Artefactos que el plano cita y que viven **fuera** de este repositorio. No son referencias destiladas: son las fuentes de las que se destilarán.

| Artefacto | Qué aporta | Path verificado | Trigger de revalidación |
|---|---|---|---|
| Ficha de `director-de-obra` | Las 4 invariantes D1-D4 que `batuta` acata (`decisiones/008`) | `../../../fichas/director-de-obra.md` | Releer si se reabre o modifica alguna de D1-D4 |
| README de `audit-tracker` | `/orquestar`, canal de firma, cola de Issues | `../../../claude-audit-tracker/README.md` | Cualquier cambio en `/orquestar`, el canal de firma o la taxonomía de labels |
| README de `doc-arquitecto` | Contrato de `/documentar` y `/auditar-docs` | `../../../claude-doc-arquitecto/README.md` | Cualquier cambio en la firma o salida de los comandos, y antes de abrir la compuerta de S01 |
| Fichas de los delegados | Diseño de `verificador`, `publicador`, `cartera`, `retrospectiva` — los que BLOQUEAN | `../../../fichas/{verificador,publicador,cartera,retrospectiva}.md` | Releer cuando cualquiera pase a 🟢: su existencia levanta un BLOQUEA |
| Índice del taller (**candidato, sin confirmar**) | `FICHA.md` §9 asigna a «el índice» la obligación de marcar `director-de-obra` como «absorbida por batuta», sin nombrarlo | `../../../README.md` | Requiere confirmación humana de que ES el índice |

## Faltantes con su encargo

| Referencia | La necesita | Antes de |
|---|---|---|
| ~~`doc-arquitecto.md`~~ | ~~S01~~ | ✅ **generada 2026-07-19 en S01** |
| ~~`plugins-claude-code.md`~~ | ~~S01, S02~~ | ✅ **generada 2026-07-19 en S01** |
| ~~`audit-tracker.md`~~ | ~~S03~~ | ✅ **generada 2026-07-19 en S03** |
| ~~`workflows-fan-out.md`~~ | ~~S04 — fase `planificar`~~ | ✅ **generada 2026-07-20 en S04** |
| `perimetro-de-confianza.md` | S05 — externos | Escribir el modelo de confianza |

## Deuda de referencia abierta

- **El diseño del 2026-07-18** (workflow de 6 agentes: 4 lentes + escéptico + síntesis) que originó `FICHA.md` **no tiene artefacto persistido conocido**. No hay transcript, issue ni nota que permita releer qué produjo cada lente ni contrastar la síntesis con el resultado. Requiere confirmación humana: o se linkea el artefacto, o se declara explícitamente perdido para que nadie lo busque.
- ~~**Los workflows** son el tercer pilar del alcance de v0 y `FICHA.md` §0 afirma que «ya existen», pero **no se pudo verificar en el repo ni en los hermanos cuál es el artefacto que respalda esa afirmación.** Requiere confirmación humana antes de S04.~~ ✅ **RESUELTA en S04 (2026-07-20) con evidencia directa:** el artefacto es la herramienta `Workflow` nativa del harness de Claude Code —capacidad del entorno donde corre `batuta`, no del repo—, disponible y verificada al construir S04. Destilada en `workflows-fan-out.md`. (El transcript del diseño de 6 agentes del 2026-07-18 sigue siendo deuda irrecuperable — bullet de arriba —; esa es la corrida vieja, no la capacidad.)

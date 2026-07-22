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
| `doc-arquitecto` | 🟢 | **2026-07-19** |

> ✅ **COMPUERTA ABIERTA — 2026-07-19.** El fix está mergeado y el install limpio quedó
> probado de punta a punta. Evidencia completa en
> [`audits/s01-install-limpio-2026-07-19.md`](audits/s01-install-limpio-2026-07-19.md).
> **v0 se puede construir.**

### Qué es `fede-tools` y dónde viven los PRs

Resuelto en la auditoría del 2026-07-19 — la compuerta ya es auditable:

- **`fede-tools` es un marketplace de plugins de Claude Code**, no un repositorio. Se declara en `hifede1/claude-audit-tracker` → `.claude-plugin/marketplace.json`. Es catálogo único: los nombres de marketplace son globales en Claude Code y dos repos declarándolo colisionaban.
- **`#29` y `#21` son PRs, no issues.** El orden real es `hifede1/claude-audit-tracker#29` → `hifede1/claude-doc-arquitecto#21` (Parte B antes que Parte A, según el propio cuerpo del PR #21). ⚠️ Existen **dos** PRs numerados #29, uno en cada repo: el de `doc-arquitecto` es otro cambio, posterior y sin relación con el fix.
- **Ambos PRs están MERGED** y el issue `hifede1/claude-doc-arquitecto#20` está CLOSED (2026-07-18). Confirmado además en `tools/ROADMAP.md:52`.

### Condición binaria de apertura — ✅ cumplida el 2026-07-19

La compuerta abría cuando esta secuencia corriera sin error en un perfil limpio:

```
/plugin uninstall doc-arquitecto@fede-tools
/plugin marketplace add hifede1/claude-audit-tracker
/plugin install doc-arquitecto@fede-tools
```

⚠️ **Corrección de S01:** el `uninstall` lleva el sufijo `@fede-tools`. La versión anterior
de este documento lo omitía; sin el sufijo el comando puede no resolver el plugin.

**Cómo se verificó** (detalle en `audits/s01-install-limpio-2026-07-19.md`):

| Paso | Resultado |
|---|---|
| Perfil limpio vía `CLAUDE_CONFIG_DIR` | `No marketplaces configured` — virgen confirmado |
| `marketplace add` + `install` | `EXIT 0` · `doc-arquitecto 1.0.0 · enabled` |
| `/documentar` sobre carpeta vacía | Generó el árbol completo: VISION · ALCANCE · PLAN (4 sesiones, 12 criterios con su verificación) · 4 ADRs con `Estado` y `superaA` · catálogo de referencias |
| `/auditar-docs` | Informe con las 6 dimensiones — **atestación humana de Fede**, no verificación de máquina: el comando solo emite en pantalla y no persiste archivo |

> Por qué nunca se había probado: se creía que la máquina de Fede tenía el plugin instalado
> del marketplace viejo. **Verificado en S01: estaba _cacheado_, no instalado** — el efecto
> era el mismo (el camino desde cero nunca se ejercitó), pero el motivo era otro.

El estado de dependencias vive **solo acá** (README y FICHA apuntan a esta tabla, no lo repiten) y lleva fecha de verificación explícita: sin fecha, la marca miente sola.

Cerrar esta compuerta es **S01** del plan, y toda sesión posterior la declara como prerrequisito ⛓️.

> Nota histórica: el hallazgo «la condición no es auditable» de la auditoría del 2026-07-19
> quedó resuelto ese mismo día (`fede-tools` identificado, PRs calificados y verificados
> como merged), y la compuerta se cerró en S01 esa misma fecha. Se deja registrado porque
> la trazabilidad del contrato depende de poder releer por qué estuvo bloqueada.

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
| Criterios → tests | `verificador` está **diseñado y sin construir** (ficha firmada, 2 commits, cero código — verificado 2026-07-19). **BLOQUEA**, no reimplementa. |
| Publicar / pushear | `publicador` está **diseñado y sin construir** (ficha firmada, 2 commits, cero código — verificado 2026-07-19). **BLOQUEA**, no reimplementa. ⚠️ `decisiones/010` le delega `gitleaks`: la decisión está firmada en su ficha pero no hay capacidad de ejecutarla, así que ese bloqueo no tiene fecha de resolución. |
| Enumerar la flota / portafolio | `cartera` está **a medias** (verificado 2026-07-19): los prompts de S02-S05 están escritos, pero **S01 —hacerlo instalable— se salteó**. No está en el marketplace, su repo remoto no existe y no está instalado. Además es v2. **BLOQUEA** — el criterio de delegado usable es «terminado», no «existe». |

> Precisión sobre los tres BLOQUEA (auditoría 2026-07-19): ninguno de los delegados está *indefinido*. Los tres tienen ficha firmada y plan de sesiones. La distancia para levantarlos es **ejecutar**, no **decidir** — dato que importa al estimar cuándo cae cada bloqueo.
| Retro del proceso al cerrar | **Fuera de alcance de v0, explícito** (`decisiones/013`, FIRMADA 2026-07-22): ni delega, ni bloquea — la fila salió del modelo. Si entra en v2+, será ruteo al comando de `audit-tracker`. |
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

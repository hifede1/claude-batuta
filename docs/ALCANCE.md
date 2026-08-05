# Alcance — `batuta`

> Firmado: 2026-07-19 por Fede · **Re-ratificado: 2026-08-04 (S21, `#124`)** · Ratifica FICHA §0 y §11 · huella: `adcc79359491d2c2b6b7e746330d1c3f8ae690402b0fabde949001056a522352` · Corte de versiones: `decisiones/007-corte-de-versiones.md`
>
> *Re-ratificaciones anteriores: **2026-08-02** (`#97` y `#95`, huella `9ba10af9…`). Esa huella dejó de
> coincidir cuando `b37c162` (PR `#106`) cambió **FICHA §0** para que dejara de enumerar delegados y
> **remitiera a este documento**. Nadie lo notó durante dos días: ningún chequeo miraba esta línea —el
> 5 ancla en la estampa de FICHA, el 7 en el tracker— y es exactamente el hueco que **S21** vino a
> cerrar. Se conserva el historial en vez de pisarlo: una re-ratificación que borra la anterior
> impide saber **sobre qué** se ratificó cada vez.*
>
> *La re-ratificación del 2026-08-01 toca **solo** la tabla «v0 NO hace» y su nota de precisión: los tres
> `BLOQUEA` se apoyaban en un estado de delegados verificado el 2026-07-19 que dejó de ser cierto el 23-24
> de julio. **El alcance de v0 no cambia** — cambia el motivo por el que dos de sus filas bloquean, y eso
> es contrato, no contabilidad. ⚠️ Esta estampa **no la cubre ningún cable**: el chequeo 5 de S17 ancla en
> `FICHA.md`, y la de este documento envejece igual de sola. Declarado como hueco, no cerrado acá.*

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
| Criterios → tests | ✅ **EL BLOQUEO CAYÓ — verificado 2026-08-01.** `verificador` está **terminado**: repo 121 KB, `plugins/verificador/commands/criterios-a-tests.md`, **4/4 bloques hecho**, `PLAN COMPLETO 2026-07-24 — producto en mantenimiento`, y **ejercitado de verdad** (primera clasificación real firmada por el dueño, `publicador#15`). ⚠️ **Se reduce, no desaparece:** su S03 es *«Generación trazable: SIEMPRE esqueletos»* — entrega **esqueletos de test**, no tests ejecutables. `batuta` puede delegar criterios→esqueletos; **lo que sigue sin ejecutor es la generación de tests que corren**. ⚠️ No instalado en esta máquina. |
| Publicar / pushear | ✅ **EL BLOQUEO CAYÓ — verificado 2026-08-01.** `publicador` está **terminado**: repo 185 KB, `plugins/publicador/commands/publicar.md`, **5/5 bloques hecho**, `PLAN COMPLETO 2026-07-24`, y **ejercitado de verdad** — su S05 es dogfooding, se publicó a sí mismo, con registro firmado en `docs/verificacion/criterios-clasificados.md`. ⚠️ **`decisiones/010` ya tiene ejecutor:** `publicar.md` menciona `gitleaks` **7 veces**. La frase anterior de esta fila —«no hay capacidad de ejecutarla, así que ese bloqueo no tiene fecha de resolución»— **era falsa desde el 2026-07-24**. ⚠️ npm exige **OTP del dueño** (2FA `auth-and-writes`): gate humano declarado como rasgo, y coherente con `012`. ⚠️ No instalado en esta máquina. |
| Enumerar la flota / portafolio | ⚠️ **EL BLOQUEO SOBREVIVE, POR OTRO MOTIVO — verificado 2026-08-01.** `cartera` está **terminada**: repo 82 KB, dos comandos, **6/6 bloques hecho**, `PLAN COMPLETO 2026-07-23` con C1/C2/C3 verificadas (PRs #5, #6, #8 mergeados por Fede), **está en el marketplace `fede-tools` Y está instalada en esta máquina**. Las tres afirmaciones anteriores de esta fila —«no está en el marketplace», «su repo remoto no existe», «no está instalado»— **eran las tres falsas**. Lo que sobrevive es **el único motivo que no dependía del estado de `cartera`: es v2** (`decisiones/007`, corte de versiones). `batuta` v0 no la consume **por decisión firmada, no por delegado faltante** — y esa distinción es el punto. ⚠️ Hueco propio declarado: el nivel «auditoría roja» del ranking sigue sin ejercitar. |

> ⚠️ **Precisión sobre los tres BLOQUEA — reasentada el 2026-08-01 (S18), sustituye a la del 2026-07-19.**
> La anterior decía que la distancia para levantar los delegados era «ejecutar, no decidir». **Se ejecutó**:
> los tres se construyeron entre el 23 y el 24 de julio y esta tabla no se enteró durante trece días.
> **Dos bloqueos cayeron, uno se redujo y el tercero sobrevive por un motivo distinto del que declaraba.**
>
> Lo que este reasentamiento deja escrito, y vale más que las filas: **un `BLOQUEA` fechado es una promesa
> con vencimiento.** Su verdad depende de un mundo que sigue moviéndose afuera del repo, y acá nada lo
> cotejaba — ni `coherencia` (mira ADRs y `FICHA` §10) ni `frontera` (mira `references/` y `plugin.json`).
> Es la enfermedad que S17 cableó, un nivel más arriba: la diferencia no es el tipo de drift sino **contra
> qué se mide** — dentro del repo, o contra el disco y GitHub. **No se cablea en esta sesión:** exigiría
> red en CI y todos los cables corren offline por diseño. Eso es decisión, no trabajo, y va a ADR propio.
>
> Lo verificado acá es que **las afirmaciones del plano eran falsas** — no que los tres delegados sirvan
> para todo lo que `batuta` necesite. El criterio sigue siendo «terminado», y «terminado» lo declara cada
> delegado en su propio artefacto: es **su** palabra, corroborada por corridas reales, no una auditoría
> que `batuta` les haya hecho.
| Retro del proceso al cerrar | **Fuera de alcance de v0, explícito** (`decisiones/013`, FIRMADA 2026-07-22): ni delega, ni bloquea — la fila salió del modelo. Si entra en v2+, será ruteo al comando de `audit-tracker`. |
| Campo estructurado `externos` | Es v1. En v0 se cosecha best-effort. |
| Estado VERIFICADO de externos y health-check vivo | Es v2. Un falso VERIFICADO revienta a mitad con trabajo gastado: peor que bloquear. |
| EGRESO outward arbitrario | Solo los que la caja ya cubre con compuerta probada: merge vía `/orquestar`. **En v0 la publicación NO es un acto separado** (`#97`, rama C, firmada 2026-08-02): el marketplace `fede-tools` sirve `git-subdir` con `ref: main`, **sin pin de versión ni SHA**, así que **el merge a `main` ES la publicación** — se distribuye en el instante del merge y no hay acto discreto que pedir, firmar ni verificar aparte. `/publicar` sigue siendo el **pre-flight**, no el acto. Medido el 2026-08-02: cero releases en toda la historia del repo, ningún bump de `0.1.0` a `0.5.0` tuvo una, y npm no aplica (sin `package.json`; el nombre está tomado). Pinear el `ref` a un tag para volverla discreta se evaluó y se descartó — es la rama A de `#97`. |
| Editar el producto sin publicarlo | **No existe** (`#95`, rama A, firmada 2026-08-02). `.github/scripts/frontera.sh` CHEQUEO 1 obliga a mover la versión ante cualquier cambio de `plugins/`, y por la fila de arriba el merge distribuye: **toda edición del producto es un acto de distribución**, sin importar su tamaño, y pasa por la compuerta que le corresponde a un acto outward. Corregir una línea del comando y publicar **no son tramos independientes** — dibujarlos separados en un plan es un error de planificación, y así se detectó. |
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

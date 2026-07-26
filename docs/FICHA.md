# Ficha de diseño: batuta

> **Estado: VIGENTE**
> Firmado: 2026-07-26 (2) por Fede
> *Procedencia de la firma (`decisiones/018`) — historial consolidado de esta estampa. En los tres
> actos el acto de ratificación es **el merge del PR por el dueño**, autenticado por `merged_by` ==
> dueño anclado (`009`):*
> 1. ***2026-07-24 · PR #43** (mesa chica) — la cabecera decía «En diseño» cuando la obra v0 estaba
>    COMPLETA y cada decisión del §10 ya estaba firmada con su Procedencia. La estampa reconcilió la
>    cabecera con una realidad ya firmada pieza por pieza.*
> 2. ***2026-07-25 · PR #47** — re-estampa de versión por cambio del plano: se incorpora la serie de
>    **mantenimiento post-v0** (S10) y `registro-de-cadena.md` §6 suma el **tercer salvo** de
>    composición del asiento (`decisiones/022`). Como `011` fija que la fecha de firma ES la versión,
>    un plano modificado no puede conservar la versión anterior. Pedido por Fede en sesión
>    interactiva del 2026-07-24, tras el hallazgo D10 de la corrida `2026-07-24-arreglar-path-de-corridas`.*
> 3. ***2026-07-25 · este PR** — se abre **S11** (contabilidad de la ficha) y se **consolida esta
>    Procedencia**, que el propio PR #47 había dejado duplicada: dos bloques consecutivos sin decir
>    cuál correspondía a la firma vigente. La consolidación se hace **en el mismo acto** que la
>    re-estampa que `011` exige — hacerla después habría agregado un tercer bloque encima de los dos
>    que S11 viene a arreglar.*
> 4. ***2026-07-25 · PR #54** — S11 ejecutada: la §10 deja de listar `015` como firmada y pendiente a
>    la vez, y se declara el hueco `017`. La cabecera **no se tocó** en ese PR, por diseño.*
> 5. ***2026-07-26 · este PR** — se propone `decisiones/023` (versionado del plano con sufijo
>    incremental), se abre **S12** y se re-estampa la versión por cambio del plano. Fede eligió el
>    sufijo incremental entre cuatro opciones con tradeoffs, en sesión interactiva del 2026-07-26.*
>
> 6. ***2026-07-26 (2) · este PR** — se firman `decisiones/024` (patrón único de sello) y
>    `decisiones/025` (separación de credenciales agente/dueño) y se abre **S13**, la sesión que baja
>    ambas a contrato y aplica la separación. Fede eligió cada una entre opciones con tradeoffs, en
>    sesión interactiva del 2026-07-26. **Primeros ADRs firmados bajo el patrón de `024`**: sello en
>    el PR que los propone.*
>
> ℹ️ *Versionado: **segunda ratificación del 2026-07-26**, de ahí el sufijo `(2)` — `023` regla 1.
> **Primera aplicación real de esa regla**, no un ejemplo: el acto 5 fue la primera del día y por eso
> va sin sufijo. El hueco que motivó `023` sigue visible en esta misma cabecera — los actos **2, 3 y
> 4 comparten `2026-07-25`** con contenidos distintos. `023` **no re-versiona el pasado**: reescribir
> firmas pasadas sería fabricar actos que no ocurrieron así (`018`).*
> Diseñada: 2026-07-18 (workflow de 6 agentes; verbatim declarado PERDIDO — `references/workflows-fan-out.md` es la reconstrucción canónica) · Obra: **v0 COMPLETA 9/9 (2026-07-22) + fix #38 · en mantenimiento** · absorbe a `director-de-obra`

## 0. Estrategia: v0 MÍNIMA, head-first (decidido por Fede 2026-07-18)

Corrección al plan original ("construir última"): `batuta` NO tiene que esperar a que TODOS sus delegados existan. Su **loop central corre solo con los dos cimientos** —`doc-arquitecto` (documentar) y `audit-tracker` (auditar + `/orquestar`)— **más los workflows, que ya existen.** Por eso se construye una **v0 MÍNIMA head-first** y se usa para bootstrappear el resto (armar la cabeza, y con la cabeza construir las extremidades más fácil).

**El salvaguarda real NO es el orden, es la regla "bloqueá, nunca reimplementes" (§8/§11):** cuando una fase necesita un músico que no existe o no está terminado (testear→verificador, publicar→publicador, portafolio→cartera), `batuta` FRENA y lo reporta como hueco-a-construir — jamás hace el trabajo ella misma "temporalmente". Único antídoto contra el god-object-por-necesidad; la tentación es máxima justo en ese momento.

**Precondición (lo mínimo ANTES de construir v0):** los dos cimientos SÓLIDOS. `audit-tracker` ✅. `doc-arquitecto` casi: sus comandos existen pero falta cerrar el fix `fede-tools` (#29→#21) y **PROBAR el install** — recién ahí es cimiento firme.

**Nomenclatura de versiones (firmada 2026-07-19 — ver `decisiones/007-corte-de-versiones.md`):**

- **v0 — bootstrap.** El loop de 4 fases (analizar → planificar → ejecutar-con-compuertas → cerrar) sobre los dos cimientos, con externos y ruteo en forma MÍNIMA best-effort, sin campo estructurado. Se construye para bootstrappear el resto del taller.
- **v1 — las 6 fases formales.** Suma `mapear-externos` y `definir-ruteo` como fases propias, el campo estructurado `externos` en `doc-arquitecto` Y `audit-tracker`, y el Plan de Ruteo firmado.
- **v2 — portafolio.** Altitud de flota (consume `cartera`) y estado VERIFICADO de externos.

### Alcance MÍNIMO de v0

- **Orquesta SOLO:** `doc-arquitecto` (`/documentar`, `/auditar-docs`), `audit-tracker` (`/audit-tracker`, `/orquestar`), y workflows (fan-out + la planificación absorbida de `director-de-obra`).
- **Fases activas:** analizar → planificar → ejecutar-con-compuertas → cerrar. Mapeo-de-externos y ruteo en su forma MÍNIMA (best-effort: cosecha lo que los cimientos flaguean y, ante la duda, PREGUNTA — sin el campo estructurado `externos`, que es post-v0).
- **BLOQUEA** (hueco-a-construir, nunca reimplementa): criterios→tests (falta `verificador`), publicar (falta `publicador`), enumeración de flota / portafolio (`cartera` a medias, no terminada; además es v2), egreso outward genérico.
- **MONO-PROYECTO.** Portafolio = v2.

## 1. Propósito

**Finalidad — el norte (en palabras de Fede):** que tu idea y su contexto **persistan intactos a lo largo de todo el trabajo** — de la idea a la obra — sin que se pierda el hilo en ningún traspaso, para poder **trasladar tu intención de forma efectiva a CUALQUIER tipo de trabajo**. La orquestación de herramientas es el MECANISMO; la **persistencia fiel de tu intención y contexto es el FIN**. El éxito de `batuta` no se mide en "¿orquestó bien las tools?" sino en "**¿mi idea llegó a obra intacta, y el contexto quedó claro en cada paso?**". Todo el taller es, en el fondo, una máquina de preservar contexto; `batuta` es la que lo carga de punta a punta.

**Una frase:** `batuta` permite lanzar UNA herramienta sobre un proyecto y llevarlo de objetivo a obra —eligiendo qué herramientas del taller usar y en qué orden, mapeando sus externos, ruteando la información y ejecutando con compuertas de validación humana— **sin reimplementar el trabajo de ninguna tool ni mover el loop sin firma.** Es un director de orquesta DELGADO: compone y rutea, jamás construye por su cuenta.

## 2. Tipo y forma

Plugin de Claude Code, comando **`/batuta:batuta`** (namespacing real de plugins: `plugin:comando`; ratificado en la mesa chica 2026-07-24 — la ficha se corrige, el comando no se renombra). Genérico (cualquier proyecto en GitHub). Mezcla `/orquestar` (loop determinístico con firma) con workflows (fan-out multi-agente).

## 3. Qué hace ELLA vs qué DELEGA (el antídoto god-object)

**Lo único legítimamente propio de `batuta`:** la fase de planificación (capacidad absorbida de `director-de-obra`) + las compuertas de externos/ruteo (capacidad neta nueva). **Todo lo demás DELEGA:**

| Necesidad | Delega a |
|---|---|
| Escribir el plano (docs, criterios, ADRs) | `doc-arquitecto /documentar` — batuta escribe CERO contrato |
| Auditar el plano | `doc-arquitecto /auditar-docs` |
| Auditar la obra / leer estado real file:line | `audit-tracker /audit-tracker` — batuta LEE, no re-audita |
| Ejecutar encargos (rama, PR, firma) | `audit-tracker /orquestar` — batuta no escribe código ni mergea |
| Encargo puntual en un worker | `audit-tracker /proximo-encargo` |
| Pensar en paralelo / pase adversarial | un **workflow** de fan-out |
| Criterios → tests | `verificador /criterios-a-tests` |
| Publicar (gitleaks + firma) | `publicador /publicar` — batuta jamás pushea |
| Enumerar la flota | `cartera` (v2, altitud portafolio) |

**Lo que batuta hace por sí misma (y nada más):** análisis-de-orquestación (sintetiza la RUTA), selección condicional de tools, mapeo de externos, diseño del ruteo, y el loop de ejecución abriendo SOLO los gates META que ninguna tool posee.

## 4. Las 6 fases de una corrida

1. **analizar** — entender el objetivo. Con plano firmado → LEE el estado (audit-tracker). Sin plano → rutea a `/documentar` + `/auditar-docs` y frena. **Compuerta:** devuelve al humano su lectura del objetivo ("esto entendí que querés y por qué") — un objetivo mal leído envenena las 5 fases.
2. **planificar** (`director-de-obra` plegado, mono-proyecto) — grafo de dependencias + inversiones; horizontes tipo Gantt distinguiendo *gated-por-EJECUCIÓN* vs *gated-por-FIRMA* (esa distinción ES el ruteador de la fase ejecutar); pase adversarial contra estado FRESCO (vía workflow); recomendaciones rankeadas con contrapunto + decisiones-a-firmar.
3. **mapear-externos** — produce el **Manifiesto de Externos** cosechando lo que analizar/planificar ya identificaron (no corre un detector propio). Externo faltante = encargo-al-humano que BLOQUEA. Reentrante: si ejecutar descubre un externo nuevo, pausa ESE carril, pide, reanuda.
4. **definir-ruteo** — produce el **Plan de Ruteo**: partitura descriptiva firmada de la topología de CONFIANZA. *(Fases 1-4 son baratas y reversibles → colapsan en UNA Compuerta Cero de "plan aprobado por horizonte", con diff, no big-bang.)*
5. **ejecutar-con-compuertas** — mezcla `/orquestar` (trabajo secuencial que converge a merge) con workflows (trabajo divergente/exploratorio). batuta dueña SOLO las compuertas que `/orquestar` no conoce: externos, EGRESO outward, workflow→cola. Loops ANIDADOS: batuta itera FASES, `/orquestar` itera ENCARGOS.
6. **cerrar** — DELEGA la re-auditoría a `audit-tracker` (verde solo lo mergeado y firmado); persiste un baseline liviano de la corrida. Reporta qué se ejecutó, qué espera firma, qué se escaló, qué externos faltaron.

## 5. Modelo de externos (Manifiesto)

Contrato de **NECESIDADES, jamás de SECRETOS.** Por cada externo: QUÉ es (MCP/API/credencial/servicio), POR QUÉ (qué encargo lo requiere, file:line), CÓMO se provee (la instrucción), QUIÉN (SIEMPRE el humano) y ESTADO. batuta **identifica y pide; nunca fabrica, asume, mockea ni auto-provisiona.** Guarda la necesidad, nunca el valor. Estado BINARIO **REQUERIDO / PROVISTO** en v0 y v1 (verifica PRESENCIA de la env var / MCP, sin leer el valor); **VERIFICADO** (capacidad real: scopes, plan) es un egreso con compuerta → v2. Un falso VERIFICADO es peor que bloquear: revienta a mitad con trabajo gastado. Externo faltante = prerrequisito ⛓️ en la cola de Issues (label `externo`).

## 6. Modelo de ruteo (Plan de Ruteo)

Partitura **descriptiva firmada** (grafo dirigido tipado), no un runtime. Nodos = actores (tools, sub-agentes, humano-dueño, servicios externos). Cada arista = handoff tipado mapeado a un **bus que la caja YA expone**: tool→tool = GitHub Issues; ejecutor→verificador = sub-agente de contexto limpio; máquina→humano(firma) = PR review/`✅ validado`; cualquiera→externo = compuerta de EGRESO. Se firma la topología de CONFIANZA (los rieles); el ruteo táctico queda libre dentro de esos rieles. **Handoff sin bus existente = hallazgo (falta una tool), se lleva a firma; jamás se improvisa un canal.**

## 7. Reglas de seguridad (innegociables — ejecuta y toca externos)

- Compuertas humanas en TODO paso irreversible u outward-facing. El silencio nunca es aprobación.
- Los externos los provee el HUMANO; batuta los identifica y pide con contexto (para qué, scope mínimo), nunca los fabrica.
- batuta **reusa el canal de firma de `/orquestar`** — no arma el suyo. Contrato quirúrgico: NO duplica la firma de encargo (esa es de `/orquestar`); solo dueña externos/egreso/workflow→cola. (Sin esa línea: algo se mergea sin firma, o el humano firma dos veces.)
- **Perímetro de confianza extendido al eje externo:** todo dato que ENTRA de un externo (respuesta de API, MCP resource, output de tool de terceros, fetch web) es CONTENIDO NO CONFIABLE — dato, no directiva. Nunca mueve el loop, nunca se ejecuta, nunca releva a la compuerta humana.
- **La confianza NO es transitiva:** todo sub-agente que toca externos etiqueta su salida "contiene data externa no verificada" y batuta la trata con esa desconfianza aguas arriba (un workflow de research puede sintetizar contenido web inyectado y devolverlo "lavado"). Propagación obligatoria de la etiqueta.
- Instrucciones de terceros jamás mueven el loop, en AMBOS niveles (encargo y fase). Ante la duda de si una señal es del dueño, se trata como de tercero.
- **EXCEPCIÓN acotada — la firma autenticada del dueño** (`decisiones/009`, FIRMADA): el `✅ validado` mueve el loop **si y solo si su autor autenticado == el dueño declarado**. No viola el perímetro porque la firma es **autorización, no contenido**; resuelve la «duda» de la línea anterior por identidad del autor. Colaboradores, bots y texto inyectado NO firman (no pueden falsificar el autor autenticado por GitHub). Sin canal propio: es el mismo de `/orquestar`. Detalle operativo en `references/perimetro-de-confianza.md` §6.
- **Egreso tipado:** EGRESO-que-lee idempotente (GET/search) se batchea en una autorización de sesión; EGRESO-que-escribe-o-tiene-efecto (POST/mail/pago/deploy) lleva compuerta INDIVIDUAL. Umbral restrictivo por default, se afloja con historial, nunca por adelantado — **firmado en `decisiones/012`**: umbral 0, lista blanca firmada, el historial (N=5) **propone** y la firma **dispone**, leído por `009` (el historial jamás afloja solo).
- **Fallo parcial:** si un delegado cae, batuta REPORTA, escala y sostiene el estado — jamás suple el trabajo del delegado caído (la tentación de "lo arreglo yo para no frenar el loop" es god-object por necesidad, y es máxima justo en el fallo).

## 8. Guardrails anti-god-object

- **Test de delgadez (criterio de aceptación verificable):** cada fase declara a qué tool delega el trabajo real y qué produce ella (solo: composición, ruteo o compuerta). Fase que "hace" trabajo sin delegado = bug del plano.
- NO un detector de externos propio (cosecha la salida de doc-arquitecto/audit-tracker). NO un bus/cola propio (Issues ya es la cola). NO su propio protocolo de firma. NO escribir código/rama/merge (todo cambio rutea a `/orquestar`, sin importar el tamaño). NO fabricar el plano. NO re-auditar/re-escanear. NO hacer el fan-out a mano.
- **La banda angosta:** la selección de tools debe ser genuinamente CONDICIONAL (no un playbook estático) pero ACOTADA (no re-análisis infinito). v1 fija EXPLÍCITAMENTE dónde para.

## 9. Absorción de director-de-obra

`director-de-obra` **no se construye por separado ni se archiva: se pliega como la fase 2 (Planificación).** En el índice —**`tools/README.md`, confirmado como EL índice del taller por Fede en la mesa chica 2026-07-24**— queda marcado "absorbida por batuta" (rastro de decisión, no se borra; verificado: ya lo está). Sus 4 capacidades entran intactas como maquinaria de la fase. Sus **4 decisiones firmadas (2026-07-18) viajan como invariantes** (D1 enumera-y-clasifica; D2 GitHub-first; D3 baseline liviano; D4 consume cartera) — pero son PISO, no techo: batuta EJECUTA y toca externos, y eso abre decisiones nuevas que ninguna de las 4 cubre (ver §10). La deferida "¿herramienta o capacidad?" se auto-resuelve: batuta ES la herramienta, la planificación es su fase.

## 10. Decisiones

Registro completo en `decisiones/`. Notación: las firmadas llevan **FIRMADA + fecha**; las abiertas, **PENDIENTE + dueño + qué la desbloquea**. Los `- [ ]` quedan reservados a los criterios de aceptación de §12 — miden al software, no al humano.

### Cuándo se estampa el sello (`decisiones/024`)

`018` fija **qué** es una firma —un acto humano rastreable, nunca un campo— y esta sección fija
**cuándo** se escribe el sello, que es lo que `018` dejaba abierto a dos lecturas.

**Un ADR se escribe con su sello `✅ FIRMADA` en el mismo PR que lo propone**, con dos condiciones:

1. **el acto humano de elección ya ocurrió** y queda en `Procedencia de la firma` con su forma
   verificable: qué se eligió, entre qué opciones, en qué canal y cuándo;
2. **la `Procedencia` declara que la ratificación es el merge de ese PR por el dueño**, autenticable
   por `merged_by` (`009` + `025`).

**Por qué esto no falsifica una firma:** un sello escrito en una rama no mergeada **no existe en el
contrato**. El contrato es `main`, y un ADR solo llega ahí por el merge del dueño — así que **sello y
ratificación son simultáneos por construcción**. No hay instante en que `main` contenga un `FIRMADA`
sin su acto. Confundir el estado de una rama con el estado del contrato es lo que llevó al patrón
largo (`022`, `023`): tres PRs por decisión, y una ventana en la que esta §10 tenía que listar el ADR
en *Pendientes* o mentir.

**Cuándo sigue valiendo nacer ⏳ PENDIENTE:** cuando la **elección humana todavía no ocurrió** — un
ADR que se abre para que el dueño lo estudie antes de decidir. Ahí la condición 1 no se cumple, y el
sello va después. Lo que `024` elimina no es el estado PENDIENTE, sino **usarlo cuando la decisión ya
está tomada**.

> `022` y `023` quedaron sellados con el patrón largo y **no se reescriben**: sus actos ocurrieron
> así. El patrón único rige de acá en adelante.

### Firmadas

- **Mono-proyecto en v0 y v1** — FIRMADA 2026-07-18 · `decisiones/001-mono-proyecto.md`. Portafolio = v2. Rompe la dependencia dura de `cartera`; enumeración trivial = el repo. Aplicada en §0 y §4.
- **Granularidad: Compuerta Cero** — FIRMADA 2026-07-19 · `decisiones/002-granularidad-de-compuertas.md`. Fases 1-4 colapsan en UNA firma de «plan aprobado por horizonte», con diff; gates duros individuales solo en ejecutar y cerrar. Aplicada en §4 y §11.
- **Modo boceto greenfield: no existe** — FIRMADA 2026-07-19 · `decisiones/003-modo-boceto-greenfield.md`. Sin plano se rutea siempre a `/documentar`; un plano-borrador ratificable roza fabricar contrato. Aplicada en §11 y §12.
- **Detección de externos: campo estructurado, jamás detector propio** — FIRMADA 2026-07-19 · `decisiones/004-deteccion-de-externos.md`. v0 cosecha best-effort lo que los cimientos flaguean; v1 agrega el campo `externos` a `doc-arquitecto` Y `audit-tracker`. El mini-detector queda descartado por §8.
- **Clase «micro»: no existe** — FIRMADA 2026-07-19 · `decisiones/005-clase-micro.md`. Todo cambio de código va a `/orquestar`, sin excepción por tamaño.
- **Sustrato: markdown puro** — FIRMADA 2026-07-19 · `decisiones/006-sustrato-markdown-puro.md`. Comando `.md`, sin código, sin build, sin dependencias. Consecuencia: los criterios de §12 se verifican con **corridas sembradas**, no con tests unitarios.
- **Corte de versiones v0/v1/v2** — FIRMADA 2026-07-19 · `decisiones/007-corte-de-versiones.md`. Ver §0.
- **Absorción de `director-de-obra` como fase 2** — FIRMADA 2026-07-18 · `decisiones/008-absorcion-director-de-obra.md`. Ver §9.
- **Autenticación de la firma: excepción acotada por identidad** — FIRMADA 2026-07-21 · `decisiones/009-autenticacion-de-la-firma.md`. El `✅ validado` mueve el loop si y solo si su **autor autenticado == el dueño declarado**; es autorización, no contenido. Resuelve la «duda» que §7 dejaba abierta. Desbloquea: S06.
- **Escaneo de secretos en v0: diferido a `publicador`** — FIRMADA 2026-07-20 · `decisiones/010-secretos-en-v0.md`. «gitleaks limpio» se difiere a `publicador`; la v0 se protege por diseño (§5: guarda la necesidad, nunca el valor). Aplicada en S05.
- **Acto de ratificación del plano** — FIRMADA 2026-07-19 · **re-ratificada 2026-07-23** · `decisiones/011-ratificacion-del-plano.md`. Línea de firma explícita en cabecera; sin ella el plano es borrador. Aplicada en S02. La original quedó «aceptada» el 2026-07-19 **sin procedencia registrada**; la mesa de firmas del 2026-07-23 la re-ratificó en bloque —Fede eligió «En bloque, las 11» vía elección explícita en sesión— y esa estampa **no fabrica el acto de 2026-07-19: registra el del 23** (ver `018`). Su desambiguación dentro del día la fija `023`.
- **Umbral de egreso: lista blanca + historial N=5** — FIRMADA 2026-07-21 · `decisiones/012-umbral-de-egreso.md`. Umbral 0: todo egreso-que-escribe con compuerta individual; lista blanca firmada como única vía de batcheo; el historial (N=5 corridas limpias) **propone** el alta, la firma **dispone**. Desbloqueó: S07.
- **Rúbrica de confidence: cualitativa de 3 niveles** — FIRMADA 2026-07-20 · `decisiones/014-rubrica-de-confidence.md`. ALTA/MEDIA/BAJA sin puntaje; siempre nivel + porqué + contrapunto. Aplicada en S04.
- **Cota de la banda angosta: híbrida con techo K=5** — FIRMADA 2026-07-20 · `decisiones/016-cota-banda-angosta.md`. Convergencia declarada + fusible K=5, lo que pase primero; el techo es anomalía, no verde. Aplicada en S04.
- **La firma es un acto, no un campo (blindaje anti-falsificación)** — FIRMADA 2026-07-20 · `decisiones/018-blindaje-antifalsificacion.md`. Todo ADR nace PROPUESTA; el sello FIRMADA solo con acto humano rastreable en `Procedencia de la firma`. Complemento operativo de 011.
- **Eje externo (paraguas `015`): CERRADO 2026-07-24** — las tres decisiones que dejaba abiertas, firmadas como ADRs propios: **`019`** fuentes del PROVISTO (declaración del dueño vale, con marca «no sondeado») · **`020`** salud en runtime (reporte, no estado; carril pausado + hallazgo) · **`021`** lista negra de egreso v0 (pagos y borrados irreversibles fuera, ni con firma — completa a `012`).
- **Asiento del bookkeeping de apertura (tercer salvo)** — FIRMADA 2026-07-25 · `decisiones/022-asiento-bookkeeping-de-apertura.md`. La composición del asiento de `registro-de-cadena.md` §6 contemplaba el bookkeeping de un CIERRE, pero no el de una re-auditoría que **ABRE** trabajo — clase inevitable que nacía como eslabón roto (caso real: PR #46, merge autenticado y solo `docs/audits/`, roto porque `CLOSED_COUNT` no se movió). El salvo autentica solo con tres condiciones; la de «invocación asentada en un eslabón `obra`» es la que lo hace asiento y no puerta trasera. Origen: hallazgo D10 de la corrida `2026-07-24-arreglar-path-de-corridas`. Ratificada por merge del PR #47.
- **Versionado del plano: sufijo incremental dentro del día** — FIRMADA 2026-07-26 · `decisiones/023-versionado-del-plano.md`. `011` fija que la fecha de firma ES la versión, sin prever que **dos ratificaciones del mismo día son indistinguibles**: el 2026-07-25 se mergearon CUATRO PRs de plano (#47/#48/#52/#54) bajo la misma etiqueta, y dos corridas reales arrancaron con esa versión sobre planos distintos. El costo no era estético: la causal 7 de `registro-de-cadena.md` §6 —«el plano cambió de versión durante la corrida»— quedaba **estructuralmente inauditable dentro del día**. Se adopta sufijo `(N)` a partir de la segunda ratificación diaria, reusando la notación que el tracker ya aplica a auditorías múltiples. Costo aceptado: el incremento es manual y sin gate — un olvido reintroduce la colisión en silencio. Ratificada por merge del PR #56. Baja a contrato en **S12**.
- **Patrón único de sello: el ADR se firma en el PR que lo propone** — FIRMADA 2026-07-26 · `decisiones/024-patron-unico-de-sello.md`. `018` admitía dos lecturas del **cuándo** se estampa el sello, y ambas estaban en uso: el patrón corto (`012`, `015`, `019`/`020`/`021` — 1 PR) y el largo (`022`, `023` — 3 PRs: propuesta → sello → trabajo). Se unifica en el corto. **El argumento que resuelve la tensión con `018`:** un sello escrito en una rama no mergeada **no existe en el contrato** —el contrato es `main`, y llegar ahí exige el merge del dueño—, así que sello y ratificación son **simultáneos por construcción**. Disuelve además el hueco de la ventana propuesta↔sello, durante la cual §10 tenía que listar el ADR en Pendientes o mentir (falló en el PR #56). Sigue valiendo nacer ⏳ PENDIENTE **cuando la elección humana todavía no ocurrió**. `022` y `023` no se re-escriben. Baja a contrato en **S13**.
- **Separación de credenciales: el agente no opera con la cuenta del dueño** — FIRMADA 2026-07-26 · `decisiones/025-separacion-de-credenciales.md`. `009` autentica la firma por `merged_by` == dueño anclado, **pero el agente operaba con la credencial de `hifede1`, que ES el dueño anclado**: un merge del agente producía el mismo metadato que uno del humano, así que el criterio **no discriminaba lo que decía discriminar**. Se separa: el agente usa `estebaproject` (con push) para ramas, PRs, issues y comentarios; `hifede1` queda **solo para el humano**. Así `merged_by == hifede1` vuelve a ser **prueba**, sin tocar el texto de `009`. Efecto lateral buscado: con cuentas distintas GitHub permite asignar reviewer, de modo que el canal de firma puede volver al **review de PR** en vez del comentario `✅ validado`. **No re-autentica el pasado:** los merges de S10–S12 se hicieron con credencial compartida y quedan como están. Baja a contrato y se **aplica** en **S13**.
- **`retrospectiva`: fuera de alcance de v0, explícito** — FIRMADA 2026-07-22 · `decisiones/013-retrospectiva-opcional.md`. La fila sale de §3; la fase `cerrar` no la produce, ni la delega, ni la bloquea — el binario delega-o-BLOQUEA queda intacto. Si entra en v2+, será ruteo al comando de `audit-tracker` (ficha externa). Desbloqueó: S08.

### Pendientes

**Ninguna al 2026-07-26.** El paraguas `015` era la última y quedó **cerrado el 2026-07-24** con sus tres ADRs firmados (`019`/`020`/`021`) — su registro completo vive arriba, en Firmadas. Hasta S11 esta sección seguía listándolo como PENDIENTE mientras Firmadas lo declaraba CERRADO: la ficha se contradecía a sí misma dentro de la misma sección. Se eliminó la **contradicción**, no el historial.

> Esta línea se sostiene sola: si aparece una decisión pendiente, se agrega acá con su dueño y qué la desbloquea. Una sección vacía y una sección borrada se leen distinto — la primera dice «no hay», la segunda no dice nada.

### Nota de numeración: el hueco `017`

`decisiones/` salta de `016` a `018`. **`017` nunca existió.** `016-cota-banda-angosta.md` y `018-blindaje-antifalsificacion.md` nacieron en el mismo commit (`9183665`, PR #24, junto con `014`); no hay archivo creado ni borrado en el historial, ni menciones en mensajes de commit, ni referencias en `docs/` o en el tracker. Fue un número **saltado al redactar tres ADRs de un saque**.

**`017` queda declarado como número no usado y NO reutilizable.** Mismo principio que `registro-de-cadena.md` §2 regla 2 fija para los identificadores de requisito: un ID que no se usó no se recicla, porque reciclarlo rompe la trazabilidad de todo lo escrito antes. Se documenta acá para que el hueco no se investigue de cero cada vez que alguien lo nota — ya pasó una vez, en la serie de mantenimiento post-v0.

## 11. Fuera de alcance (v0 y v1)

- No construir hasta que los dos cimientos (`doc-arquitecto` + `audit-tracker`) estén 🟢 (§0). No planificación de portafolio. No estado VERIFICADO de externos ni health-check vivo. No EGRESO arbitrario (solo los que la caja ya cubre con compuerta probada: merge vía `/orquestar`, publicación vía `/publicar`). No modo boceto greenfield. No runtime de ruteo con estado. **No retro del proceso** (`retrospectiva` — fuera de alcance explícito, `decisiones/013`; si entra en v2+ será ruteo al comando de `audit-tracker`). **No reimplementar NINGÚN trabajo de la caja** — delegado faltante = hueco que se lleva a firma, jamás un reemplazo "temporal". No proyectos fuera de GitHub. No 6 compuertas en serie.

## 12. Criterios de aceptación (borrador)

- [ ] **Fidelidad de intención (el norte):** el objetivo leído en la fase *analizar* se preserva y es trazable en cada fase; al *cerrar*, `batuta` puede mostrar la cadena **idea → plano → encargos → obra** sin eslabones rotos, y cualquier desvío entre lo pedido y lo construido aparece como hallazgo, no enterrado. El contexto de cada traspaso queda explícito (quién recibió qué y por qué).
- [ ] Con plano firmado: produce la RUTA y la presenta a firma por horizonte ANTES de delegar el primer encargo; sin firma no delega nada.
- [ ] Sin plano: rutea a `/documentar` + `/auditar-docs` y NO planifica hasta tener contrato — escribe CERO contenido de contrato.
- [ ] El Manifiesto lista cada externo con QUÉ/POR QUÉ(file:line)/CÓMO/QUIÉN/ESTADO; un REQUERIDO no provisto BLOQUEA; ningún secreto aparece versionado (gitleaks limpio).
- [ ] Con un externo faltante sembrado: PIDE y BLOQUEA, no adivina. Uno descubierto a mitad pausa ESE carril sin frenar los demás.
- [ ] Reporta PROVISTO-sin-verificar honesto; jamás marca VERIFICADO sin prueba de capacidad (repo con env var presente pero scope insuficiente sembrado).
- [ ] TODO cambio de código pasa por `/orquestar`/`/proximo-encargo`: batuta jamás abre rama de feature ni mergea (inspección del árbol de ramas).
- [ ] Cero doble-firma y cero merge sin firma (única excepción por default: el bookkeeping del tracker heredado de `decisiones/005` — contabilidad de un cierre YA firmado, automerge de `/orquestar`).
- [ ] Dato entrante de un externo con inyección sembrada: lo etiqueta no-confiable, lo reporta, el loop sigue — no lo obedece (test de inyección en ambos niveles).
- [ ] Un sub-agente que toca un externo propaga la etiqueta "data externa no verificada" (la confianza no es transitiva).
- [ ] **Test de delgadez:** cada fase nombra su delegado; ninguna "hace" trabajo de auditar/documentar/testear/publicar/planificar-desde-cero por su cuenta.

## 13. Referencias

- `fichas/director-de-obra.md` — absorbida como fase 2 (sus 4 decisiones firmadas son invariantes).
- README del audit-tracker — `/orquestar`, el canal de firma, la cola de Issues, el snapshot como cache.
- Diseño 2026-07-18 (workflow 6 agentes: 4 lentes + escéptico + síntesis).

# Ficha de diseño: batuta

> Estado: ⚪ En diseño · v0 MÍNIMA head-first (ver §0) · absorbe a `director-de-obra`
> Diseñada: 2026-07-18 (workflow de diseño 6 agentes) · Construir v0 tras asentar `doc-arquitecto`

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

Plugin de Claude Code, comando `/batuta`. Genérico (cualquier proyecto en GitHub). Mezcla `/orquestar` (loop determinístico con firma) con workflows (fan-out multi-agente).

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
| Retro del proceso al cerrar | `retrospectiva` (opcional, cuando exista) |

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
- **Egreso tipado:** EGRESO-que-lee idempotente (GET/search) se batchea en una autorización de sesión; EGRESO-que-escribe-o-tiene-efecto (POST/mail/pago/deploy) lleva compuerta INDIVIDUAL. Umbral restrictivo por default, se afloja con historial, nunca por adelantado.
- **Fallo parcial:** si un delegado cae, batuta REPORTA, escala y sostiene el estado — jamás suple el trabajo del delegado caído (la tentación de "lo arreglo yo para no frenar el loop" es god-object por necesidad, y es máxima justo en el fallo).

## 8. Guardrails anti-god-object

- **Test de delgadez (criterio de aceptación verificable):** cada fase declara a qué tool delega el trabajo real y qué produce ella (solo: composición, ruteo o compuerta). Fase que "hace" trabajo sin delegado = bug del plano.
- NO un detector de externos propio (cosecha la salida de doc-arquitecto/audit-tracker). NO un bus/cola propio (Issues ya es la cola). NO su propio protocolo de firma. NO escribir código/rama/merge (todo cambio rutea a `/orquestar`, sin importar el tamaño). NO fabricar el plano. NO re-auditar/re-escanear. NO hacer el fan-out a mano.
- **La banda angosta:** la selección de tools debe ser genuinamente CONDICIONAL (no un playbook estático) pero ACOTADA (no re-análisis infinito). v1 fija EXPLÍCITAMENTE dónde para.

## 9. Absorción de director-de-obra

`director-de-obra` **no se construye por separado ni se archiva: se pliega como la fase 2 (Planificación).** En el índice queda marcado "absorbida por batuta" (rastro de decisión, no se borra). Sus 4 capacidades entran intactas como maquinaria de la fase. Sus **4 decisiones firmadas (2026-07-18) viajan como invariantes** (D1 enumera-y-clasifica; D2 GitHub-first; D3 baseline liviano; D4 consume cartera) — pero son PISO, no techo: batuta EJECUTA y toca externos, y eso abre decisiones nuevas que ninguna de las 4 cubre (ver §10). La deferida "¿herramienta o capacidad?" se auto-resuelve: batuta ES la herramienta, la planificación es su fase.

## 10. Decisiones

Registro completo en `decisiones/`. Notación: las firmadas llevan **FIRMADA + fecha**; las abiertas, **PENDIENTE + dueño + qué la desbloquea**. Los `- [ ]` quedan reservados a los criterios de aceptación de §12 — miden al software, no al humano.

### Firmadas

- **Mono-proyecto en v0 y v1** — FIRMADA 2026-07-18 · `decisiones/001-mono-proyecto.md`. Portafolio = v2. Rompe la dependencia dura de `cartera`; enumeración trivial = el repo. Aplicada en §0 y §4.
- **Granularidad: Compuerta Cero** — FIRMADA 2026-07-19 · `decisiones/002-granularidad-de-compuertas.md`. Fases 1-4 colapsan en UNA firma de «plan aprobado por horizonte», con diff; gates duros individuales solo en ejecutar y cerrar. Aplicada en §4 y §11.
- **Modo boceto greenfield: no existe** — FIRMADA 2026-07-19 · `decisiones/003-modo-boceto-greenfield.md`. Sin plano se rutea siempre a `/documentar`; un plano-borrador ratificable roza fabricar contrato. Aplicada en §11 y §12.
- **Detección de externos: campo estructurado, jamás detector propio** — FIRMADA 2026-07-19 · `decisiones/004-deteccion-de-externos.md`. v0 cosecha best-effort lo que los cimientos flaguean; v1 agrega el campo `externos` a `doc-arquitecto` Y `audit-tracker`. El mini-detector queda descartado por §8.
- **Clase «micro»: no existe** — FIRMADA 2026-07-19 · `decisiones/005-clase-micro.md`. Todo cambio de código va a `/orquestar`, sin excepción por tamaño.
- **Sustrato: markdown puro** — FIRMADA 2026-07-19 · `decisiones/006-sustrato-markdown-puro.md`. Comando `.md`, sin código, sin build, sin dependencias. Consecuencia: los criterios de §12 se verifican con **corridas sembradas**, no con tests unitarios.
- **Corte de versiones v0/v1/v2** — FIRMADA 2026-07-19 · `decisiones/007-corte-de-versiones.md`. Ver §0.
- **Absorción de `director-de-obra` como fase 2** — FIRMADA 2026-07-18 · `decisiones/008-absorcion-director-de-obra.md`. Ver §9.
- **Rúbrica de confidence: cuantitativa** — FIRMADA 2026-07-20 · `decisiones/014-rubrica-de-confidence.md`. Puntaje `confidence = clamp(0.5·E + 0.3·R − 0.4·B, 0, 1)`; el número ordena pero nunca aprueba solo (mitigación de la falsa precisión). Aplicada en la fase 2 de `plugins/batuta/commands/batuta.md`. Desbloqueó S04.

### Pendientes

- **PENDIENTE — Autenticación de la firma** · `decisiones/009-autenticacion-de-la-firma.md`. Dueño: Fede. El `✅ validado` de un PR es dato entrante de un externo, la clase que §7 declara no-confiable — y a la vez es lo único que mueve el loop. Desbloquea: S06.
- **PENDIENTE — Escaneo de secretos en v0** · `decisiones/010-secretos-en-v0.md`. Dueño: Fede. §12 exige «gitleaks limpio» pero eso está delegado a `publicador`, que no existe. Desbloquea: S05.
- **PENDIENTE — Acto de ratificación del plano** · `decisiones/011-ratificacion-del-plano.md`. Dueño: Fede. Desbloquea: S02.
- **PENDIENTE — Umbral de egreso** · `decisiones/012-umbral-de-egreso.md`. Dueño: Fede. Desbloquea: S07.
- **PENDIENTE — `retrospectiva` opcional** · `decisiones/013-retrospectiva-opcional.md`. Dueño: Fede. Desbloquea: S08.
- **PENDIENTE — Decisiones nuevas de ejecutar + externos** · `decisiones/015-eje-externo.md`. Dueño: Fede. Desbloquea: auditar el eje externo una vez escrito el modelo de S05.

## 11. Fuera de alcance (v0 y v1)

- No construir hasta que los dos cimientos (`doc-arquitecto` + `audit-tracker`) estén 🟢 (§0). No planificación de portafolio. No estado VERIFICADO de externos ni health-check vivo. No EGRESO arbitrario (solo los que la caja ya cubre con compuerta probada: merge vía `/orquestar`, publicación vía `/publicar`). No modo boceto greenfield. No runtime de ruteo con estado. **No reimplementar NINGÚN trabajo de la caja** — delegado faltante = hueco que se lleva a firma, jamás un reemplazo "temporal". No proyectos fuera de GitHub. No 6 compuertas en serie.

## 12. Criterios de aceptación (borrador)

- [ ] **Fidelidad de intención (el norte):** el objetivo leído en la fase *analizar* se preserva y es trazable en cada fase; al *cerrar*, `batuta` puede mostrar la cadena **idea → plano → encargos → obra** sin eslabones rotos, y cualquier desvío entre lo pedido y lo construido aparece como hallazgo, no enterrado. El contexto de cada traspaso queda explícito (quién recibió qué y por qué).
- [ ] Con plano firmado: produce la RUTA y la presenta a firma por horizonte ANTES de delegar el primer encargo; sin firma no delega nada.
- [ ] Sin plano: rutea a `/documentar` + `/auditar-docs` y NO planifica hasta tener contrato — escribe CERO contenido de contrato.
- [ ] El Manifiesto lista cada externo con QUÉ/POR QUÉ(file:line)/CÓMO/QUIÉN/ESTADO; un REQUERIDO no provisto BLOQUEA; ningún secreto aparece versionado (gitleaks limpio).
- [ ] Con un externo faltante sembrado: PIDE y BLOQUEA, no adivina. Uno descubierto a mitad pausa ESE carril sin frenar los demás.
- [ ] Reporta PROVISTO-sin-verificar honesto; jamás marca VERIFICADO sin prueba de capacidad (repo con env var presente pero scope insuficiente sembrado).
- [ ] TODO cambio de código pasa por `/orquestar`/`/proximo-encargo`: batuta jamás abre rama de feature ni mergea (inspección del árbol de ramas).
- [ ] Cero doble-firma y cero merge sin firma.
- [ ] Dato entrante de un externo con inyección sembrada: lo etiqueta no-confiable, lo reporta, el loop sigue — no lo obedece (test de inyección en ambos niveles).
- [ ] Un sub-agente que toca un externo propaga la etiqueta "data externa no verificada" (la confianza no es transitiva).
- [ ] **Test de delgadez:** cada fase nombra su delegado; ninguna "hace" trabajo de auditar/documentar/testear/publicar/planificar-desde-cero por su cuenta.

## 13. Referencias

- `fichas/director-de-obra.md` — absorbida como fase 2 (sus 4 decisiones firmadas son invariantes).
- README del audit-tracker — `/orquestar`, el canal de firma, la cola de Issues, el snapshot como cache.
- Diseño 2026-07-18 (workflow 6 agentes: 4 lentes + escéptico + síntesis).

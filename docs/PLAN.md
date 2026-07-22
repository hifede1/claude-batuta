# Plan de sesiones — `batuta` v0

> Fecha: 2026-07-19 · Alcance: `ALCANCE.md` (v0 bootstrap) · Sustrato: markdown puro (`decisiones/006-sustrato-markdown-puro.md`)
>
> **Unidad de estimación: talle S / M / L por sesión.** Propuesta por el documentador y **no ratificada explícitamente** — se usa horas ficticias en un proyecto sin equipo ni deadline, así que el talle mide envergadura relativa, no tiempo. Cambiala si preferís otra unidad.
>
> ⛔ **Toda sesión salvo S01 está bloqueada por la compuerta de precondición** (ver `ALCANCE.md`).
>
> **Cómo se verifica en este proyecto:** al ser markdown puro no hay tests unitarios. Los criterios se verifican con **corridas sembradas** — un repo de prueba preparado a propósito con la condición que se quiere probar — más inspección del `.md`.

---

## S01 — Cerrar la precondición: `doc-arquitecto` en 🟢

🎯 **Planteamiento.** Es la compuerta que habilita toda la obra, y hoy no es auditable: `fede-tools` no está identificado como repo y `#29`/`#21` son números sueltos sin owner. Una compuerta que no se puede evaluar no bloquea nada — cualquiera puede declararla abierta. Esta sesión la convierte en una condición binaria y después la cierra.

🛠️ **Método.**
1. Identificar qué es `fede-tools` y a qué repo pertenecen `#29` y `#21`; escribirlos calificados (`owner/repo#numero`) en `ALCANCE.md`.
2. Definir qué evidencia concreta constituye «install PROBADO» y dejarla escrita como condición binaria.
3. Cerrar el fix.
4. Correr el install en una máquina limpia y ejercitar `/documentar` y `/auditar-docs` de punta a punta sobre un repo de prueba vacío.
5. Actualizar la tabla de cimientos de `ALCANCE.md` con la nueva fecha de verificación.

✅ **Criterios de aceptación.**
- [ ] Los issues están calificados con owner/repo y link *(verificación: inspección de `ALCANCE.md` — cero números de issue sin repo)*
- [ ] El fix está mergeado *(verificación: `gh issue view` muestra el issue cerrado)*
- [ ] El install corre sin error en máquina limpia *(verificación: `/plugin install doc-arquitecto@fede-tools` en un perfil nuevo, salida sin error)*
- [ ] `/documentar` y `/auditar-docs` responden de punta a punta *(verificación: corrida real sobre un repo de prueba vacío; `/documentar` genera el árbol `docs/` y `/auditar-docs` emite informe con las 6 dimensiones)*
- [ ] La tabla de cimientos de `ALCANCE.md` tiene fecha de verificación fresca *(verificación: inspección)*

📚 **Referencias.** [`references/doc-arquitecto.md`](references/) 🔴 · [`references/plugins-claude-code.md`](references/) 🔴

⛓️ **Prerrequisitos.** Ninguno. Es la raíz del plan.

**Estimación: M**

---

## S02 — Andamio del comando + registro de trazabilidad

🎯 **Planteamiento.** El registro de trazabilidad **es el norte del producto** (`VISION.md`), no un detalle de reporte. Si se deja para la fase `cerrar`, se va a descubrir que las fases intermedias nunca guardaron lo que hacía falta y hay que volver a tocarlas todas. El contexto se preserva desde el principio o no se preserva. Esta sesión crea el esqueleto del comando y define la estructura de cadena que TODA fase posterior está obligada a escribir.

🛠️ **Método.**
1. Crear la estructura de plugin y el comando `/batuta` (markdown puro, sin build).
2. Definir el **registro de cadena**: qué campos lleva cada eslabón (`idea → plano → encargos → obra`), qué identificador conecta un encargo con el requisito del plano que lo origina, y dónde se persiste entre fases.
3. Escribir el contrato interno: cada fase declara qué eslabón agrega y qué recibe de la anterior.
4. Resolver `decisiones/011-ratificacion-del-plano.md` — sin acto de ratificación, el contrato no obliga y los criterios de las demás sesiones no se pueden exigir.

✅ **Criterios de aceptación.**
- [ ] El comando `/batuta` existe y arranca *(verificación: `/batuta` en un repo de prueba responde sin error)*
- [ ] Cada una de las 4 fases declara explícitamente qué eslabón de la cadena agrega *(verificación: inspección del `.md` — 4 declaraciones, cero fases mudas)*
- [ ] El registro define el identificador que liga encargo ↔ requisito del plano *(verificación: inspección — el campo existe y es único por requisito)*
- [ ] El acto de ratificación del plano está escrito *(verificación: `decisiones/011` en estado `aceptada` con fecha)*

📚 **Referencias.** [`references/plugins-claude-code.md`](references/) 🔴

⛓️ **Prerrequisitos.** S01 · `decisiones/011-ratificacion-del-plano.md`

**Estimación: M**

---

## S03 — Fase `analizar`

🎯 **Planteamiento.** Un objetivo mal leído envenena las cinco fases siguientes: todo el trabajo posterior es correcto respecto de la cosa equivocada. Por eso esta fase termina devolviéndole al humano su propia intención reformulada. Y es la fase que hace cumplir la regla más dura del plano: **sin plano firmado, `batuta` escribe CERO contrato** — rutea a `/documentar` y frena.

🛠️ **Método.**
1. Con plano firmado: delegar la lectura del estado real a `/audit-tracker` y sintetizar. `batuta` LEE, no re-audita.
2. Sin plano: rutear a `/documentar` + `/auditar-docs` y **frenar**. Cero bytes de contrato escritos.
3. Emitir la compuerta de lectura: «esto entendí que querés y por qué».
4. Escribir el primer eslabón de la cadena definida en S02.
5. **Gotcha conocido:** la tentación de «completar» un plano delgado es máxima acá. Es fabricar contrato — está fuera de alcance y tiene criterio que lo prueba.

✅ **Criterios de aceptación.**
- [ ] Con plano firmado, lee el estado vía `audit-tracker` y no re-audita *(verificación: corrida sembrada sobre repo con plano; inspección de la traza — cero escaneo propio del código)*
- [ ] Devuelve al humano su lectura del objetivo antes de avanzar *(verificación: la corrida se detiene y emite la síntesis)*
- [ ] Sin plano, rutea a `/documentar` y frena *(verificación: corrida sembrada sobre repo sin `docs/`; `git status` limpio al terminar — cero bytes de contrato escritos)*
- [ ] Registra el eslabón `idea` de la cadena *(verificación: inspección del registro tras la corrida)*

📚 **Referencias.** [`references/audit-tracker.md`](references/) 🔴 · [`references/doc-arquitecto.md`](references/) 🔴

⛓️ **Prerrequisitos.** S02

**Estimación: M**

---

## S04 — Fase `planificar` (`director-de-obra` plegado)

🎯 **Planteamiento.** Es la única capacidad legítimamente propia de `batuta` junto con las compuertas: la capacidad absorbida de `director-de-obra`. Produce el grafo de dependencias y los horizontes, y sobre todo hace **la distinción que ES el ruteador de la fase ejecutar**: qué está bloqueado por EJECUCIÓN y qué está bloqueado por FIRMA. Confundirlas es lo que hace que un proyecto espere por algo que nadie tenía que hacer.

🛠️ **Método.**
1. Construir el grafo de dependencias e inversiones sobre el estado leído en S03.
2. Producir horizontes tipo Gantt distinguiendo *gated-por-EJECUCIÓN* vs *gated-por-FIRMA*.
3. Delegar el pase adversarial a un **workflow** de fan-out, contra estado FRESCO (no cacheado).
4. Emitir recomendaciones rankeadas con contrapunto + decisiones-a-firmar.
5. Respetar las 4 invariantes heredadas (D1 enumera-y-clasifica · D2 GitHub-first · D3 baseline liviano · D4 consume cartera) — son PISO, no techo.
6. **Gotcha:** la banda angosta. La selección de tools debe ser condicional pero acotada; sin una cota explícita, esto se va a re-análisis infinito.

✅ **Criterios de aceptación.**
- [ ] Distingue gated-por-EJECUCIÓN de gated-por-FIRMA *(verificación: corrida sembrada con 2 encargos dependientes, uno esperando trabajo y otro esperando firma; ambos aparecen clasificados y distintos)*
- [ ] El pase adversarial se delega a un workflow, no se hace a mano *(verificación: inspección de la traza — hay invocación de workflow)*
- [ ] La banda angosta tiene cota explícita *(verificación: dos objetivos de forma distinta producen RUTAs distintas —descarta el playbook estático— y ninguna corrida supera K iteraciones de re-análisis antes de presentar la RUTA; K escrito en el `.md`)*
- [ ] Las 4 invariantes D1-D4 están citadas y respetadas *(verificación: inspección contra `decisiones/008`)*

📚 **Referencias.** [`references/workflows-fan-out.md`](references/) 🔴 · `decisiones/008-absorcion-director-de-obra.md`

⛓️ **Prerrequisitos.** S03 · `decisiones/014-rubrica-de-confidence.md` (**debe firmarse ANTES**: si se difiere, la implementación la fija de hecho) · decisión humana sobre la cota K de la banda angosta

**Estimación: L**

---

## S05 — Externos y ruteo MÍNIMOS (best-effort)

🎯 **Planteamiento.** El Manifiesto de Externos es un contrato de **NECESIDADES, jamás de SECRETOS**. `batuta` identifica y pide; nunca fabrica, asume, mockea ni auto-provisiona. Guarda la necesidad, nunca el valor. Y en v0 no corre un detector propio: **cosecha** lo que `doc-arquitecto` y `audit-tracker` ya flaguearon — un detector propio sería god-object, y §8 lo prohíbe explícitamente.

🛠️ **Método.**
1. Cosechar los externos identificados por las fases `analizar` y `planificar`. Cero detección propia.
2. Emitir el Manifiesto: por cada externo QUÉ · POR QUÉ (con `file:line`) · CÓMO se provee · QUIÉN (siempre el humano) · ESTADO.
3. Estado binario REQUERIDO / PROVISTO: verifica PRESENCIA de la env var o el MCP, **sin leer el valor**. Nunca VERIFICADO (es v2).
4. Externo REQUERIDO no provisto = prerrequisito ⛓️ en la cola de Issues con label `externo`, y **BLOQUEA**.
5. Reentrancia: si `ejecutar` descubre un externo nuevo, pausa ESE carril, pide, reanuda. **Definir qué es un «carril»** — hoy el término se usa sin definirse.
6. Ruteo mínimo: partitura descriptiva de la topología de confianza, sin runtime.
7. Resolver `decisiones/010-secretos-en-v0.md`: `gitleaks` está delegado a `publicador`, que no existe.

✅ **Criterios de aceptación.**
- [ ] El Manifiesto lista cada externo con QUÉ / POR QUÉ (`file:line`) / CÓMO / QUIÉN / ESTADO *(verificación: inspección del manifiesto de una corrida sembrada con 2 externos)*
- [ ] Un REQUERIDO no provisto BLOQUEA y PIDE, no adivina *(verificación: corrida con externo faltante sembrado; la corrida se detiene y emite el pedido con contexto)*
- [ ] Ningún secreto queda versionado *(verificación: según lo que resuelva `decisiones/010` — hoy el criterio no es ejecutable sin `publicador`)*
- [ ] Un externo descubierto a mitad pausa solo su carril *(verificación: corrida con 2 encargos independientes y un externo faltante sembrado en uno; ese queda bloqueado y el otro llega a su compuerta)*
- [ ] «Carril» está definido en el `.md` *(verificación: inspección — el término tiene definición, no solo usos)*
- [ ] Reporta PROVISTO-sin-verificar honesto *(verificación: repo sembrado con env var presente pero scope insuficiente; jamás marca VERIFICADO)*
- [ ] No existe detección propia de externos *(verificación: inspección — cero instrucciones de escaneo; solo cosecha)*

📚 **Referencias.** [`references/perimetro-de-confianza.md`](references/) 🔴 · [`references/audit-tracker.md`](references/) 🔴

⛓️ **Prerrequisitos.** S04 · `decisiones/010-secretos-en-v0.md`

**Estimación: L**

---

## S06 — Compuerta Cero

🎯 **Planteamiento.** Las fases 1 a 4 son baratas y reversibles, así que colapsan en UNA firma de «plan aprobado por horizonte», con diff y no big-bang. Pero acá aparece **la paradoja más filosa del diseño**: el canal de firma es un `✅ validado` en un PR — o sea, un dato que ENTRA de un externo, exactamente la clase que §7 declara no-confiable y que «nunca mueve el loop». Y la firma es lo único que SÍ mueve el loop. Esta sesión tiene que resolver esa pinza antes de escribir una línea.

🛠️ **Método.**
1. Resolver `decisiones/009-autenticacion-de-la-firma.md`: quién es el dueño autorizado, qué identidad se comprueba, qué pasa con colaboradores y bots. Escribir la excepción explícita en el modelo de confianza.
2. Implementar la firma única por horizonte, presentada como **diff** sobre el horizonte anterior.
3. Reusar el canal de firma de `/orquestar` — **no armar uno propio**.
4. **Gotcha:** contrato quirúrgico. `batuta` NO duplica la firma de encargo (esa es de `/orquestar`); solo es dueña de externos, egreso y workflow→cola. Sin esa línea, o algo se mergea sin firma, o el humano firma dos veces.

✅ **Criterios de aceptación.**
- [ ] El modelo de autenticación de la firma está escrito y es una excepción explícita al perímetro de confianza *(verificación: `decisiones/009` en estado `aceptada` + inspección del `.md`)*
- [ ] Sin firma no se delega NADA *(verificación: corrida sembrada donde el humano no firma; cero encargos delegados, cero issues creados)*
- [ ] La firma se presenta como diff por horizonte, no big-bang *(verificación: corrida con 2 horizontes; el segundo muestra solo el delta)*
- [ ] Cero doble-firma *(verificación: corrida sembrada con N encargos; al humano se le pide firma exactamente una vez por horizonte y una vez por encargo vía `/orquestar` — nunca dos veces por lo mismo)*
- [ ] Reusa el canal de `/orquestar` *(verificación: inspección — cero protocolo de firma propio)*

📚 **Referencias.** [`references/audit-tracker.md`](references/) 🔴 · [`references/perimetro-de-confianza.md`](references/) 🔴

⛓️ **Prerrequisitos.** S05 · `decisiones/009-autenticacion-de-la-firma.md` (**bloqueante duro**)

**Estimación: L**

---

## S07 — Fase `ejecutar-con-compuertas`

🎯 **Planteamiento.** Acá `batuta` toca lo irreversible, y su disciplina se define por lo que NO hace: jamás abre una rama de feature, jamás mergea, jamás escribe código. Todo cambio rutea a `/orquestar`, sin importar el tamaño. Loops ANIDADOS: `batuta` itera FASES, `/orquestar` itera ENCARGOS. Las compuertas propias son exactamente tres — externos, EGRESO outward, workflow→cola — y ninguna más.

🛠️ **Método.**
1. Mezclar `/orquestar` (trabajo secuencial que converge a merge) con workflows (trabajo divergente/exploratorio).
2. Abrir SOLO las tres compuertas META que ninguna tool posee.
3. Egreso tipado: EGRESO-que-lee idempotente (GET/search) se batchea en una autorización de sesión; EGRESO-que-escribe-o-tiene-efecto (POST/mail/pago/deploy) lleva compuerta INDIVIDUAL.
4. Resolver `decisiones/012-umbral-de-egreso.md`: hoy «umbral restrictivo por default, se afloja con historial» no declara ni umbral ni qué historial autoriza aflojarlo.
5. **Gotcha:** ante un delegado caído, la tentación de «lo arreglo yo para no frenar el loop» es máxima. Es god-object por necesidad. Se reporta, se escala, se sostiene el estado.

✅ **Criterios de aceptación.**
- [ ] TODO cambio de código pasa por `/orquestar` *(verificación: corrida completa; `git branch -a` no muestra ninguna rama creada por `batuta`, y el log no muestra merges suyos)*
- [ ] Cero merge sin firma *(verificación: todo merge a la rama principal tiene su PR con firma del dueño — única excepción por default, la heredada de `decisiones/005`: el PR de bookkeeping del tracker que refleja un cierre YA firmado, automerge de `/orquestar`, jamás de `batuta`)*
- [ ] Egreso tipado funciona en ambos sentidos *(verificación: corrida sembrada con un GET y un POST; el GET entra en la autorización de sesión, el POST frena con compuerta individual)*
- [ ] El umbral de egreso está escrito con número *(verificación: `decisiones/012` en estado `aceptada`; el umbral aparece en el `.md`)*
- [ ] Dato entrante de un externo con inyección sembrada se etiqueta, se reporta y NO se obedece *(verificación: corrida con inyección plantada en una respuesta de API, probada en ambos niveles — encargo y fase)*
- [ ] Un sub-agente que toca un externo propaga la etiqueta «data externa no verificada» *(verificación: corrida con workflow de research; la etiqueta aparece aguas arriba)*

📚 **Referencias.** [`references/audit-tracker.md`](references/) 🔴 · [`references/perimetro-de-confianza.md`](references/) 🔴

⛓️ **Prerrequisitos.** S06 · `decisiones/012-umbral-de-egreso.md`

**Estimación: L**

---

## S08 — Fase `cerrar`

🎯 **Planteamiento.** Cerrar es donde el norte se cobra: `batuta` exhibe la cadena `idea → plano → encargos → obra` y **todo desvío entre lo pedido y lo construido aparece como hallazgo, no enterrado**. La re-auditoría no la hace ella: la DELEGA a `audit-tracker`, que pinta de verde solo lo mergeado y firmado.

🛠️ **Método.**
1. Delegar la re-auditoría a `/audit-tracker`. `batuta` no re-escanea.
2. Exhibir la cadena completa usando el registro definido en S02.
3. Persistir un baseline liviano de la corrida (invariante D3).
4. Reportar: qué se ejecutó, qué espera firma, qué se escaló, qué externos faltaron.
5. Resolver `decisiones/013-retrospectiva-opcional.md`: hoy «opcional» abre un tercer estado que rompe el binario delega-o-BLOQUEA.

✅ **Criterios de aceptación.**
- [ ] La re-auditoría se delega, no se hace *(verificación: inspección de la traza — hay invocación de `/audit-tracker`, cero escaneo propio)*
- [ ] Exhibe la cadena completa sin eslabones rotos *(verificación: corrida completa; cada encargo referencia su requisito de origen y cada pieza de obra su encargo — o su asiento autenticado según los salvos de `registro-de-cadena.md` §6: decisión del dueño / bookkeeping de `005`)*
- [ ] Un desvío sembrado aparece como hallazgo explícito *(verificación: corrida donde un encargo construye algo distinto de lo pedido; el cierre lo reporta, no lo entierra)*
- [ ] El estado de `retrospectiva` está resuelto *(verificación: `decisiones/013` en estado `aceptada`; la fase `cerrar` la delega o la declara fuera de alcance — sin tercer estado)*
- [ ] Persiste el baseline liviano *(verificación: el artefacto existe tras la corrida)*

📚 **Referencias.** [`references/audit-tracker.md`](references/) 🔴

⛓️ **Prerrequisitos.** S07 · `decisiones/013-retrospectiva-opcional.md`

**Estimación: M**

---

## S09 — Batería de verificación sembrada

🎯 **Planteamiento.** Las reglas anti-god-object sostienen el diseño entero, y **una regla que no se prueba es una intención**. El propio documento declara dos veces que el momento de máximo riesgo es el fallo de un delegado — y hasta esta sesión, ningún criterio lo prueba. Acá se cierra esa deuda: cada regla innegociable recibe su escenario sembrado.

🛠️ **Método.** Construir un repo de prueba por escenario y correr `batuta` contra cada uno.
1. **Test de delgadez** — cada fase nombra su delegado.
2. **Delegado faltante** — BLOQUEA y reporta como hueco-a-construir.
3. **Delegado caído a mitad** — reporta, escala, sostiene el estado; cero trabajo suplido.
4. **Inyección en dato externo** — etiquetada, reportada, desobedecida, en ambos niveles.

✅ **Criterios de aceptación.**
- [ ] Test de delgadez: ninguna fase «hace» trabajo de auditar / documentar / testear / publicar / planificar-desde-cero *(verificación: inspección — cada fase declara su delegado y qué produce ella, que solo puede ser composición, ruteo o compuerta)*
- [ ] Delegado faltante → BLOQUEA *(verificación: corrida sembrada pidiendo criterios→tests sin `verificador`; frena y emite hueco-a-construir, cero tests escritos por `batuta`)*
- [ ] Delegado caído → reporta, escala, sostiene estado *(verificación: corrida donde `/audit-tracker` falla durante `cerrar`; hay reporte + escalamiento + estado persistido, y cero trabajo del delegado hecho por `batuta`)*
- [ ] Inyección → etiquetada y desobedecida *(verificación: escenario sembrado en ambos niveles; el loop sigue, la instrucción no se ejecuta)*

📚 **Referencias.** [`references/perimetro-de-confianza.md`](references/) 🔴

⛓️ **Prerrequisitos.** S08

**Estimación: L**

---

## Resumen

| Sesión | Objetivo | Talle | Bloqueada por decisión |
|---|---|---|---|
| S01 | Precondición `doc-arquitecto` 🟢 | M | — |
| S02 | Andamio + trazabilidad | M | `011` ratificación |
| S03 | Fase `analizar` | M | — |
| S04 | Fase `planificar` | L | `014` rúbrica + cota K |
| S05 | Externos y ruteo mínimos | L | `010` secretos |
| S06 | Compuerta Cero | L | `009` autenticación de la firma |
| S07 | Fase `ejecutar-con-compuertas` | L | `012` umbral de egreso |
| S08 | Fase `cerrar` | M | `013` retrospectiva |
| S09 | Verificación sembrada | L | — |

**7 de 9 sesiones están bloqueadas por una decisión pendiente.** No es un defecto del plan: es el plan diciéndote la verdad sobre dónde falta firma.

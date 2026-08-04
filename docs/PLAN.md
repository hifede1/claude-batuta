# Plan de sesiones — `batuta` v0

> Fecha: 2026-07-19 · Alcance: `ALCANCE.md` (v0 bootstrap) · Sustrato: markdown puro (`decisiones/006-sustrato-markdown-puro.md`)
>
> **Unidad de estimación: talle S / M / L por sesión.** Propuesta por el documentador y **no ratificada explícitamente** — se usa horas ficticias en un proyecto sin equipo ni deadline, así que el talle mide envergadura relativa, no tiempo. Cambiala si preferís otra unidad.
>
> ⛔ **Toda sesión salvo S01 está bloqueada por la compuerta de precondición** (ver `ALCANCE.md`).
>
> **Cómo se verifica en este proyecto:** al ser markdown puro no hay tests unitarios. Los criterios se verifican con **corridas sembradas** — un repo de prueba preparado a propósito con la condición que se quiere probar — más inspección del `.md`. **Alcance precisado por `decisiones/030` (2026-07-30):** «markdown puro» fija el sustrato del **producto** —el comando es `.md`, sin build ni dependencias de instalación— y **no** impide infraestructura de **verificación** del repo. Los criterios de aceptación de una sesión siguen verificándose con corridas sembradas, como dice esta línea; lo que `030` habilita es verificar **coherencia entre documentos** (`.github/workflows/coherencia.yml`).

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

# Mantenimiento — después de la obra v0

> **Por qué existe esta sección.** `FICHA.md` declara la obra **v0 COMPLETA 9/9 · en
> mantenimiento**, pero hasta el 2026-07-24 el plan terminaba en S09. Como `registro-de-cadena.md`
> §6 marca eslabón roto todo encargo cuyo requisito no exista en `plano_version`, **el trabajo de
> mantenimiento era estructuralmente indelegable**: `batuta` no podía dirigir su propio
> mantenimiento. Detectado en la corrida `2026-07-24-arreglar-path-de-corridas` (hallazgos D4/D5).
>
> Las sesiones de acá abajo se numeran en la misma serie (S10, S11, …) y siguen las mismas reglas.
> Un fix de campo sigue siendo válido, pero **necesita su requisito acá** para tener asiento.

## S10 — Contrato de persistencia del registro

🎯 **Planteamiento.** El contrato de persistencia (`registro-de-cadena.md` §4) declara **un solo**
modo de resolución de `${CLAUDE_PLUGIN_DATA}` —el de marketplace— y **omite el modo inline**
(`--plugin-dir`). Y el inline es, justamente, el que usan las **corridas sembradas**: el método de
verificación del proyecto por `decisiones/006` (markdown puro → sin tests unitarios → se verifica
corriendo). **El contrato no documenta el path que usa su propio método de verificación.** La
omisión ya produjo **dos lecturas erróneas reales**: el hallazgo #2 de `s09-bateria` la tomó por
defecto del harness, y la corrida del 2026-07-24 tomó la evidencia de S09 por «historial huérfano a
migrar» — migrarla habría **destruido evidencia de auditoría**.

🛠️ **Método.** Precisión de documentación, cero cambio de comportamiento.
1. Corregir `registro-de-cadena.md` §4: la resolución depende del **modo de carga**.
2. Dejar escrito que los registros de `<plugin>-inline/` de las corridas sembradas **no se
   migran**: son evidencia primaria, y su path es el correcto para el modo en que corrieron.
3. Asentar el cierre del hallazgo #2 de `s09-bateria-2026-07-22.md` **por explicación, no por
   reparación**: no había defecto: el CLI fija la variable según el modo de carga y exportarla a
   mano no la sobreescribe.
4. Dejar escrita la consecuencia operativa: **el registro de cadena NO es continuo entre modos.**

✅ **Criterios de aceptación.** — **CERRADA 2026-07-25 (PR #50, encargo #49)**
- [x] `registro-de-cadena.md` §4 declara **ambos** modos con su path resultante *(verificación: inspección — el texto nombra `--plugin-dir` → `<plugin>-inline/` y marketplace → `<plugin>-<marketplace>/`)* → `:105-113`
- [x] La nota de no-migración de la evidencia de S09 está en §4, nombrando los tres repos sembrados *(verificación: inspección — `prueba-s09-faltante`, `prueba-s09-caido`, `prueba-s09-inyeccion` aparecen citados)* → `:127-139`
- [x] El hallazgo #2 de `s09-bateria-2026-07-22.md` queda marcado como cerrado con su explicación *(verificación: inspección del archivo de la batería — el hallazgo lleva su resolución escrita, sin borrarse)* → `s09-bateria:47`, con 19 inserciones y **cero deleciones**
- [x] La discontinuidad del registro entre modos queda declarada como límite conocido *(verificación: inspección — §4 lo dice junto al límite «local a la máquina» que ya declara)* → `:157-171`

📚 **Referencias.** [`references/plugins-claude-code.md`](references/) 🟢

⛓️ **Prerrequisitos.** — *(ninguno: es precisión de documentación, no obra nueva)*

**Estimación: S**

---

## S11 — Contabilidad de la ficha

🎯 **Planteamiento.** La `FICHA.md` **se contradice a sí misma dentro de su propia §10**: la
sección de firmadas declara el paraguas `015` **CERRADO 2026-07-24** con sus tres ADRs (`019`,
`020`, `021`), y doce líneas más abajo la sección de pendientes lo sigue listando como
**PENDIENTE**. La entrada pendiente ya lleva una nota que reconoce el drift y lo declara «fuera del
alcance de este PR» — o sea, la contradicción está **documentada y sin resolver**.

Aparte, `docs/decisiones/` salta de `016` a `018`. Diagnosticado en la corrida
`2026-07-25-ejecutar-s10`: **`017` nunca existió**. `016` y `018` nacieron en el mismo commit
(`9183665`, PR #24, junto con `014`); no hay archivo borrado, ni mención en ningún commit, ni en el
tracker, ni en `docs/`. Es un número **saltado al redactar tres ADRs de un saque**.

**Por qué importa y no es prolijidad.** La ficha es la **precondición que `batuta` lee en cada
corrida**. Ya hubo un bug de campo por leer mal esta cabecera: en la primera corrida real contra
`cartera`, `batuta` tomó una *mención* de «firmado» por la firma (fix #37/#38, que endureció la
regla a la línea exacta de `011`). Un §10 que afirma y niega lo mismo es material para el próximo
error de lectura, y un hueco de numeración sin explicar hace que cada lector nuevo lo investigue de
cero — como pasó en esta misma serie.

🛠️ **Método.** Contabilidad, cero cambio de comportamiento y cero decisión nueva.
1. Resolver la contradicción de `015` en §10: la evidencia ya está del lado del cierre — el
   CHANGELOG del tracker lo declara cerrado el 2026-07-24 y los tres ADRs (`019`/`020`/`021`)
   están firmados y en disco. **No se re-decide nada**: se hace que la ficha diga lo que ya es.
2. Declarar el hueco `017` **con su diagnóstico**, como número **no usado y no reutilizable** —
   mismo principio que `registro-de-cadena.md` §2 fija para los IDs de requisito: un identificador
   que no se usó no se recicla, porque reciclarlo rompe la trazabilidad de lo escrito antes.

✅ **Criterios de aceptación.**
- [ ] `FICHA.md` §10 **no** lista `015` simultáneamente como firmada y como pendiente *(verificación: inspección — una sola entrada de `015` en §10, del lado que corresponde, y la nota de drift ya no aplica)*
- [ ] El hueco de numeración `017` queda declarado como número **no usado y no reutilizable**, con su diagnóstico *(verificación: inspección — la declaración nombra que `016` y `018` nacieron en el commit `9183665` y que `017` nunca existió)*

> **Fuera de alcance, por diseño.** La consolidación de la doble `Procedencia` de la cabecera **no
> es criterio de S11**: la hizo el PR que abrió esta sesión. Tenía que ser así — `011` obliga a
> re-estampar la cabecera al tocar el plano, así que abrir S11 «para arreglar la cabecera» habría
> agregado un tercer bloque encima de los dos a consolidar. El arreglo se mordía la cola.

📚 **Referencias.** — *(ninguna nueva: se lee contra `FICHA.md` §10 y `docs/decisiones/`)*

⛓️ **Prerrequisitos.** — *(ninguno)*

**Estimación: S**

---

## S12 — Aplicar el versionado del plano y saldar el drift de `011`

🎯 **Planteamiento.** `decisiones/023` fija el **sufijo incremental** como desambiguación de
`plano_version` dentro del día. Falta bajarlo al contrato que lo usa: `registro-de-cadena.md` §3
declara hoy que la versión es la fecha de firma, **sin decir qué pasa cuando hay dos el mismo día** —
y esa omisión es la que dejó ciega a la causal 7 de §6.

Aparte, un drift chico con consecuencia grande: `FICHA.md` §10 `:132` describe a `011` como
**«aceptada 2026-07-19»**, que es su estado **anterior** a la mesa de firmas. El ADR está
`✅ FIRMADA` desde la re-ratificación del **2026-07-23**, con Procedencia completa. **La ficha
quedó atrasada respecto del ADR** — y `011` es la decisión que define qué cuenta como plano firmado,
o sea la precondición de toda corrida.

🛠️ **Método.** Contabilidad y precisión de contrato. Cero decisión nueva: `023` ya decidió.
1. `registro-de-cadena.md` §3: declarar la regla del sufijo con su forma literal y la aclaración de
   que la primera ratificación del día **no** lo lleva.
2. Dejar dicho en §3 —o donde se lea junto a la causal— **por qué** existe: sin sufijo, la causal 7
   de §6 no puede disparar dentro del día.
3. `FICHA.md` §10 `:132`: que la entrada de `011` refleje la re-ratificación del 2026-07-23 y su
   estado real, con el mismo formato que las demás.

✅ **Criterios de aceptación.**
- [ ] `registro-de-cadena.md` §3 declara la regla del sufijo incremental, incluyendo que la primera ratificación del día no lo lleva *(verificación: inspección — el texto muestra la forma `AAAA-MM-DD (N)` y remite a `decisiones/023`)*
- [ ] Queda escrito que sin el sufijo la causal 7 de §6 es inauditable dentro del día *(verificación: inspección — la consecuencia está dicha donde se lee el contrato de versión, no solo en el ADR)*
- [ ] `FICHA.md` §10 refleja el estado real de `011`: `FIRMADA`, re-ratificada 2026-07-23 *(verificación: inspección — la entrada ya no dice «aceptada 2026-07-19» y coincide con `decisiones/011-ratificacion-del-plano.md:3`)*

📚 **Referencias.** — *(ninguna nueva)*

⛓️ **Prerrequisitos.** `decisiones/023` **FIRMADA** — sin el ADR ratificado no hay regla que bajar.

**Estimación: S**

---

## S13 — Cerrar el contrato de firma

🎯 **Planteamiento.** Los tres huecos que quedaron abiertos al ejecutar S10–S12 **no son deuda de una
sesión: son peaje de todas las siguientes.** Y dos ya están decididos (`024`, `025`); lo que falta es
bajarlos a los documentos que los usan y **aplicar** la separación de cuentas, que es lo único de
toda la serie que no se resuelve escribiendo.

El más grave es el de `009`: autentica la firma por `merged_by` == dueño anclado, **pero el agente
opera con esa misma credencial**. Todos los registros de S10–S12 dicen «autenticado por `merged_by`»
y es cierto de hecho —los mergeó Fede— pero la única prueba es la traza del agente, que es
exactamente lo que `009` rechaza como fuente de verdad. **El modelo de firma descansaba en un
metadato que no distingue lo que dice distinguir.**

🛠️ **Método.** Bajar `024` y `025` a contrato, y aplicar la separación. Cero decisión nueva.
1. Reflejar el patrón único de sello (`024`) donde se lee el procedimiento de firmar un ADR, sin
   editar `018` —que sigue vigente y correcto— sino precisando su procedimiento.
2. Reflejar en `registro-de-cadena.md` §6 que el valor probatorio de `merged_by` **depende** de la
   separación de credenciales de `025`: el primer salvo lo invoca y hoy lo daba por sentado.
3. **Aplicar `025`**: `estebaproject` con permiso de push en el repo, y el agente operando con esa
   cuenta. Es cambio de configuración de GitHub, no documentación — **egreso-que-escribe con firma
   propia** (`012`), no lo destraba el horizonte de la sesión.
4. Dejar escrito que el pasado **no se re-autentica**: los merges de S10–S12 se hicieron con
   credencial compartida y quedan como están.

✅ **Criterios de aceptación.**
- [ ] El patrón único de sello de `024` está escrito donde se lee el procedimiento de firmar un ADR *(verificación: inspección — un ADR nuevo se firma en el PR que lo propone; queda dicho cuándo sigue valiendo nacer PENDIENTE: solo si la elección humana todavía no ocurrió)*
- [ ] `registro-de-cadena.md` §6 declara que el primer salvo depende de la separación de credenciales *(verificación: inspección — el salvo del PR de decisión del dueño remite a `025`, y dice que sin credenciales separadas `merged_by` no autentica)*
- [ ] La separación está **aplicada y verificable** *(verificación: `gh api repos/hifede1/claude-batuta/collaborators` lista a `estebaproject` con push, y un PR abierto por el agente muestra autor `estebaproject`)*
- [ ] Queda escrito que los merges de S10–S12 **no se re-autentican** *(verificación: inspección — la limitación está dicha donde alguien la buscaría, no solo en `025`)*

📚 **Referencias.** [`references/perimetro-de-confianza.md`](references/) · [`references/audit-tracker.md`](references/)

⛓️ **Prerrequisitos.** `decisiones/024` y `decisiones/025` **FIRMADAS**.

**Estimación: M** — el criterio 3 es operativo y toca permisos del repositorio; los otros tres son
escritura de contrato.

---

## S14 — Cerrar la aplicación de `025`: mecanismo y canal ejercitado

🎯 **Planteamiento.** S13 firmó y aplicó `025`, pero dejó dos cabos que la vuelven frágil.

**El primero es un defecto de implementación del propio agente**, detectado por el dueño al cerrar la
sesión del 2026-07-26: `025` es **agnóstica del mecanismo** —dice que el agente no opera con la
credencial del dueño, y nada sobre cómo— y el agente lo implementó con `gh auth switch`, que cambia
la **cuenta activa global del perfil del humano**. El dueño quedó operando con la cuenta del agente
sin haberlo pedido. Se corrigió en el momento, y el mecanismo quedó documentado en
[`references/perimetro-de-confianza.md`](references/perimetro-de-confianza.md) **§7, que es su única
fuente**: acá va el **puntero**, jamás el comando.

> ⚠️ **Este tramo declaraba «el mecanismo correcto quedó verificado» y materializaba el comando.
> S19 lo sacó, y el motivo importa.** Lo que se declaraba verificado era `GH_TOKEN=…`, y §7:268 mide
> **ese mismo mecanismo** con **❌ en escritura** — se había dado por verificado tras probarlo con
> **una sola lectura**. Un plano que prescribe lo que su referencia hermana midió roto le está
> diciendo al próximo implementador que repita el error.
>
> **Y la refutación tampoco es firme, así que no se cambia una prescripción por otra:** §7 declara su
> propia tabla `:265-269` **CONFUNDIDA** —las tres filas se midieron mientras otra sesión corría
> `gh auth switch` cada ~30 s—, de modo que **hoy ninguna está medida limpiamente**. La re-medición
> bajo aislamiento probado es **C2 de S19** y **espera una decisión del dueño** sobre con qué
> identidad se mide (`027:43-45` para las filas 2-3, `029:67-70` para la fila 1). **Quien lea §7
> hasta entonces, lea también esta declaración.**
>
> Una prescripción en el plano y una medición en la referencia son **dos fuentes del mismo dato** —
> el diagnóstico de `decisiones/030` aplicado a `references/`, que su alcance no cubría. Lo vigila el
> **chequeo 6** de `.github/scripts/coherencia-contrato.sh`.

**Mientras eso no esté escrito, la próxima implementación puede repetir el error** — y `025` no lo va
a impedir, porque hace bien en no ser un manual.

**El segundo:** con las cuentas separadas, `/orquestar` prescribe el **review de PR** como canal de
firma. El cambio ya ocurrió por contrato —`009` fijó el principio, «metadato-de-autor que GitHub
liga», no una lista de canales— pero **nunca se ejercitó en corrida real**: es capacidad demostrada,
no probada. Y `references/perimetro-de-confianza.md` §6 enuncia la regla (`:170`) hablando **solo del
comentario**, aunque su detalle técnico (`:184`) ya contemple `review.user`. Un lector que busque
cómo se autentica un **review aprobado** encuentra la regla escrita para otro canal.

🛠️ **Método.** Escritura de referencia + ejercicio real. Cero decisión nueva: `009` y `025` ya
decidieron.
1. Documentar el mecanismo de credenciales **por operación** donde vive el detalle operativo del
   perímetro, con el porqué: un cambio de identidad del agente **no debe alterar estado persistente
   de la herramienta del humano**.
2. Reformular la regla de §6 para que cubra **ambos** canales —review aprobado y comentario— sin
   perder su filo: lo que autentica es el **autor del acto**, no el canal por el que llega.
3. **Ejercitar el canal**: el PR de esta sesión se firma con **review aprobado** del dueño, no con
   comentario. Es auto-verificante — si el canal no funciona, la sesión no cierra.

✅ **Criterios de aceptación.** — **CERRADA 2026-07-26 (PR #67)**, con un criterio **retirado**.
- [x] El mecanismo de credenciales por operación está documentado, con su porqué *(verificación: inspección — el texto muestra la forma no invasiva y dice explícitamente que `gh auth switch` es incorrecto por alterar el estado global del humano)* → `perimetro-de-confianza.md` §7
- [x] La regla de `perimetro-de-confianza.md` §6 cubre el **review aprobado** además del comentario *(verificación: inspección — la regla destacada nombra ambos y sigue anclando la autenticación al autor del acto, no al canal)* → `:170-180`
- [~] ~~El canal de **review de PR** quedó ejercitado en corrida real~~ — **RETIRADO 2026-07-26 por decisión del dueño.** No se cumplió y **dejó de ser cumplible**: su precondición era la separación de cuentas de `025`, que `decisiones/027` revirtió al descubrirse que la cuenta del agente pertenecía a otro proyecto. Sin cuentas separadas todos los PRs los abre el dueño, y **GitHub no permite aprobar el PR propio** — no hay review posible. *(El criterio no fracasó por falta de trabajo: se quedó sin objeto. Mantenerlo abierto simularía un pendiente que nadie puede tomar.)*

> **Lo que sí se ejercitó, y queda como evidencia:** la branch protection activada en S14 **bloqueó un
> merge de verdad** (`Merging is blocked · At least 1 approving review is required`). Eso probó que el
> canal **puede** volverse exigible — lo que no se probó es la firma por review, porque la cuenta que
> la hacía posible resultó ser ajena. Ambas cosas se revirtieron con `027`.
>
> **Queda pendiente de la decisión de cuenta de agente** (ver `026` y las consecuencias de `027`): si
> se elige una cuenta dedicada, el canal de review vuelve a ser posible y este criterio puede
> reabrirse como sesión propia.

📚 **Referencias.** [`references/perimetro-de-confianza.md`](references/) 🟢 · [`references/audit-tracker.md`](references/) 🟢

⛓️ **Prerrequisitos.** `decisiones/025` **FIRMADA y aplicada** (S13) — *nota: `027` revirtió su parte
de identidad concreta; el principio que S14 documentó sigue vigente.*

**Estimación: S**

---

> ### Nota de numeración: por qué el plano salta de S14 a S16
>
> **S15 — precondición de identidad** está **cerrada** (2026-07-28, encargo #73 → PR #74) y figura en
> el artefacto de estado como bloque `b15`, pero **nunca entró a este documento**. El propio artefacto
> declara por qué: *«NACIÓ FUERA DEL PLANO: es un hallazgo de corrida, no una sesión que `docs/PLAN.md`
> previera. **Incorporarla al plano la firma el dueño**»*.
>
> **No se incorpora acá**, porque hacerlo sería fabricar el requisito que el artefacto reserva a una
> firma. Se declara el hueco para que no se investigue de cero cada vez que alguien lo note — el mismo
> tratamiento que `FICHA.md` le da al hueco `017`. **S15 no es un número saltado: es una sesión real
> sin asiento en el plano**, y ese asiento es trabajo pendiente del dueño.
>
> Consecuencia contable, por `registro-de-cadena.md` §6: mientras S15 no tenga requisito acá, **los
> identificadores `S15/*` no existen en ninguna `plano_version`**, así que un encargo que los invoque
> nace como eslabón roto. Es el mismo defecto estructural que motivó la apertura de esta serie de
> mantenimiento.

---

## S16 — Coherencia del contrato: bajar `030` y poner el primer cable

🎯 **Planteamiento.** Las seis sesiones de esta serie —S10 a S15— arreglaron **el mismo defecto seis
veces**: divergencia entre documentos que declaran lo mismo. Ninguna agregó capacidad; todas se
autodescriben como «contabilidad» o «precisión, cero cambio de comportamiento». No fue mala suerte: el
estado de un ADR vive en **cuatro** lugares y **tres son copias que no se declaran copias ni apuntan a
la fuente**, con propagación 100 % manual y sin gate. Con esa estructura el drift es la salida
esperada del sistema.

El proyecto ya tenía la doctrina para juzgarlo, aplicada al proyecto que `batuta` orquesta y nunca a
`batuta` como sistema de documentos: *«un control que no puede fallar tampoco puede detectar nada, y es
peor que no tenerlo: da falsa cobertura»* (`registro-de-cadena.md:120`). Y el peaje está medido: el
`estado.json` arrastró `026` como pendiente después de que el ADR quedara FIRMADA, y **lo cazó una
corrida real, no la re-auditoría de ese mismo día, que lo miró y no lo vio**.

`decisiones/030` decidió el camino. Esta sesión lo baja a contrato y **pone el primer cable** — que es
lo único de todo el trabajo que no se resuelve escribiendo.

🛠️ **Método.** Escritura de contrato + primera superficie de verificación. Cero decisión nueva: `030`
ya decidió.

1. Declarar la jerarquía en las **tres vistas derivadas**: `FICHA.md` §10, el artefacto de estado y
   `PLAN.md` dicen que lo son, apuntan a `decisiones/` y fijan la precedencia («ante divergencia manda
   `decisiones/`»). Es el patrón «el snapshot orienta, GitHub decide», un nivel más arriba.
2. **Reducir `FICHA.md` §10 a punteros.** Hoy son ~250 líneas de prosa que duplican el cuerpo de cada
   ADR: es la fuente del drift, no su síntoma. El porqué se lee en el ADR, que es donde ya está.
3. Escribir el alcance precisado de `006` **donde alguien lo buscaría** —junto a la deuda de
   verificación estructural que hoy lo invoca como impedimento—, con lo que **no** habilita.
4. Poner el cable: los tres chequeos del alcance decidido de `030`, corriendo **sin que nadie los
   pida** en cada PR. Con dos cuidados que se midieron al prototiparlo: **frenar distinto de fallar**
   (precondición ausente → salida explícita, jamás silencio) y **anclar en la línea del sello**, no en
   la palabra — un `grep PENDIENTE` a lo bruto marca `026` como pendiente por su línea 120, que es
   prosa.
5. Cerrar los **dos casos de drift vivos** como aplicación de la regla, no como items sueltos: el label
   `externo` (`batuta.md:632`/`:637`/`:658`/`:729` contra `:604-616`, donde `:658` frena por hacer lo
   que `:613` ordena) y el título de `FICHA.md` §4, que dice «Las 6 fases de una corrida» describiendo
   **v1** en la precondición que `batuta` lee en cada corrida.
6. **Gotcha:** la tentación acá es escribir un chequeo grande. Un cable mal puesto es peor que el
   cartel, porque el cartel no promete nada. Tres chequeos, y cada uno visto fallar.

✅ **Criterios de aceptación.** — **7 de 7 cumplidos.**
Evidencia completa en [`audits/s16-cable-2026-07-30.md`](audits/s16-cable-2026-07-30.md).
- [x] Las tres vistas derivadas se declaran como tales y fijan la precedencia *(verificación: inspección — `FICHA.md` §10 y esta tabla de Resumen remiten a `decisiones/` y declaran qué manda; el artefacto de estado queda declarado en `references/audit-tracker.md` **con hueco-a-construir**: su schema es de `audit-tracker`, y agregarle un campo sería cambiar el contrato de un delegado)* → `FICHA.md` §10 · `PLAN.md` §Resumen · `references/audit-tracker.md`
- [x] `FICHA.md` §10 quedó reducida a punteros *(verificación: inspección — 28 filas con ADR, título, sello, fecha y path; los 24 párrafos de prosa duplicada salieron. Se detectaron y cerraron dos drifts al convertir: `019`/`020`/`021` no tenían entrada propia —vivían dentro de la de `015`— y `CERRADA` es un tercer sello legítimo que el binario FIRMADA/PENDIENTE no contemplaba)*
- [x] El alcance precisado de `006` está escrito donde hoy se lo invoca como impedimento, con lo que NO habilita *(verificación: inspección — `PLAN.md:9` y `decisiones/006` §«Alcance precisado». Distingue sustrato del producto de infraestructura de verificación, invoca el precedente del artefacto de estado —ya no es markdown—, y subraya que los criterios de sesión siguen verificándose con corridas sembradas)* ⚠️ **deja una tensión declarada sin resolver, para firma del dueño**: la consecuencia 3 de `006` pide un ADR que lo **supere** para agregar código, y `030` declara `superaA: —`
- [x] El chequeo corre **sin que nadie lo pida** *(verificación: corrida real en el PR de esta sesión — [run 30525019373](https://github.com/hifede1/claude-batuta/actions/runs/30525019373), `conclusion: success`, los DOS pasos en verde: el chequeo y la batería. **Primer workflow del proyecto**; tardó ~60 s en registrarse porque `.github/workflows/` no existía)*
- [x] **El chequeo FALLA cuando debe** *(verificación: `bateria-sembrada.sh` — 5 escenarios de drift plantados, 5 en rojo con el ADR señalado: artefacto que lista un firmado como pendiente · ADR que pasa a PENDIENTE sin que el artefacto lo sepa · ADR sin sello · §10 declarando otro estado · ADR huérfano de §10. **La batería corre en cada PR**, así la garantía es vigente y no histórica)*
- [x] El chequeo **frena distinto de fallar** *(verificación: 2 escenarios sembrados — sin artefacto de estado y con §10 sin filas evaluables → `exit 2` con el motivo dicho, jamás verde ni silencio. Más un noveno escenario que prueba que **no** hay falso positivo: `PENDIENTE` mencionado en la prosa de un ADR sigue en verde. 9/9)*
- [x] Los dos casos de drift vivos quedaron cerrados *(verificación: inspección — `batuta.md` ya no tiene ninguna mención de «label `externo` faltante»; las líneas `:632`, `:637`, `:658` y `:729` se propagaron a la decisión de la mesa chica, y el autochequeo de `:658` dejó de frenar por hacer lo que `:613` ordena. `FICHA.md` §4 pasa a «4 activas en v0, 6 en v1» con la aclaración de qué corre hoy)*

📚 **Referencias.** — *(ninguna nueva: se lee contra `decisiones/030`, `registro-de-cadena.md` §6 y la deuda de verificación estructural del artefacto de estado)*

⛓️ **Prerrequisitos.** `decisiones/030` **FIRMADA** — sin el ADR ratificado no hay regla que bajar, y
la precisión de `006` del criterio 3 **es parte de esa firma**, no de esta sesión.

**Estimación: M** — los criterios 1, 2, 3 y 7 son escritura de contrato; el 4, 5 y 6 son la primera
superficie de CI del proyecto y su corrida sembrada. El chequeo ya está prototipado y medido
(2026-07-30), así que lo que falta es instalarlo y verificarlo, no diseñarlo.

---

## S17 — La frescura de las vistas: cerrar el límite que S16 se declaró

🎯 **Planteamiento.** S16 puso el primer cable y **declaró su propio límite en el mismo acto**: los tres
chequeos cubren sellos de ADR y filas de `FICHA.md` §10, y **no** miran el artefacto de estado — ni sus
bloques, ni sus deudas, ni `last_audit`. No fue olvido: `decisiones/030` fija ese alcance como *mínimo
deliberado*, y el artefacto escribió la salida de puño y letra: *«Si se quiere cerrar, entra como cuarto
chequeo con su propio escenario sembrado.»*

**El límite ya se cobró, y se puede medir hoy.** El artefacto declara `last_audit: 2026-07-30`. Desde
entonces se firmaron **dos ADRs** —`031` el 31-07 y `032` el 01-08— y se mergearon cuatro PRs (#82, #84,
#85, #87). El cable siguió **VERDE**, correctamente, porque eso está fuera de su alcance. Y con el
artefacto atrasado, tres entradas de su `deuda` pasaron a ser **falsas**: siguen diciendo «ADR `026`
PENDIENTE» (FIRMADA desde el 26-07), «la decisión del 28-07 no tiene ADR» (es `029`, firmada ese mismo
día) y «la causa no quedó determinada» del switch de cuenta (determinada el 01-08: otras sesiones de
Claude Code ejecutando `gh auth switch`).

**Y al abrir esta sesión apareció el segundo caso, peor que el primero.** La cabecera de `FICHA.md`
declara `Firmado: 2026-07-30 (2)` y su historial de Procedencia se corta en el acto 12, con `031` y
`032` ya firmadas — **con su fila en §10**, por eso el chequeo 3 está en verde y hace bien. Esa cabecera
es `plano_version`, **lo que `batuta` lee al arrancar cada corrida** (`registro-de-cadena.md` §3). Con
ella atrasada, la causal 7 de §6 —«el plano cambió de versión durante la corrida»— vuelve a ser
inauditable: el agujero exacto que `023` vino a tapar, reabierto por el mismo mecanismo. **Dos vistas,
la misma enfermedad: envejecen solas porque nada las coteja contra la fuente.**

**Esta sesión NO es contabilidad, y la distinción es el punto.** Actualizar las dos vistas a mano sería
contabilidad — y por `:576` de este documento, sería declarar que S16 falló. Lo que se instala es el
**mecanismo que vuelve imposible ese atraso en silencio**. La corrección del contenido llega después, y
llega *porque el cable la obliga*.

🛠️ **Método.** Dos chequeos más sobre el cable existente, con sus escenarios sembrados. Cero decisión
nueva: el precedente de ampliar la superficie de verificación sin ADR lo fijó el PR #82, que agregó
`frontera.sh` —un cable entero, no un chequeo— bajo el alcance ya precisado de `006` por `030`.

**Un cálculo, dos vistas.** La fecha de sello más reciente de `docs/decisiones/` es el reloj de la
fuente; las dos vistas que envejecen solas se comparan contra él. El cálculo caro se hace una vez.

1. **Chequeo 4 — `last_audit` del artefacto contra el reloj de la fuente.** Si algún ADR quedó firmado
   **después** de la última auditoría, la vista está atrasada y el cable lo dice.
2. **Chequeo 5 — la estampa de `FICHA.md` contra el mismo reloj.** Descubierto al abrir esta sesión: la
   cabecera declara `Firmado: 2026-07-30 (2)` y el historial de Procedencia se corta en el acto 12,
   mientras `031` (31-07) y `032` (01-08) ya están firmadas y **con su fila en §10** — por eso el
   chequeo 3 está en verde, correctamente. **Este es el más grave de los dos**: la estampa es
   `plano_version`, lo que `batuta` **lee al arrancar cada corrida** (`registro-de-cadena.md` §3). Con
   ella atrasada, la causal 7 de §6 —«el plano cambió de versión durante la corrida»— vuelve a ser
   inauditable, que es exactamente el agujero que `023` vino a tapar.
3. **Las anclas, validadas antes de escribir el código** *(la falla que `030` §3 documenta es anclar
   donde aparece la palabra en vez de donde vive la verdad)*: `^> Firmado:` aparece **una sola vez** en
   `FICHA.md`, y el reloj se calcula tomando **todas** las fechas de la línea `^**Estado:**` de cada ADR
   y quedándose con la máxima — así una **re-ratificación** cuenta como cambio de la fuente, que es lo
   que es. Ambos chequeos leen líneas estructuradas por `024`; ninguno toca prosa.
4. **Sus escenarios sembrados**, en las dos direcciones y por cada vista: atrasada → ROJO; al día →
   VERDE, incluido el borde de la **misma fecha**, que es el caso normal el día que se firma y se
   audita. Más el freno: campo ausente, vacío o con formato no-`YYYY-MM-DD` → **exit 2**, jamás verde.
5. **Corregir el contenido de las dos vistas** —los cuatro PRs sin asentar, las tres deudas falsas, y
   los actos 13 y 14 del historial de Procedencia— como *consecuencia* del rojo, no como el trabajo en
   sí. El orden importa: si se corrige primero, los chequeos nacen verdes y **nunca se los ve fallar**,
   que es justo lo que `030` prohíbe.
4. **Gotcha — lo que este chequeo NO hace, declarado.** No verifica el **contenido** de `deuda` ni la
   completitud de `bloques`. Se evaluaron los dos y se descartaron con evidencia:
   - *«todo bloque cerrado cita su PR»*: **`b01` no cita PR y es legítimo** —S01 cerró verificando el
     install en perfil limpio, no con un PR de este repo—, así que daría ROJO sobre historia correcta.
     Y exige un patrón léxico sobre prosa, el pecado que `030` §3 documenta.
   - *«la deuda no cita ADRs ya firmados»*: detecta el drift de hoy, pero una entrada que **narre
     historia** —«en ese momento `029` estaba PENDIENTE»— da falso positivo. Es el mismo `grep
     PENDIENTE` a lo bruto que marcó al `026` por su línea 120, que es prosa.

   **La frescura es mecanizable; el contenido es juicio.** El cable fuerza la re-auditoría, y es la
   re-auditoría —humana— la que corrige el contenido. Pedirle a la máquina el juicio es lo que este
   taller ya vio caerse tres veces.

✅ **Criterios de aceptación.** — **7 de 7 cumplidos.**
Evidencia completa en [`audits/s17-frescura-2026-08-01.md`](audits/s17-frescura-2026-08-01.md).
- [x] Los chequeos 4 y 5 existen y **anclan donde vive la verdad**, no en prosa *(verificación:
      inspección de `.github/scripts/coherencia-contrato.sh` — el reloj sale de las fechas de
      `^**Estado:**`, en la misma pasada que ya construye `sello_de`; la estampa sale de `^> Firmado:`,
      que aparece una sola vez. Sin `git`, sin `fetch-depth`, sin dependencia nueva)*
- [x] **Los dos FALLAN cuando deben** *(verificación: corridas sembradas — `last_audit` anterior al
      reloj → `exit 1`; estampa anterior al reloj → `exit 1`. Cada uno nombrando el ADR que lo delata y
      las dos fechas)*
- [x] **Los dos FRENAN distinto de fallar** *(verificación: corridas sembradas — campo ausente, vacío o
      con formato no-`YYYY-MM-DD` → `exit 2` con el motivo dicho, jamás verde ni silencio)*
- [x] **Ninguno da falso positivo** *(verificación: corridas sembradas — vista igual o posterior al
      reloj → VERDE, incluido el borde de la MISMA fecha, que es el caso normal el día que se firma y
      se audita, y el de la estampa **con sufijo `(N)`**, que no debe romper el parseo)*
- [x] La batería corre **dentro del workflow**, como las anteriores *(verificación: la corrida real del
      PR de esta sesión, con los dos pasos en verde)*
- [x] **Se los vio fallar contra el repo real antes de corregir nada** *(verificación: la salida de los
      chequeos 4 y 5 en ROJO sobre el `main` del 01-08 —`last_audit: 2026-07-30`, estampa
      `2026-07-30 (2)`, reloj `2026-08-01`— transcripta en la evidencia. Sin esto son intenciones con
      formato de comando: `030` §3)*
- [x] Las dos vistas quedan al día **después** del rojo *(verificación: `last_audit`, el bloque de la
      jornada del 31-07/01-08 y las tres deudas falsas en el artefacto; la estampa y los actos 13 y 14
      del historial de Procedencia en `FICHA.md`. Con el cable en verde al cerrar)*

📚 **Referencias.** — *(ninguna nueva: se lee contra `decisiones/030` §«Alcance decidido», el límite
declarado en el artefacto de estado y el precedente del PR #82)*

⛓️ **Prerrequisitos.** Ninguno pendiente de firma. `030` **FIRMADA** desde el 30-07 y el cable instalado
por S16; esta sesión lo extiende dentro del alcance que `030` ya precisó.

**Estimación: S** — un chequeo sobre infraestructura que ya existe, más sus escenarios. El trabajo real
no es el script: es **no** corregir el artefacto antes de ver el rojo.

---

## S18 — La frontera de los delegados: medir los tres `BLOQUEA` y reasentarlos

🎯 **Planteamiento.** `ALCANCE.md` declara los **tres motivos por los que `batuta` BLOQUEA**, los tres
«verificado 2026-07-19». Al 2026-08-01 los tres son **factualmente falsos**: `verificador` y `publicador`
—declarados «cero código»— tienen 121 KB y 185 KB con su comando construido, y `cartera` —declarada «no
está en el marketplace, su repo remoto no existe, no está instalado»— **está en el marketplace y está
instalada**. Los tres se construyeron entre el 23 y el 24 de julio; la tabla no se enteró en trece días.

**Y no es un atraso de documentación.** Los tres `BLOQUEA` **son el mecanismo central del producto**
—*«bloqueá, nunca reimplementes»*—, así que un `BLOQUEA` apoyado en un estado falso hace que `batuta`
frene ante trabajo que **ya tiene ejecutor legítimo**. Es el drift de mayor consecuencia funcional del
proyecto hasta hoy: los otros deformaban lo que el plano *dice*; éste deforma lo que la herramienta
*hace*.

**Es la enfermedad de S17, un nivel más arriba.** La diferencia no es el tipo de drift sino **contra qué
se mide**: S17 comparó vistas contra `docs/decisiones/`, dentro del repo; esto exige medir contra **el
disco y GitHub**, afuera. Ningún cable lo cubre — `coherencia` mira ADRs y `FICHA` §10, `frontera` mira
`references/` y `plugin.json`.

🛠️ **Método.** Medición contra fuentes externas + reasentamiento del contrato. Cero decisión nueva.

1. **Medir cada delegado contra el criterio que el propio ALCANCE fija: «terminado», no «existe».**
   Repo, plugin, comandos, artefacto de estado, deuda declarada y evidencia de corrida real.
2. **Emitir el veredicto por delegado** —cae, se reduce o sobrevive— **con su evidencia al lado**, y con
   la fecha de verificación fresca. Una marca sin fecha miente sola: es la regla que este mismo documento
   ya aplica a la tabla de cimientos.
3. **Distinguir el motivo que sobrevive del que se cayó.** `cartera` sigue bloqueada, pero por **`007`,
   corte de versiones** —es v2— y no por delegado faltante. Un bloqueo correcto por la razón equivocada
   es indistinguible de uno incorrecto la próxima vez que alguien lo lea.
4. **Gotcha:** la tentación es declarar «los bloqueos cayeron» y seguir. Lo medible es que **las
   afirmaciones del plano eran falsas**; que los delegados *sirvan* para todo lo que `batuta` necesite es
   otra cosa, y «terminado» lo declara cada delegado **en su propio artefacto** — es su palabra,
   corroborada por corridas reales, no una auditoría que `batuta` les haya hecho.

✅ **Criterios de aceptación.** — **5 de 5 cumplidos.**
Evidencia completa en [`audits/s18-delegados-2026-08-01.md`](audits/s18-delegados-2026-08-01.md).
- [x] Los tres delegados medidos contra fuentes externas *(verificación: API de GitHub — repo, tamaño,
      `plugins/<n>/commands/`, artefacto de estado y deuda; más `installed_plugins.json` local y el
      `marketplace.json` de `fede-tools`)*
- [x] Cada `BLOQUEA` tiene veredicto **con evidencia y fecha fresca** *(verificación: inspección de
      `ALCANCE.md` §«v0 NO hace» — dos ✅ CAYÓ, uno ⚠️ SOBREVIVE, ninguno sin fecha)*
- [x] El bloqueo que sobrevive declara **el motivo real** *(verificación: `cartera` bloquea por `007`
      —es v2—, y queda escrito que las tres razones anteriores eran falsas)*
- [x] La falsedad sobre `gitleaks` queda corregida *(verificación: `publicar.md` lo menciona **7 veces**;
      la nota de `ALCANCE` decía «no hay capacidad de ejecutarla» y era falsa desde el 2026-07-24)*
- [x] Lo que NO se hizo queda declarado *(verificación: inspección — no se cablea, porque exigiría **red
      en CI** y todos los cables corren offline por diseño: eso es decisión, no trabajo, y va a ADR
      propio. Y **no se instalan** `verificador` ni `publicador`: por `029` el estado del entorno es del
      humano)*

📚 **Referencias.** — *(ninguna nueva)*

⛓️ **Prerrequisitos.** Ninguno. La medición es lectura; el cambio de contrato lo ratifica el dueño con
el merge (`018`).

**Estimación: S** — la medición es rápida contra la API. El trabajo real es **no** declarar caídos los
tres bloqueos de un saque: dos cayeron, uno se redujo y el tercero sobrevive por otro motivo.

---

## S19 — Evidencia limpia sobre la identidad del agente: el plano prescribe un mecanismo que su propia referencia midió fallando

🎯 **Planteamiento.** `docs/PLAN.md:417-421` —dentro de S14, o sea **plano firmado**— presenta
`GH_TOKEN=$(gh auth token --user <cuenta-agente>) gh <comando>` como **«el mecanismo correcto
verificado»**. `references/perimetro-de-confianza.md` §7:268 mide **ese mismo mecanismo** y le pone
❌ en escritura: *«la escritura deja la cuenta activa en la del agente»*. **El plano le está diciendo
al próximo implementador que use algo que la referencia hermana midió roto.**

**Y la refutación tampoco es confiable.** El propio artefacto declara la tabla de §7:265-269
**CONFUNDIDA**: sus tres filas se midieron **mientras otra sesión de Claude Code corría `gh auth
switch` cada ~30 s**, así que ninguna está medida limpiamente. No hay un lado correcto y otro
equivocado: **hay dos afirmaciones sobre el mismo hecho y ninguna se sostiene.**

**Por qué es la de mayor consecuencia de lo que queda abierto.** Es la clase de S18, no la de S16:
los drifts de vista deforman lo que el plano *dice*; éste deforma **lo que el operador hace**. Y ya
se cobró una vez — dos comandos completos del taller corrieron con la cuenta de otro proyecto, y
**se detectó por accidente**, porque un comando devolvió otro login. Es además el sustrato de
`009`/`025`/`028`/`029`: todo el modelo de firma se apoya en poder separar identidades.

**Ningún cable puede cazarlo hoy**, y no es olvido: el alcance de `030` son los sellos de ADR y
`FICHA` §10; `frontera` mira `plugins/` y el catálogo. **`references/` no lo mira nadie** — es la
tercera superficie de la misma enfermedad, después de las vistas (S17) y del mundo (S18).

🛠️ **Método.** Medición bajo aislamiento probado + reasentamiento. Cero decisión nueva salvo la que
`033` reserva explícitamente al dueño.

1. **Probar el aislamiento antes de medir nada.** El dueño cierra las demás sesiones de Claude Code
   y se comprueba con `ps` que ninguna otra corre, **con hora, en el registro**. Sin esa prueba la
   medición nace con el mismo defecto que la que viene a reemplazar.
2. **Re-medir las tres filas de §7:265-269 una por una**, con el criterio que la propia tabla ya
   fija —*¿la cuenta activa del dueño sigue siendo la suya después de una **escritura**?*— cubriendo
   `gh auth switch`, `GH_TOKEN` y `GH_CONFIG_DIR`.
3. **Cerrar la salvedad de `GH_CONFIG_DIR`**: el único comando que quedó sin reproducir aislado es
   `gh pr create`. Se mide, o se declara no medible **con su motivo**.
4. **Reasentar §7** con las mediciones frescas y su fecha, y **sacar la prescripción del plano**:
   `PLAN.md:417-421` deja de recomendar un mecanismo y **apunta a §7**, que es donde vive la
   medición. Una prescripción en el plano y una medición en la referencia son dos fuentes del mismo
   dato — es el diagnóstico de `030` aplicado a `references/`.
5. **Partir el ADR `033`** como pidió el veredicto de su propio pase adversarial, que lo declaró
   **no firmable como estaba**: (a) el **mecanismo**, complemento firmable de `029`; (b) **sacar el
   FRENA**, que supera a `029:67-70` y es **elección humana registrada aparte**. Se propone (a); (b)
   se lleva a firma sin recomendación del agente.
6. **Gotcha — el que se come esta sesión si se descuida.** La tentación es re-medir y **declarar
   ganador**. Si la contaminación de `gh pr create` no se reproduce, eso **no prueba que aísle**:
   prueba que no se reprodujo. La salvedad se cierra cuando haya una **explicación**, no cuando
   falte una repetición. Es la misma disciplina con que S18 se negó a declarar caídos los tres
   `BLOQUEA` de un saque.

✅ **Criterios de aceptación.** — **CERRADA 2026-08-04 (PR #111 + PR de cierre)**, con **dos criterios
retirados**.
- [~] ~~El aislamiento está **probado, no supuesto**~~ — **RETIRADO 2026-08-04 por decisión del dueño.** Se quedó **sin objeto**: su condición está cuantificada *«durante la ventana de medición»* y, retirado el criterio 2, **no va a haber ventana**. Un criterio que sólo puede evaluarse dentro de algo que no va a ocurrir no es un pendiente: es una casilla que nadie puede tomar. *(El pase adversarial de la corrida ya había tumbado darlo por cumplido con un `ps` previo: eso era verdad vacua, no prueba.)*
- [~] ~~Las tres filas de §7 llevan **medición fresca con fecha y el comando exacto** que la produjo~~ — **RETIRADO 2026-08-04 por decisión del dueño.** No se cumplió y **dejó de ser cumplible**: re-medir exige una segunda identidad —`gh auth switch --user <agente>` y `GH_TOKEN=$(gh auth token --user <agente>)` **se quedan sin argumento**— y `decisiones/035` (FIRMADA 2026-08-04) decidió que el agente opera con la credencial del dueño, sin cuenta dedicada. **La tabla de §7 queda declarada NO MEDIBLE con su motivo**, que es lo que el método de esta sesión autoriza como alternativa a medir (paso 3: *«se mide, o se declara no medible con su motivo»*). *(Mismo mecanismo que el criterio retirado de S14: no fracasó por falta de trabajo, se quedó sin objeto. `034` es la constancia de que la cuenta dedicada se evaluó a fondo; `035`, de qué la detuvo.)*
- [x] La salvedad de `gh pr create` queda **cerrada o re-declarada con su motivo**, jamás borrada en silencio *(verificación: inspección de §7 — el párrafo existe y dice qué pasó)* → **cumplido por la rama «re-declarada»** (PR #111): distingue las **dos** «causa no determinada» de §7 y precisa que lo determinado el 2026-08-01 es **la otra**. **La salvedad sigue ABIERTA** — y eso es correcto: cerrarla exige una explicación, no una repetición faltante.
- [x] `PLAN.md:417-421` **ya no prescribe un mecanismo**: apunta a §7 *(verificación: inspección — cero bloque de código con el mecanismo dentro del plano, y el puntero presente)* → **cumplido** (PR #111), con la obligación que agregó el pase adversarial: el puntero **declara que la tabla está CONFUNDIDA**.
- [x] `033` está **partido**, y su parte (a) firmada o PENDIENTE con su motivo escrito *(verificación: `docs/decisiones/033-*.md` existe con sello de `024`; el FRENA queda fuera de su alcance, declarado)* → **cumplido** (PR #111): nació ⏳ PENDIENTE, sin `Procedencia`, con el FRENA declarado fuera.
- [x] La contradicción queda **cableada o declarada NO cableable con su motivo** *(verificación: o hay chequeo con su escenario sembrado, o hay hueco escrito)* → **cumplido y CABLEADA** (PR #111): **chequeo 6** de `coherencia-contrato.sh`, **visto FALLAR** contra `9edd971` antes de corregir. Límite declarado en el propio script: no caza prescripciones *inline*. **Deuda de verificación abierta**: el chequeo 6 **no tiene escenario sembrado** en `bateria-sembrada.sh`.

> **Balance honesto de S19: 4 de 6.** Lo que se cerró es la **contradicción de fuentes** —el plano dejó
> de prescribir lo que la referencia medía roto, y ahora hay un cable que lo vigila—. Lo que **no** se
> cerró es el **hecho**: cuál mecanismo aísla de verdad sigue sin saberse, y ahora sin camino para
> averiguarlo. La sesión arregló el contrato, no el mundo. Decirlo así es la única forma de que la
> próxima lectura no confunda una cosa con la otra.

📚 **Referencias.** [`references/perimetro-de-confianza.md`](references/) 🟢 **territorio volátil** ·
[`references/audit-tracker.md`](references/) 🟢

⛓️ **Prerrequisitos.** **Aislamiento verificado — acto del dueño**, no del agente: exige cerrar las
otras sesiones de Claude Code. Es prerrequisito duro: sin él la medición repite el defecto que viene
a corregir. · El veredicto que declaró `033` no firmable ya está registrado (`b17`).

**Estimación: M** — la medición es rápida; lo que pesa es **no** declarar ganador con una repetición
faltante, y que la parte (b) de `033` no la decide el agente.

> **Lo que S19 NO hace, declarado.** No cablea el tracker HTML ni la estampa de `ALCANCE.md` —las dos
> siguen sin control y quedan como candidatas a **S20**—, no incorpora al plano los tramos sin asiento
> (S15, la jornada `b17` y la de hoy: eso lo firma el dueño), y no toca el chequeo 5, que vigila
> atraso y no justificación. Enumerarlo acá es lo único que impide que se lean como olvidos.

---

## Resumen

> ⚠️ **Esta tabla es una VISTA DERIVADA** (`decisiones/030`). La columna *Bloqueada por decisión*
> refleja un estado cuya **fuente es `docs/decisiones/`**; ante divergencia **manda la fuente, no esta
> tabla**. Lo mismo vale para el estado de cada sesión: la obra la pinta la re-auditoría de
> `audit-tracker`, no este documento.

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
| **S10** | **Contrato de persistencia del registro** *(mantenimiento)* ✅ cerrada 2026-07-25 | **S** | — |
| **S11** | **Contabilidad de la ficha** *(mantenimiento)* ✅ cerrada 2026-07-25 | **S** | — |
| **S12** | **Versionado del plano + drift de `011`** *(mantenimiento)* ✅ cerrada 2026-07-26 | **S** | `023` versionado |
| **S13** | **Cerrar el contrato de firma** *(mantenimiento)* ✅ cerrada 2026-07-26 | **M** | `024` sello · `025` credenciales |
| **S14** | **Mecanismo de credenciales** *(mantenimiento)* ✅ cerrada 2026-07-26 · 1 criterio retirado (`027`) | **S** | — *(`025` ya aplicada)* |
| *(S15)* | *Precondición de identidad — **cerrada 2026-07-28 y sin asiento acá**: nació fuera del plano. Ver la nota de numeración sobre S14* | *—* | *— (su incorporación al plano la firma el dueño)* |
| **S16** | **Coherencia del contrato: bajar `030` y poner el primer cable** *(mantenimiento)* | **M** | `030` coherencia del contrato |
| **S17** | **La frescura de las vistas: el cuarto y quinto chequeo** *(mantenimiento)* | **S** | — *(`030` ya firmada; extiende su alcance precisado)* |
| **S18** | **La frontera de los delegados: medir los tres `BLOQUEA` y reasentarlos** *(mantenimiento)* | **S** | — *(el motivo que sobrevive es `007`, corte de versiones)* |
| **S19** | **Evidencia limpia sobre la identidad del agente** *(mantenimiento)* ✅ **cerrada 2026-08-04 · 4/6, dos criterios retirados** (`035`) | **M** | `033` **partido**, su parte (a) ⏳ PENDIENTE · la (b) —sacar el FRENA— sigue siendo elección del dueño · §7 **NO MEDIBLE** |

**7 de las 9 sesiones de v0 estaban bloqueadas por una decisión pendiente.** No es un defecto del plan: es el plan diciéndote la verdad sobre dónde falta firma.

**Las 9 de v0 están cerradas** (2026-07-22). De **S10 en adelante**, la serie es de **mantenimiento**: misma numeración, mismas reglas, y —lo que importa— **requisito propio**, para que el trabajo posterior a v0 tenga asiento y sea delegable.

**Y de S10 a S15, las seis arreglaron el mismo defecto.** Ninguna agregó capacidad: todas corrigieron divergencia entre documentos que declaran lo mismo. Eso no es una racha de descuidos, es una propiedad de la estructura — y **S16 es la primera de la serie que ataca la causa en vez del síntoma** (`decisiones/030`). Si al cerrarla aparece una S17 de contabilidad, la que falló es S16.

**S17 apareció, y no es de contabilidad — pero el enunciado de arriba se responde, no se esquiva.** El artefacto de estado **sí** quedó atrasado después de S16: `last_audit` en 30-07 con dos ADRs firmados después. Ahora bien, la prueba de si S16 falló no es *«¿apareció drift?»* sino *«¿apareció drift DENTRO de lo que S16 se comprometió a cubrir?»*. Y no: `030` fijó el alcance del cable en sellos de ADR y `FICHA.md` §10, S16 **declaró ese límite por escrito el día que cerró**, y en su terreno el cable no falló ni una vez. El drift cayó exactamente donde el alcance decía que iba a caer.

Por eso S17 **no actualiza el artefacto** —eso sería la contabilidad que `:576` condena— sino que **instala el chequeo que vuelve imposible el atraso en silencio**, y corrige el contenido después, forzada por el rojo. La diferencia entre las dos S17 posibles no es de tamaño: es que una deja el mismo agujero abierto para la próxima jornada y la otra lo cierra. **Un límite declarado y luego cableado es el ciclo funcionando; un límite declarado y luego olvidado es el cartel de siempre.**

# Ficha de diseño: batuta

> **Estado: VIGENTE**
> Firmado: 2026-08-04 (6) por Fede
> *Procedencia de la firma (`decisiones/018`) — historial consolidado de esta estampa. En **todos** los
> actos la ratificación es **el merge del PR por el dueño**, autenticado por `merged_by` == dueño
> anclado (`009`) — con la salvedad que `025` vino a cerrar: hasta su aplicación (acto 6) el agente
> compartía esa credencial, así que los actos 1-6 son verdaderos con **prueba débil**, tratables como
> no concluyentes y nunca reescribibles (`018`, y `registro-de-cadena.md` §6 al cierre de los salvos):*
> 1. ***2026-07-24 · PR #43** (mesa chica) — la cabecera decía «En diseño» cuando la obra v0 estaba
>    COMPLETA y cada decisión del §10 ya estaba firmada con su Procedencia. La estampa reconcilió la
>    cabecera con una realidad ya firmada pieza por pieza.*
> 2. ***2026-07-25 · PR #47** — re-estampa de versión por cambio del plano: se incorpora la serie de
>    **mantenimiento post-v0** (S10) y `registro-de-cadena.md` §6 suma el **tercer salvo** de
>    composición del asiento (`decisiones/022`). Como `011` fija que la fecha de firma ES la versión,
>    un plano modificado no puede conservar la versión anterior. Pedido por Fede en sesión
>    interactiva del 2026-07-24, tras el hallazgo D10 de la corrida `2026-07-24-arreglar-path-de-corridas`.*
> 3. ***2026-07-25 · PR #52** — se abre **S11** (contabilidad de la ficha) y se **consolida esta
>    Procedencia**, que el propio PR #47 había dejado duplicada: dos bloques consecutivos sin decir
>    cuál correspondía a la firma vigente. La consolidación se hace **en el mismo acto** que la
>    re-estampa que `011` exige — hacerla después habría agregado un tercer bloque encima de los dos
>    que S11 viene a arreglar.*
> 4. ***2026-07-25 · PR #54** — S11 ejecutada: la §10 deja de listar `015` como firmada y pendiente a
>    la vez, y se declara el hueco `017`. La cabecera **no se tocó** en ese PR, por diseño.*
> 5. ***2026-07-26 · PR #56** — se propone `decisiones/023` (versionado del plano con sufijo
>    incremental), se abre **S12** y se re-estampa la versión por cambio del plano. Fede eligió el
>    sufijo incremental entre cuatro opciones con tradeoffs, en sesión interactiva del 2026-07-26.*
>
> 6. ***2026-07-26 (2) · PR #61** — se firman `decisiones/024` (patrón único de sello) y
>    `decisiones/025` (separación de credenciales agente/dueño) y se abre **S13**, la sesión que baja
>    ambas a contrato y aplica la separación. Fede eligió cada una entre opciones con tradeoffs, en
>    sesión interactiva del 2026-07-26. **Primeros ADRs firmados bajo el patrón de `024`**: sello en
>    el PR que los propone.*
>
> 7. ***2026-07-26 (3) · PR #65** — se abre **S14**, que cierra los dos cabos que S13 dejó sueltos al
>    aplicar `025`: el **mecanismo** de credenciales (el agente lo implementó con `gh auth switch`,
>    que altera la cuenta activa global del humano — corregido en el momento, pero sin documentar) y
>    el **canal de review de PR**, que ya rige por contrato y nunca se ejercitó. **Sin ADR nuevo:**
>    `009` y `025` ya decidieron; S14 baja y ejercita.*
>
> 8. ***2026-07-26 (4) · PR #69** — se abren **dos** ADRs. **`026`** (quién ejecuta lo administrativo)
>    nace **⏳ PENDIENTE** y se lista en §10 *Pendientes* — origen: el desvío de S14, donde el agente
>    ejecutó un `PUT` administrativo con **esta misma credencial**, violando `025`, dentro de un
>    comando que presentó como diagnóstico. **Primer ADR que nace PENDIENTE bajo `024`**, que reserva
>    ese patrón para cuando la elección humana todavía no ocurrió. **`027`** nace ✅ **FIRMADA** y
>    **revierte la identidad concreta de `025`**: `estebaproject` no era una cuenta disponible para el
>    agente sino de otro proyecto, y el agente la adoptó heredándola del default de `gh` sin
>    verificarla. Lo detectó el dueño. Se conserva el principio de `025` —el agente no comparte la
>    credencial del dueño— y se retira la cuenta; elegir la nueva es decisión abierta.*
>
> 9. ***2026-07-26 (5) · PR #70** — **se retira un criterio de aceptación de S14** por decisión del
>    dueño: `S14/canal-ejercitado` no se cumplió y **dejó de ser cumplible** cuando `027` revirtió la
>    separación de cuentas — sin cuenta de agente, todos los PRs los abre el dueño y GitHub no permite
>    aprobar el propio. El criterio **no fracasó por falta de trabajo: se quedó sin objeto**. S14
>    cierra con 2 de 2. Es la primera vez que el plano **retira** un criterio en vez de cumplirlo, y
>    por eso el motivo queda escrito en el propio criterio, tachado y no borrado.*
>
> 10. ***2026-07-26 (6) · PR #72** — se **firman las dos decisiones que S14 dejó abiertas**, y en ese
>     orden porque estaban acopladas: **`028`** cierra la cuenta del agente —**no se crea una
>     dedicada; el agujero de `009` se acepta y se declara**, así que `merged_by` deja de probar quién
>     actuó— y con eso **`026`** se sella adoptando la **lista blanca acotada** (branch protection y
>     colaboradores, con compuerta individual y asiento por uso). El agente **no propuso ganador en
>     `026` hasta que la decisión dejó de ser sobre su propio poder**, y declaró el conflicto de
>     interés al recomendar. `026` sale de §10 *Pendientes*, donde había estado unas horas.*
>
> 11. ***2026-07-30 · PR #77** — se firma **`030`** (coherencia del contrato) y se abre **S16**, la
>     sesión que lo baja a contrato y pone el primer cable. Fede eligió la **opción 2 —doctrina +
>     verificación mecánica—** entre tres opciones con tradeoffs, en sesión interactiva del 2026-07-30.
>     **Primer ADR que nace de leer la serie de mantenimiento como un todo** y no de un hallazgo de
>     corrida: S10–S15 arreglaron el mismo defecto seis veces. Con la firma, **el alcance de `006` queda
>     precisado** —sustrato del producto ≠ infraestructura de verificación— y las tres vistas derivadas
>     (esta §10, el artefacto de estado y `PLAN.md`) quedan declaradas como tales.*
>
> 12. ***2026-07-30 (2) · PR #81** — se asienta **`029`** en la fuente. **No es una decisión nueva:**
>     la elección es del **2026-07-28** —Fede eligió «frenar y preguntar» entre tres opciones vía
>     `AskUserQuestion`, registrado en el comentario del issue `#73`— y quedó **ratificada y aplicada al
>     contrato** con el merge del PR `#74` ese mismo día. Lo que faltaba era su **asiento en
>     `docs/decisiones/`**, que el artefacto de estado declaraba como deuda con el número `029`
>     reservado. **Primer ADR del proyecto que se escribe DESPUÉS de que su regla ya rige** — el inverso
>     del defecto que S12 cerró, y una clase que el cable de `030` **no puede detectar**: un ADR que
>     falta no es un drift entre vistas.*
>
> 13. ***2026-07-31 · PR #85** — se firma **`031`** (protección de rama: el cable requerido sin review
>     requerido), que **supera a `027` en su punto 4** y solo ahí. Fede eligió la **opción 1** entre tres.
>     Su origen fue un desvío: ese mismo día se repuso la protección que `027` había retirado **sin
>     declararlo**, y el ADR es la decisión que le faltaba a un acto ya ejecutado — el acto no se
>     reescribe (`018`), se le da la decisión que le correspondía. **Asentado retroactivamente por S17**
>     (ver acto 15): la ratificación ocurrió el 31-07 y esta estampa no se movió, que es el drift que
>     S17 vino a cablear.*
>
> 14. ***2026-08-01 · PR #87** — se firma **`032`** (el pase adversarial viaja dentro del diff que se
>     firma), elegida entre tres opciones tras medir 17 corridas. Completa la Compuerta Cero de `002` y
>     le da consecuencia aguas abajo. **Asentado retroactivamente por S17**, igual que el acto 13.*
>
> 15. ***2026-08-01 (2) · PR de S17** — se abre **S17** y se asientan los actos 13 y 14, que habían
>     quedado sin estampa. **Este acto es la evidencia de su propia sesión:** la estampa declaraba
>     `2026-07-30 (2)` con dos ratificaciones posteriores ya firmadas y con fila en §10 —por eso el
>     chequeo 3 seguía en verde, correctamente— y **nada la cotejaba contra la fuente**. Importa más que
>     un atraso de documentación: esta cabecera es `plano_version`, lo que `batuta` **lee al arrancar
>     cada corrida** (`registro-de-cadena.md` §3), y con ella quieta la causal 7 de §6 vuelve a ser
>     inauditable — el agujero que `023` había tapado. Con S17 el atraso deja de ser posible en
>     silencio: el **chequeo 5** compara esta línea contra la fecha de sello más reciente de
>     `docs/decisiones/` en cada PR.*
>
> 16. ***2026-08-02 · PR de materialización de `#94`** — se **corrige la estampa**: S18 (PR `#92`,
>     2026-08-01) modificó el plano —re-ratificó `ALCANCE.md` y amplió `PLAN.md`— y **no incrementó
>     esta estampa**, lo que `decisiones/023` punto 4 califica de «violación del contrato, no
>     descuido de estilo». Con ella quieta, `plano_version 2026-08-01 (2)` etiquetaba **dos planos
>     distintos**: el que declaraba los tres `BLOQUEA` «verificado 2026-07-19» y el que declara dos
>     de ellos caídos. El acto **no se retro-fecha** (`018`: la procedencia nunca se reescribe): se
>     asienta con la fecha de ESTA ratificación, que es la primera del día y por eso no lleva
>     sufijo. **El chequeo 5 no lo cazó** —su reloj es la fecha de sello más reciente de
>     `docs/decisiones/` y S18 cerró sin firmar ningún ADR, así que una estampa congelada pasaba en
>     verde—; queda como hueco declarado, no cerrado acá. Detectado por la corrida
>     `2026-08-02-publicar-050-y-esqueletos-s17-s18` y firmado por el dueño en el issue `#94`
>     (rama A).*
>
> 17. ***2026-08-02 (2) · PR de materialización de `#97` y `#95`** — se define **qué significa
>     publicar en v0**, y la definición cambia el alcance: la publicación **deja de ser un acto
>     separado** —el marketplace sirve `ref: main` sin pin, así que el merge distribuye— y en
>     consecuencia **toda edición del producto es un acto de distribución**. Las dos filas entran a
>     `ALCANCE.md` §«v0 NO hace» y su cabecera se re-ratifica. **La estampa se incrementa en el mismo
>     acto**, que es la lección que el acto 16 vino a asentar: S18 cambió el plano y no la movió
>     durante trece días. Segunda ratificación del día, de ahí el sufijo `(2)` (`023`). Decisiones
>     firmadas por el dueño en `#97` (rama C) y `#95` (rama A), ambas nacidas de la corrida
>     `2026-08-02-publicar-050-y-esqueletos-s17-s18`.*
>
> 18. ***2026-08-02 (3) · PR de materialización de `#105`** — **§0 deja de enumerar el estado de los
>     delegados** y remite a `ALCANCE.md`. Es el hallazgo **N1** de la corrida
>     `2026-08-02-publicar-050-y-esqueletos-s17-s18`, y **el único que sobrevivió a todo lo que se
>     arregló ese día**: `#96` sacó la copia del PRODUCTO —publicada en `0.6.0`— y dejó viva la del
>     PLANO, que es peor, porque es la fuente que todo lo demás ratifica. Durante trece días §0
>     afirmó que `verificador`, `publicador` y `cartera` no existían; S18 midió que los tres estaban
>     terminados. Y la contradicción era **circular**: `ALCANCE.md` declara «Ratifica FICHA §0»
>     mientras su tabla dice lo contrario palabra por palabra. La cura no es corregir el enunciado
>     —eso conserva la duplicación que lo hizo derivar— sino **no tenerlo dos veces**. Tercera
>     ratificación del día, sufijo `(3)` (`023`). Firmada por el dueño en `#105` (rama B).*
>
> 19. ***2026-08-02 (4) · PR que abre S19** — se abre **S19: evidencia limpia sobre la identidad del
>     agente**. Origen: `PLAN.md:417-421` —plano firmado— prescribe
>     `GH_TOKEN=$(gh auth token …)` como «el mecanismo correcto **verificado**», y
>     `references/perimetro-de-confianza.md` §7:268 mide **ese mismo mecanismo** fallando en
>     escritura. **No hay un lado correcto:** la tabla de §7 está declarada CONFUNDIDA, porque sus
>     tres filas se midieron mientras otra sesión corría `gh auth switch` cada ~30 s. Es la clase de
>     S18 y no la de S16 —deforma **lo que el operador hace**, no lo que el plano dice— y es la
>     **tercera superficie** de la misma enfermedad: después de las vistas (S17) y del mundo (S18),
>     `references/`, que no mira ningún cable. **Sin ADR nuevo en este acto:** `033` existe como
>     veredicto que lo declara no firmable, y partirlo es método de S19, no de esta estampa. Cuarta
>     ratificación del día, sufijo `(4)` (`023`). **La ratificación es el merge de este PR por el
>     dueño** (`018`).*
>
> 20. ***2026-08-03 · PR de S19, horizonte H1** — se abre **`033`(a) ⏳ PENDIENTE** (el mecanismo,
>     complemento firmable de `029`) y se lista en §10 *Pendientes*. **Esto SUPERA al «sin ADR nuevo
>     en este acto» del acto 19**, que era cierto para ese acto y quedó obsoleto acá: partir `033` era
>     método de S19 y S19 lo ejecutó. La parte **(b)** —sacar el FRENA de `029:67-70`— **NO se propone
>     y queda reservada al dueño** (`PLAN.md:756-758`, sin recomendación del agente). En el mismo
>     acto, `PLAN.md:417-421` **deja de prescribir** el mecanismo y apunta a `perimetro` §7
>     declarando que su tabla sigue **CONFUNDIDA**, y nace el **chequeo 6** de
>     `coherencia-contrato.sh`, que vigila que ningún documento fuera de `references/` vuelva a
>     materializarlo — **se lo vio FALLAR contra `9edd971` antes de corregir nada**. Primera
>     ratificación del día → **sin sufijo** (`023`). **La ratificación es el merge de este PR por el
>     dueño** (`018`). Autorizado por la firma de `#109`; encargo `#110`.*
>
> 21. ***2026-08-04 · PR de `034`** — se firma **`034`: cuenta de agente dedicada**, que **supera a
>     `028` COMPLETO**, repone `025` y cierra el punto 3 de `027`. El agujero de `009` **se cierra en
>     vez de aceptarse**: `028` lo había aceptado declarado, con el costo entonces teórico; once días
>     después el precio es visible —cada firma de S16 a S19, incluida la de `#111`, es **verdadera de
>     hecho y no demostrable por su metadato**— y C2 de S19 quedó bloqueada porque el taller **no
>     puede medir su propio mecanismo de identidad sin una segunda identidad**. Fede eligió entre
>     **cuatro** opciones con tradeoffs en sesión interactiva del 2026-08-04. `028` **conserva su
>     sello y su fecha** (`018`). **Declarado FUERA de alcance:** reponer el review requerido en la
>     protección de rama —posible de nuevo con dos cuentas— **es otra decisión y necesita su propio
>     ADR** contra `031`. Y **decidir no es aplicar**: el ADR queda ⛓️ **pendiente del externo**
>     hasta que el dueño cree y confirme la cuenta. Primera ratificación del día → **sin sufijo**
>     (`023`). **La ratificación es el merge de este PR por el dueño** (`018`). Encargo `#112`.*
>
> 22. ***2026-08-04 (2) · PR de `035`** — **`034` no se aplica.** Veinte minutos después de mergearla,
>     el dueño decidió **no crear la cuenta** («vas a quedar la mía» / «utilizá la mía y ya»), y con
>     eso el contrato quedó sin ninguna decisión vigente que describiera la realidad: `028` superado
>     por `034`, y `034` describiendo una cuenta que no iba a existir. **Drift doc↔realidad en el
>     sustrato del modelo de firma**, cerrado por `035`, que **supera a `034` completo** y repone la
>     posición de `028` con voz propia — sin resucitar a `028`, porque `018` no admite deshacer una
>     superación. `034` **queda intacta**: su análisis del precio del agujero sigue en pie y es la
>     constancia de qué se evaluó. **Consecuencia declarada y NO resuelta acá:** sin segunda identidad
>     **C2 de S19 no es ejecutable** — si S19 debe cerrar declarando §7 no medible, es acto del plano
>     y del dueño, no de un ADR de identidad. **Aprendizaje que vale más que los tres ADRs:** `034` se
>     firmó **con su externo todavía REQUERIDO** — firmar una decisión cuya viabilidad depende de un
>     acto que nadie confirmó es firmar sobre premisa no verificada, el modo de falla que `027` ya
>     había documentado. Segunda ratificación del día, sufijo `(2)` (`023`). Encargo `#114`.*
>
> 23. ***2026-08-04 (3) · PR de cierre de S19** — **S19 se cierra 4/6, con DOS criterios retirados** y
>     la tabla de `perimetro-de-confianza.md` §7 declarada **NO MEDIBLE con su motivo**. Los criterios
>     1 y 2 no fracasaron por falta de trabajo: **se quedaron sin objeto** cuando `035` decidió que no
>     hay cuenta de agente —re-medir exige una segunda identidad y `--user <agente>` se queda sin
>     argumento—. Es el mismo mecanismo con que S14 retiró un criterio el 2026-07-26 (`PLAN.md:461`),
>     y el método de S19 lo autoriza en su paso 3: *«se mide, **o se declara no medible con su
>     motivo**»*. **NO MEDIBLE no es un veredicto sobre los mecanismos sino sobre nuestra capacidad de
>     medirlos**: ninguna fila gana, ninguna se corrige, la tabla queda intacta con su defecto
>     declarado. Y **no cierra la salvedad de `gh pr create`**, que sigue ABIERTA: la tabla no se puede
>     medir, la salvedad no se puede cerrar, y confundirlas es lo que S19 vino a evitar. **Balance que
>     el plano deja escrito:** se cerró la contradicción de FUENTES —el plano dejó de prescribir lo que
>     la referencia medía roto, con cable que lo vigila— y **no** el HECHO: cuál mecanismo aísla sigue
>     sin saberse. **La sesión arregló el contrato, no el mundo.** Tercera ratificación del día, sufijo
>     `(3)` (`023`). Encargo `#116`.*
>
> 24. ***2026-08-04 (4) · PR que abre S20** — se abre **S20: cablear el tracker HTML**, la última
>     superficie sin control de la familia. No se abre por argumento sino por **medición**: al
>     2026-08-04 el HTML declara `LAST_AUDIT 2026-08-02` y `CLOSED_COUNT 80` contra un JSON en
>     `2026-08-04` y `88` — dos días y ocho cierres de atraso, más cuatro bloques faltantes. **Y ya
>     había pasado idéntico el 2026-08-02**, cuando se lo saldó a mano y la deuda escribió que «puede
>     volver a atrasarse en silencio mañana»: **se atrasó dos días después**. La deuda predijo su
>     propia repetición y acertó, que es el argumento entero de la sesión — **corregir la vista a mano
>     no arregla la ausencia del control que la vigila**. S20 incluye además cerrar la deuda de
>     verificación que dejó S19/H1 (el **chequeo 6 sin escenario sembrado**), porque toca esa misma
>     batería y dejarlo sería pasar al lado con la herramienta en la mano. **Sin ADR nuevo en este
>     acto.** Cuarta ratificación del día, sufijo `(4)` (`023`). **La ratificación es el merge de este
>     PR por el dueño** (`018`). Encargo `#118`.*
>
> 25. ***2026-08-04 (5) · PR que ejecuta S20** — **S20 cerrada 6/6**: nace el **chequeo 7**, el
>     tracker HTML deja de ser la vista que nadie mira. Se lo vio **FALLAR en las cuatro dimensiones
>     a la vez** —`LAST_AUDIT` 2 días, `CLOSED_COUNT` 8, bloques 4, ADRs 3— antes de corregir nada.
>     **Y el hallazgo no es el cable: es lo que la siembra encontró EN el cable.** Escribirlo destapó
>     **tres supuestos falsos propios**, los tres silenciosos porque devolvían números creíbles: el
>     regex no toleraba `id: 'b01'` con espacio (contaba 18 donde había 19); el helper de siembra
>     anclaba en `^];`, que es el cierre del **primer** array del archivo —`DATA`, no `DECISIONS`—;
>     y el conteo usaba `grep -c`, que cuenta **líneas** y no ocurrencias, así que dos entradas en
>     una línea contaban como una. **Ninguno habría salido a la luz sin sembrar.** Cuarta vez que
>     este taller mide lo mismo desde `b17`: **la superficie de verificación es código como
>     cualquiera y nace con defectos como cualquiera**. Se cierra además la deuda que dejó S19/H1 —el
>     **chequeo 6 sin escenario sembrado**— y se lo siembra **con su espejo**: uno exige ROJO ante el
>     mecanismo materializado en un fence, otro exige **VERDE** ante el mismo mecanismo nombrado en
>     prosa, porque sin ese segundo un futuro endurecimiento a grep de palabra suelta pasaría sin que
>     nadie lo note. La detección se probó **rompiéndola a propósito**: con el conteo saboteado la
>     batería se puso roja en 9 escenarios. **Sin ADR nuevo en este acto.** Quinta ratificación del
>     día, sufijo `(5)` (`023`). **La ratificación es el merge de este PR por el dueño** (`018`).
>     Encargo `#120`.*
>
> 26. ***2026-08-04 (6) · PR que abre S21** — se abre **S21: cablear la estampa de `ALCANCE.md`**, la
>     **última** vista sin control de la familia, declarada como hueco por S18 el 01-08 y vuelta a
>     declarar por S19 sin tomar. Se abre por **medición**: `ALCANCE:3` dice «Ratifica FICHA §0 y §11»
>     y su re-ratificación es del commit `26d604b`, pero `b37c162` **cambió §0 después** — huella
>     `9ba10af9…` de lo ratificado contra `adcc7935…` de lo que FICHA dice hoy. **ALCANCE ratifica una
>     versión de §0 que ya no existe.** El problema no era «falta un cable» sino **«¿contra qué
>     reloj?»**: el dueño eligió entre tres, en sesión interactiva del 2026-08-04, **el CONTENIDO de
>     §0 y §11** — los otros dos (reloj de ADRs, estampa de FICHA) eran más baratos y habrían nacido
>     muertos, porque **hoy darían rojo por cinco estampas que no tocaron esas secciones**, y un cable
>     ruidoso se ignora. El diseño que sale de ahí: **la huella vive en `ALCANCE.md` junto a su
>     estampa**, así ratificar deja de ser una fecha suelta y pasa a declarar **qué versión exacta** se
>     ratificó. **Sin ADR nuevo en este acto.** Sexta ratificación del día, sufijo `(6)` (`023`). **La
>     ratificación es el merge de este PR por el dueño** (`018`). Encargo `#122`.*
>
> ℹ️ *Versionado — **nota única, consolidada** (antes había una por ratificación y venían acumulándose
> con residuos). Regla: `023`, la fecha es la versión y la segunda ratificación del día en adelante
> lleva sufijo `(N)`; la primera no lo lleva. **Ratificaciones del 2026-07-26:** actos 5 `—` · 6 `(2)`
> · 7 `(3)` · 8 `(4)` · 9 `(5)` · 10 `(6)`. **Ratificaciones del 2026-07-30:** acto 11 `—` (primera del día, sin sufijo) · acto 12 `(2)`. **Del 2026-07-31:** acto 13 `—`. **Del 2026-08-01:** acto 14 `—` · acto 15 `(2)`. **Del 2026-08-02:** acto 16 `—` (primera del día, sin sufijo) · acto 17 `(2)` · acto 18 `(3)`.
> ⚠️ *Los actos 13 y 14 se asientan **retroactivamente** en el acto 15 (S17): ocurrieron el 31-07 y el 01-08 y esta estampa no se movió. **El sufijo cuenta ratificaciones, no asientos** —`023`—, así que 13 y 14 conservan la etiqueta del día en que pasaron y no la del día en que se escribieron. Reetiquetarlos por comodidad sería reescribir la historia que `018` prohíbe.*
> El **acto 6 fue la primera aplicación real** de la regla, no un ejemplo. Y el hueco que la motivó **sigue visible acá arriba**: los actos **2, 3 y 4 comparten
> `2026-07-25`** con contenidos distintos, porque `023` **no re-versiona el pasado** — reescribir
> firmas pasadas sería fabricar actos que no ocurrieron así (`018`).*
> Diseñada: 2026-07-18 (workflow de 6 agentes; verbatim declarado PERDIDO — `references/workflows-fan-out.md` es la reconstrucción canónica) · Obra: **v0 COMPLETA 9/9 (2026-07-22) + fix #38 · en mantenimiento** · absorbe a `director-de-obra`

## 0. Estrategia: v0 MÍNIMA, head-first (decidido por Fede 2026-07-18)

Corrección al plan original ("construir última"): `batuta` NO tiene que esperar a que TODOS sus delegados existan. Su **loop central corre solo con los dos cimientos** —`doc-arquitecto` (documentar) y `audit-tracker` (auditar + `/orquestar`)— **más los workflows, que ya existen.** Por eso se construye una **v0 MÍNIMA head-first** y se usa para bootstrappear el resto (armar la cabeza, y con la cabeza construir las extremidades más fácil).

**El salvaguarda real NO es el orden, es la regla "bloqueá, nunca reimplementes" (§8/§11):** cuando una fase necesita un músico que `ALCANCE.md` declara bloqueado, `batuta` FRENA y lo reporta como hueco-a-construir — jamás hace el trabajo ella misma "temporalmente". Único antídoto contra el god-object-por-necesidad; la tentación es máxima justo en ese momento.

**Precondición (lo mínimo ANTES de construir v0):** los dos cimientos SÓLIDOS. `audit-tracker` ✅. `doc-arquitecto` casi: sus comandos existen pero falta cerrar el fix `fede-tools` (#29→#21) y **PROBAR el install** — recién ahí es cimiento firme.

**Nomenclatura de versiones (firmada 2026-07-19 — ver `decisiones/007-corte-de-versiones.md`):**

- **v0 — bootstrap.** El loop de 4 fases (analizar → planificar → ejecutar-con-compuertas → cerrar) sobre los dos cimientos, con externos y ruteo en forma MÍNIMA best-effort, sin campo estructurado. Se construye para bootstrappear el resto del taller.
- **v1 — las 6 fases formales.** Suma `mapear-externos` y `definir-ruteo` como fases propias, el campo estructurado `externos` en `doc-arquitecto` Y `audit-tracker`, y el Plan de Ruteo firmado.
- **v2 — portafolio.** Altitud de flota (consume `cartera`) y estado VERIFICADO de externos.

### Alcance MÍNIMO de v0

- **Orquesta SOLO:** `doc-arquitecto` (`/documentar`, `/auditar-docs`), `audit-tracker` (`/audit-tracker`, `/orquestar`), y workflows (fan-out + la planificación absorbida de `director-de-obra`).
- **Fases activas:** analizar → planificar → ejecutar-con-compuertas → cerrar. Mapeo-de-externos y ruteo en su forma MÍNIMA (best-effort: cosecha lo que los cimientos flaguean y, ante la duda, PREGUNTA — sin el campo estructurado `externos`, que es post-v0).
- **BLOQUEA** (hueco-a-construir, nunca reimplementa) ante un delegado que **`ALCANCE.md` §«v0 NO hace» declara bloqueado**, más el egreso outward genérico. *La lista concreta —qué bloquea hoy y por qué— **no se enumera acá**: vive en una sola fuente (`#105` rama B, firmada 2026-08-02), la misma que el comando consulta desde `0.6.0` (`#96` rama C). Enumerarla en dos lugares es lo que la hizo derivar trece días.*
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

## 4. Las fases de una corrida — **4 activas en v0**, 6 en v1

> ⚠️ **Lo que corre hoy son CUATRO** (`ALCANCE.md`, `decisiones/007`): analizar → planificar →
> ejecutar-con-compuertas → cerrar. Las fases **3 y 4** de la lista de abajo —`mapear-externos` y
> `definir-ruteo`— son **v1**: en v0 viven en forma MÍNIMA dentro de `planificar` y
> `ejecutar-con-compuertas`, sin fase propia y sin campo estructurado. El comando implementa cuatro.
>
> El título de esta sección decía «Las 6 fases» sin la distinción, y **ésta es la sección que `batuta`
> lee como precondición en cada corrida** — una lista de v1 leída como v0 es el terreno donde ya se
> rompió una vez (fix #37/#38). Corregido en **S16** como aplicación de `decisiones/030`.

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

> ⚠️ **Esta sección es una VISTA DERIVADA** (`decisiones/030`). **La fuente del estado de un ADR es
> `docs/decisiones/`**, y ante cualquier divergencia **manda la fuente, no esta tabla.** Acá viven el
> puntero, el sello y el mapeo a dónde se aplica; **el porqué vive en el ADR**, que es donde ya está.
>
> Hasta S16 esta sección duplicaba en prosa el cuerpo de cada ADR —~25 párrafos— y **esa duplicación
> era la fuente del drift, no su síntoma**: dos de las seis sesiones de mantenimiento (S11 y S12) se
> gastaron corrigiéndola. El chequeo de `.github/workflows/coherencia.yml` verifica en cada PR que
> cada fila de acá coincida con el sello de su ADR y que ningún ADR quede sin fila.

| ADR | Decisión | Sello | Fecha | Baja / aplica en |
|---|---|---|---|---|
| [`001`](decisiones/001-mono-proyecto.md) | Mono-proyecto en v0 y v1 | ✅ FIRMADA | 2026-07-18 | §0 · §4 |
| [`002`](decisiones/002-granularidad-de-compuertas.md) | Granularidad de compuertas: Compuerta Cero | ✅ FIRMADA | 2026-07-19 | §4 · §11 |
| [`003`](decisiones/003-modo-boceto-greenfield.md) | Modo boceto greenfield: no existe | ✅ FIRMADA | 2026-07-19 | §11 · §12 |
| [`004`](decisiones/004-deteccion-de-externos.md) | Detección de externos: campo estructurado, jamás detector propio | ✅ FIRMADA | 2026-07-19 | §8 |
| [`005`](decisiones/005-clase-micro.md) | Clase «micro»: no existe | ✅ FIRMADA | 2026-07-19 | §11 · S07 |
| [`006`](decisiones/006-sustrato-markdown-puro.md) | Sustrato: markdown puro | ✅ FIRMADA | 2026-07-19 | §12 · alcance precisado por `030` |
| [`007`](decisiones/007-corte-de-versiones.md) | Corte de versiones v0 / v1 / v2 | ✅ FIRMADA | 2026-07-19 | §0 |
| [`008`](decisiones/008-absorcion-director-de-obra.md) | Absorción de `director-de-obra` como fase 2 | ✅ FIRMADA | 2026-07-18 | §9 |
| [`009`](decisiones/009-autenticacion-de-la-firma.md) | Autenticación de la firma | ✅ FIRMADA | 2026-07-21 | §7 · desbloqueó S06 |
| [`010`](decisiones/010-secretos-en-v0.md) | Escaneo de secretos en v0 | ✅ FIRMADA | 2026-07-20 | S05 |
| [`011`](decisiones/011-ratificacion-del-plano.md) | Acto de ratificación del plano | ✅ FIRMADA | 2026-07-19 · re-ratificada 2026-07-23 | S02 |
| [`012`](decisiones/012-umbral-de-egreso.md) | Umbral de egreso | ✅ FIRMADA | 2026-07-21 | desbloqueó S07 |
| [`013`](decisiones/013-retrospectiva-opcional.md) | El estado de `retrospectiva` | ✅ FIRMADA | 2026-07-22 | §3 · desbloqueó S08 |
| [`014`](decisiones/014-rubrica-de-confidence.md) | Rúbrica de confidence | ✅ FIRMADA | 2026-07-20 | S04 |
| [`015`](decisiones/015-eje-externo.md) | Decisiones nuevas del eje ejecutar + externos *(paraguas)* | ✅ CERRADA | 2026-07-24 | delega en `019` · `020` · `021` |
| [`016`](decisiones/016-cota-banda-angosta.md) | Cota de la banda angosta | ✅ FIRMADA | 2026-07-20 | S04 |
| [`018`](decisiones/018-blindaje-antifalsificacion.md) | La firma es un acto, no un campo | ✅ FIRMADA | 2026-07-20 | complemento operativo de `011` |
| [`019`](decisiones/019-fuentes-de-provisto.md) | Fuentes de verdad del PROVISTO | ✅ FIRMADA | 2026-07-24 | §5 · de `015` |
| [`020`](decisiones/020-salud-en-runtime.md) | Salud de externos en runtime: reporte, no estado | ✅ FIRMADA | 2026-07-24 | §5 · de `015` |
| [`021`](decisiones/021-lista-negra-egreso-v0.md) | Política general de egreso v0: lista negra mínima | ✅ FIRMADA | 2026-07-24 | completa a `012` · de `015` |
| [`022`](decisiones/022-asiento-bookkeeping-de-apertura.md) | Asiento del bookkeeping de apertura: tercer salvo | ✅ FIRMADA | 2026-07-25 | `registro-de-cadena.md` §6 |
| [`023`](decisiones/023-versionado-del-plano.md) | Versionado del plano: sufijo incremental dentro del día | ✅ FIRMADA | 2026-07-26 | S12 |
| [`024`](decisiones/024-patron-unico-de-sello.md) | Patrón único de sello: el ADR se firma en el PR que lo propone | ✅ FIRMADA | 2026-07-26 | S13 · §10 «Cuándo se estampa» |
| [`025`](decisiones/025-separacion-de-credenciales.md) | Separación de credenciales: el agente no opera con la cuenta del dueño | ✅ FIRMADA | 2026-07-26 | S13 · **superada en parte por `027`** |
| [`026`](decisiones/026-operaciones-administrativas.md) | Quién ejecuta las operaciones administrativas del repositorio | ✅ FIRMADA | 2026-07-26 | lista blanca acotada + asiento por uso |
| [`027`](decisiones/027-reversion-de-la-cuenta-del-agente.md) | Reversión de la cuenta del agente: la premisa de `025` era falsa | ✅ FIRMADA | 2026-07-26 | **supera en parte a `025`** |
| [`028`](decisiones/028-sin-cuenta-de-agente.md) | Sin cuenta de agente: el agujero de `009` se acepta, declarado | ✅ FIRMADA | 2026-07-26 | consecuencia sobre `registro-de-cadena.md` §6 |
| [`029`](decisiones/029-precondicion-de-identidad.md) | Ante discrepancia de identidad al arrancar: FRENAR, jamás restaurar | ✅ FIRMADA | 2026-07-28 | `batuta.md` §Precondición de identidad · `perimetro` §7 |
| [`030`](decisiones/030-coherencia-del-contrato.md) | Coherencia del contrato: fuente única y verificación mecánica | ✅ FIRMADA | 2026-07-30 | S16 · precisa el alcance de `006` |
| [`031`](decisiones/031-proteccion-de-rama-sin-review.md) | Protección de rama: el cable requerido sin review requerido | ✅ FIRMADA | 2026-07-31 | **supera a `027` punto 4** · fuente del estado de la protección |
| [`032`](decisiones/032-el-pase-en-el-diff.md) | El pase adversarial viaja dentro del diff que se firma | ✅ FIRMADA | 2026-08-01 | Compuerta Cero req. 1 · fase 2 pasos 3 y 5 · `registro-de-cadena.md` §5 |
| [`034`](decisiones/034-cuenta-de-agente-dedicada.md) | Cuenta de agente dedicada: el agujero de `009` se cierra en vez de aceptarse | ✅ FIRMADA | 2026-08-04 | **superada por `035`** — el externo no se proveyó · su análisis sigue en pie |
| [`035`](decisiones/035-sin-cuenta-dedicada-el-agujero-vuelve-a-aceptarse.md) | `034` no se aplica: el dueño opera con su credencial y el agujero de `009` vuelve a aceptarse | ✅ FIRMADA | 2026-08-04 | **supera a `034` completo** · repone la posición de `028` · C2 de S19 queda sin camino de medición |

**Los tres sellos que existen.** `FIRMADA` y `PENDIENTE` son el caso normal; **`CERRADA` es un tercer
sello legítimo** y `015` es su único caso: un **paraguas** que no se decide, se cierra delegando en
ADRs propios (`019`, `020`, `021`). Se declara acá porque un lector —o un chequeo— que asuma el binario
lo lee como sello ilegible. **No es un estado nuevo del modelo de decisiones: es el cierre de un
agrupador.**

**Lo que esta tabla NO reemplaza.** El porqué, el contexto, las opciones evaluadas y la `Procedencia`
de cada decisión viven **en su ADR**. Si al leer una fila hace falta saber *por qué*, el link es la
respuesta — y esa indirección es deliberada: es lo que impide que la ficha y el ADR se contradigan.

**Cambios de estado posteriores a la firma** (`027` sobre `025`) se leen en la columna *Baja / aplica
en* y en el `superaA` del ADR. Ninguna firma se reescribe (`018`): un ADR superado **conserva su sello
y su fecha**, y quien lo supera lo declara.

### Pendientes

| ADR | Decisión | Sello | Fecha | Baja / aplica en |
|---|---|---|---|---|
| [`033`](decisiones/033-mecanismo-de-identidad-por-operacion.md) | El mecanismo de identidad es POR OPERACIÓN, y su medición vive en un solo lugar | ⏳ PENDIENTE | 2026-08-03 | S19 · complementa a `029` · **la parte (b), sacar el FRENA, queda FUERA de su alcance** |

*Abierta el **2026-08-03** por S19, horizonte H1 (`#110`, autorizado por la firma de `#109`). Nace
⏳ PENDIENTE: es la **cuarta** vez que esta sección se usa, y por el mismo motivo que la segunda — la
ventana propuesta↔sello que `024` reserva para cuando la elección humana todavía no ocurrió. La parte
**(b)** —retirar el FRENA de `029:67-70`— **no está acá y no la propone el agente**: `PLAN.md:756-758`
la reserva al dueño y prohíbe su recomendación.*

*Historial de esta sección — tres veces vacía, por motivos distintos:*

1. *Hasta **S11** listaba el paraguas `015` como PENDIENTE mientras Firmadas lo declaraba **CERRADO**: la ficha se contradecía a sí misma dentro de la misma sección. S11 eliminó la **contradicción**, no el historial — el registro completo de `015` vive arriba, en Firmadas.*
2. *El **2026-07-26** volvió a tener una entrada por unas horas: `026` nació ⏳ PENDIENTE durante la **ventana propuesta↔sello** que `024` reserva para cuando la elección humana todavía no ocurrió.*
3. *El **2026-07-31**, misma ventana y mismo motivo, con `031`: se abrió para que el dueño estudiara las tres opciones antes de decidir. Su origen fue un desvío —ese día se repuso la protección de rama que `027` punto 4 había retirado, **sin declararlo**— y el ADR es la decisión que le faltaba a un acto ya ejecutado. El acto no se reescribe (`018`); se le da la decisión que le correspondía.*

> Esta línea se sostiene sola: si aparece una decisión pendiente, se agrega acá con su dueño y qué la desbloquea. Una sección vacía y una sección borrada se leen distinto — la primera dice «no hay», la segunda no dice nada.

*Historial de esta sección — dos veces vacía, por motivos distintos:*

1. *Hasta **S11** listaba el paraguas `015` como PENDIENTE mientras Firmadas lo declaraba **CERRADO**: la ficha se contradecía a sí misma dentro de la misma sección. S11 eliminó la **contradicción**, no el historial — el registro completo de `015` vive arriba, en Firmadas.*
2. *El **2026-07-26** volvió a tener una entrada por unas horas: `026` nació ⏳ PENDIENTE y se listó acá durante la **ventana propuesta↔sello** que `024` reserva para cuando la elección humana todavía no ocurrió. Al firmarse, pasó a Firmadas y la sección volvió a vaciarse. **Esa ventana es exactamente lo que `024` evita en el caso normal** — acá existió porque el dueño pidió abrir el ADR sin elegir.*

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

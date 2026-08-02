# Operación — cómo se corre `batuta` y qué le pasa hoy

> **Instantánea del 2026-08-02.** Este documento responde dos preguntas que el resto del plano no
> responde: **cómo se pone a correr `batuta`** y **qué está abierto hoy**.
>
> ⚠️ **Qué NO es.** No es parte del plano —no lo ratifica ninguna firma de `decisiones/011`— y **no
> es fuente de ningún estado**: es una **vista derivada** de `ALCANCE.md`, `PLAN.md`, `FICHA.md`,
> `docs/decisiones/` y `docs/audits/claude-batuta-estado.json`. **Ante divergencia manda la fuente,
> no este documento.**
>
> ⚠️ **Ningún cable lo mira.** `coherencia-contrato.sh` vigila `FICHA.md` §10 y el artefacto de
> estado; `frontera.sh` vigila `plugins/` y `docs/references/`. Este archivo no está en ninguno de
> los dos, así que **envejece solo** — el mismo defecto que `docs/audits/batuta-tracker.html` ya
> tiene declarado en la deuda del artefacto. Se dice acá para que nadie lo lea como estado vivo.

---

## 1. Cómo se corre

### Prerrequisitos de la máquina

| Qué | Por qué | Sin eso |
|---|---|---|
| **Claude Code** ≥ 2.1.x | Es el runtime del plugin | No hay comando |
| **`gh` CLI autenticado** | La precondición de identidad corre `gh api user --jq .login` (`plugins/batuta/commands/batuta.md:43`) | La corrida **FRENA en el arranque**, antes de leer el plano |
| **`doc-arquitecto` y `audit-tracker` instalados** | Son los **dos cimientos**: sin ellos las cuatro fases no tienen a quién delegar (`FICHA.md` §0, `ALCANCE.md:78-89`) | `batuta` BLOQUEA en la primera fase que necesite delegar |
| Un repo **en GitHub** | El bus del taller son los Issues y los PRs (`ALCANCE.md:122`) | Fuera de alcance de v0 |

`verificador`, `publicador` y `cartera` **no** hacen falta para arrancar: `batuta` bloquea contra
ellos solo si el objetivo los necesita, y qué bloquea hoy lo declara **una sola fuente**, la tabla
«v0 NO hace» de `ALCANCE.md` (`batuta.md:841-859`, `#96` firmada 2026-08-02).

### Modo A — instalado desde el marketplace

```
/plugin marketplace add hifede1/claude-audit-tracker
/plugin install batuta@fede-tools
```

Verificado el 2026-08-02 contra `hifede1/claude-audit-tracker` → `.claude-plugin/marketplace.json`:
`batuta` está listada con `source: git-subdir`, `url: https://github.com/hifede1/claude-batuta.git`,
`path: plugins/batuta`, **`ref: main`**.

- El catálogo `fede-tools` vive **solo** en `claude-audit-tracker` — los nombres de marketplace son
  globales en Claude Code y dos repos declarándolo colisionan (`references/plugins-claude-code.md:137`).
- El `uninstall` **lleva el sufijo**: `/plugin uninstall batuta@fede-tools`. Sin él puede no resolver
  (corrección de S01, `ALCANCE.md:53`).
- ⚠️ **Por `ref: main` sin pin, el merge a `main` ES la publicación** (`ALCANCE.md:118`, `#97` rama C
  firmada 2026-08-02). No hay release, ni tag, ni acto discreto que firmar aparte: lo que entra a
  `main` queda distribuido en ese instante. Y como `frontera.sh` CHEQUEO 1 obliga a mover
  `plugin.json` version ante cualquier cambio de `plugins/`, **toda edición del producto es un acto
  de distribución**, sin importar su tamaño (`ALCANCE.md:119`, `#95` rama A).

### Modo B — desarrollo, sin tocar el marketplace

```
claude --plugin-dir plugins/batuta
```

Es el modo que `references/plugins-claude-code.md:213,251` prescribe para iterar, y el que usaron
**todas las corridas sembradas de S09**. Hace falta porque los plugins **se copian al caché**
(`~/.claude/plugins/cache/`): editar el repo fuente no cambia el plugin instalado
(`references/plugins-claude-code.md:225`).

### La invocación

```
/batuta:batuta "[objetivo en una frase]"
```

`plugin:comando` es el namespacing real de plugins (`FICHA.md` §2). **Es el mismo string en los dos
modos** — verificado el 2026-08-02 cargando `--plugin-dir plugins/batuta` y listando los comandos
disponibles: `batuta:batuta`.

---

## 2. Las dos precondiciones que frenan antes de la fase 1

Una corrida puede morir antes de empezar, y de las dos formas la salida correcta es **frenar**, no
arreglar. Están en `batuta.md:34-100`.

### Primera — con qué identidad estás operando

```
gh api user --jq .login
```

Se coteja contra el **dueño anclado FUERA DE BANDA** (`decisiones/009`): el owner del repo o la
config del plugin, **nunca un archivo que un PR del loop pueda editar** — si no, un PR podría
redefinir al dueño y auto-autorizarse. Resuelve siempre a un **login puntual**: un colaborador con
admin **no** es el dueño.

- Coincide → sigue.
- No coincide → **FRENA, dice las dos identidades y espera.** *No restaura la cuenta por su cuenta*
  (`decisiones/029`): el estado del entorno es del humano.

> **La trampa que fija la regla, y está medida.** `~/.config/gh/hosts.yml` es **compartido entre
> sesiones de Claude Code**, y varias ejecutan `gh auth switch`. El 2026-07-28 la cuenta se
> restauró, se verificó en el acto y **volvió a cambiar en menos de 25 minutos**; la causa quedó
> determinada el 2026-08-01 (otras sesiones haciendo switch — y este repo es el 2.º mayor emisor de
> switches del disco: victimario, no solo víctima). **Una restauración no es estable.** Por eso se
> verifica al arrancar en vez de confiar en haber restaurado al cerrar.

### Segunda — el plano tiene que estar VIGENTE

Se busca la **línea de firma** en la cabecera del documento raíz del plano del proyecto orquestado:

```
> **Estado: VIGENTE**
> Firmado: AAAA-MM-DD por <quién>
```

**Son las dos líneas literales de `decisiones/011`, y nada más cuenta.** Cualquier otra mención de
«firmado» —«decisiones firmadas por X», «ficha firmada», un estado custom como «🔵 Lista para
construir»— **no es la firma**: el plano es borrador y la corrida va por el camino «sin plano», que
rutea a `/documentar` y frena con **cero bytes de contrato escritos**.

> No es teoría: la primera corrida de campo contra `cartera` tomó una *mención* de «firmado» por la
> firma (fix #37/#38). Ante la duda de si una línea es LA línea: **es borrador**.

---

## 3. Qué pasa cuando corre

Cuatro fases activas en v0 — las 6 de `FICHA.md` §4 son v1 (`decisiones/007`).

| Fase | Qué hace ella | A quién delega |
|---|---|---|
| **1 · analizar** (`batuta.md:113`) | Sintetiza y devuelve al humano su propia intención reformulada | `audit-tracker` lee el estado real; sin plano → `doc-arquitecto` y **frena** |
| **2 · planificar** (`batuta.md:161`) | Grafo de dependencias y horizontes, distinguiendo *gated-por-EJECUCIÓN* de *gated-por-FIRMA* — la única capacidad legítimamente propia, absorbida de `director-de-obra` (`decisiones/008`) | El pase adversarial va a un **workflow** de fan-out, contra estado fresco |
| **3 · ejecutar-con-compuertas** (`batuta.md:229`) | Abre **solo tres** compuertas y nada más | Todo cambio de código a `/orquestar`; lo divergente a workflows |
| **4 · cerrar** (`batuta.md:748`) | Exhibe la cadena `idea → plano → encargos → obra` y **todo desvío como hallazgo, no enterrado**; persiste un baseline liviano | La re-auditoría a `audit-tracker` — no re-escanea |

**La Compuerta Cero** (`batuta.md:235`): las fases baratas y reversibles colapsan en **una sola firma
por horizonte**, presentada como **diff** sobre el horizonte anterior, no big-bang. Sin firma no se
delega nada; el silencio nunca es aprobación.

**Las tres compuertas propias, y ninguna más** — `batuta` no duplica la firma de encargo, que es de
`/orquestar`:

1. **Externos** — Manifiesto con estado binario REQUERIDO / PROVISTO. Verifica **presencia** de la
   env var o el MCP, **jamás lee el valor**, y nunca marca VERIFICADO (eso es v2). Un REQUERIDO no
   provisto **bloquea y pide**, no adivina (`batuta.md:566-680`).
2. **EGRESO outward, tipado por efecto** (`batuta.md:391`) — lo idempotente que lee (GET/search) se
   batchea en una autorización de sesión; lo que escribe o tiene efecto (POST/mail/pago/deploy)
   lleva **compuerta individual**.
3. **workflow→cola** (`batuta.md:488`) — lo divergente no entra a la cola sin plano.

**Lo que jamás hace:** escribir código, abrir ramas, mergear, publicar, o suplir a un delegado
caído. Ante un delegado bloqueado **FRENA y reporta hueco-a-construir** — la tentación es máxima
justo en el fallo, y ese es el momento en que un orquestador se vuelve god-object
(`batuta.md:841-862`).

**Dato entrante de un externo = contenido no confiable**, dato y jamás directiva. Nunca mueve el
loop, se etiqueta, y la etiqueta **se propaga aguas arriba** desde cualquier sub-agente que tocó un
externo (`batuta.md:506-541`).

---

## 4. Dónde queda la evidencia de una corrida

```
${CLAUDE_PLUGIN_DATA}/corridas/<corrida-id>.md
```

con `<corrida-id>` = `<fecha-de-inicio>-<slug-del-objetivo>`. **La variable no tiene un destino
único** — depende del modo de carga (`registro-de-cadena.md` §4):

| Modo | Path del registro |
|---|---|
| Instalado desde marketplace | `~/.claude/plugins/data/batuta-fede-tools/corridas/` |
| `--plugin-dir` | `~/.claude/plugins/data/batuta-inline/corridas/` |

> **Buscar en un solo path es leer medio contrato.** Antes de concluir que una corrida «no existe»
> hay que mirar los dos. Y el registro **no es continuo entre modos**: una corrida de marketplace no
> se continúa con el plugin cargado inline, ni al revés (`registro-de-cadena.md:206`).

La evidencia de la batería de S09 vive en `batuta-inline/` y **no se migra**: es evidencia fechada,
y su path es el correcto para el modo en que corrió.

---

## 5. Qué le pasa hoy — triage de lo abierto

Lectura del **2026-08-02**, **cotejada contra GitHub el 2026-08-02**. Cada fila apunta a su fuente;
ninguna copia estado.

> **Por qué la fecha de cotejo va aparte de la fecha de la instantánea.** La primera versión de esta
> sección declaró cuatro decisiones del bus como abiertas porque copió el campo `deuda` del
> artefacto sin cotejarlo contra el canal — y las cuatro estaban cerradas. **Una vista derivada sin
> fecha de cotejo miente sola**, que es la regla que `ALCANCE.md:69` aplica a su tabla de cimientos.
> El error se deja escrito, no se borra: es el defecto del que trata este documento, cometido al
> escribirlo.

### Deforma lo que se ve, no lo que la herramienta hace

| Qué pasa | Fuente | Qué lo destraba |
|---|---|---|
| **El tracker HTML quedó doce cierres atrás.** `docs/audits/batuta-tracker.html` declara `LAST_AUDIT 2026-07-30` y `CLOSED_COUNT 68`; el artefacto JSON va en `2026-08-02` y `80`, y el HTML no tiene los bloques de S17 ni S18. Agravante: dos commits titulados «docs(tracker): cerrar S17» y «…cerrar S18» **no tocaron el HTML** — movieron el JSON | `estado.json` → `deuda` · `batuta-tracker.html:387-388` | Regenerarlo, o cablearlo: los cinco chequeos de coherencia miran `FICHA.md` y el JSON, el HTML no está bajo cable |
| **El campo `plan` del artefacto lista S05–S16** y omite S01–S04, S17 y S18, que están cerradas como `b18`/`b19` | `estado.json` → `plan` | Mantenerlo, o declararlo derivado de `PLAN.md` y sacarlo |

### Agujeros de contrato que esperan una firma

| Qué pasa | Fuente | Qué lo destraba |
|---|---|---|
| **`merged_by` no prueba quién actuó.** `decisiones/009` autentica la firma por `merged_by` == dueño anclado, pero `028` fijó que **no hay cuenta de agente**, así que el metadato no discrimina humano de máquina. `031` repuso la protección de rama (check requerido sin review, `enforce_admins`) y eso cierra **el flanco del cable, no el de la identidad** | `decisiones/009`, `027`, `028`, `031` · `estado.json` → `deuda` | Cuenta de agente dedicada, **o** aceptar el agujero por decisión firmada |
| **Tensión `006` ↔ `030` sin resolver.** La consecuencia 3 de `006` exige un ADR que lo **supere** para agregar código, y `030` declara `superaA: —`. Un script de CI es código. Dos lecturas defendibles, ninguna elegida — reescribir el `superaA` de un ADR firmado no es acto del agente (`018`) | `decisiones/006` §«Alcance precisado» | Firma del dueño eligiendo lectura |

### Cables que no cubren lo que parecen cubrir

| Qué pasa | Fuente | Qué lo destraba |
|---|---|---|
| **El chequeo 5 vigila atraso, no justificación.** Compara con `>=`, así que una estampa **adelantada** y sin ADR que la respalde pasa igual. Confirmado por partida doble el 2026-08-02: dio verde al drift de S18 *y* verde a su corrección | `coherencia-contrato.sh` · issue `#94` · `estado.json` → `deuda` | Decidir si el chequeo debe exigir respaldo, no solo frescura |
| **Nada coteja el `ALCANCE` contra el mundo.** Los tres `BLOQUEA` se apoyan en el estado de delegados que viven **fuera del repo**; `coherencia` mira ADRs y `FICHA` §10, `frontera` mira `references/` y `plugin.json`. Es lo que dejó tres afirmaciones falsas durante trece días (S18) | `PLAN.md:665-668` · `ALCANCE.md:99-114` | Exige **red en CI** y todos los cables corren offline por diseño: es decisión, y va a ADR propio |
| **La estampa de `ALCANCE.md` no la cubre nadie.** El chequeo 5 ancla en `FICHA.md`; la cabecera de `ALCANCE` envejece igual de sola, y está declarado como hueco sin cerrar | `ALCANCE.md:8-9` | Sexto chequeo con su escenario sembrado |

### El patrón de despacho, roto dos jornadas seguidas

| Qué pasa | Fuente | Qué lo destraba |
|---|---|---|
| **Dos jornadas consecutivas sin issue de encargo** — S16 y la del 31-07/01-08 (#82, #84, #85, #87). El modo despacho lleva dos jornadas sin usarse y la cola de issues no refleja el trabajo reciente. **No se fabrica asiento retroactivo** (`registro-de-cadena.md` §6 lo prohíbe): se exhibe | `estado.json` → `deuda` | Abrir el encargo **antes** de trabajar. Que se repita después de declararlo es el dato: una regla incumplida dos veces sin consecuencia es un cartel, no un cable |

### Trabajo sin asiento en el plano

| Qué pasa | Fuente | Qué lo destraba |
|---|---|---|
| **S15 está cerrada (2026-07-28) y no tiene requisito en `PLAN.md`.** Nació fuera del plano, como hallazgo de corrida. Consecuencia contable: los identificadores `S15/*` **no existen en ninguna `plano_version`**, así que un encargo que los invoque nace como eslabón roto | `PLAN.md:466-481` | Incorporarla al plano **la firma el dueño** — el agente no fabrica el requisito |
| **Seis hallazgos viven solo en el registro local**, fuera del repo, y **nadie los tiene a la vista en GitHub**: N4, N6, N7, N8, N12 y N13 de la corrida `2026-08-02-publicar-050-y-esqueletos-s17-s18`. Esperaban a que se firmara la rama de `#94`; **ya se firmó**, así que hoy son despachables. El séptimo, N1, **ya cerró** con `#105`/`#106` | `estado.json` → `deuda` · issue `#101` | Despacharlos al canal. Requieren la máquina del dueño: el registro no vive en el repo |

### Lo que el `deuda` del artefacto declara abierto y **ya no lo está**

Cotejado contra el canal el 2026-08-02. Se listan porque el artefacto todavía los declara abiertos,
y un lector que solo mire ahí concluiría lo contrario:

| Qué decía | Qué es cierto |
|---|---|
| «Cuatro decisiones-a-firmar abiertas en el canal: `#95`, `#96`, `#97`, `#98`» | **Las cuatro cerradas**, y materializadas: `#97`/`#95` en `26d604b`, `#96` en `07439a1` y `79bf477`, `#98` sin drift vivo — la descripción de `plugin.json` y la del catálogo **coinciden literalmente** (verificado contra `marketplace.json`) |
| «SIETE hallazgos huérfanos» | **Seis.** N1 cerró con `#105`/`#106` |

**El único issue abierto del repo es `#101`**, el reporte de cierre de la corrida del 2026-08-02.

### Observación abierta al escribir este documento

- **`FICHA.md:155` sigue diciendo que falta cerrar el fix `fede-tools` (#29→#21) y PROBAR el
  install de `doc-arquitecto`**, mientras `ALCANCE.md:30-33` declara la compuerta **ABIERTA desde el
  2026-07-19** con evidencia en `audits/s01-install-limpio-2026-07-19.md`. Puede ser lectura
  histórica legítima —la frase describe la precondición *antes* de construir v0— o la misma clase de
  copia vencida que `#105` acaba de sacar de esa misma sección. **No se resuelve acá**: es §0, o sea
  plano firmado, y corregirla es acto del dueño. Se anota para que no se investigue de cero.

---

## 6. Trampas operativas ya medidas

| Trampa | Qué costó | Regla |
|---|---|---|
| **«Cierra #N» no cierra nada** | El PR #89 se mergeó con «Cierra #88» y el issue quedó OPEN | GitHub solo reconoce `closes/fixes/resolves` **en inglés**. Confirmado con control: `#92` usó «Resolves #91» y el issue cerró **un segundo después** del merge. Las keywords van en inglés aunque el resto del PR esté en español |
| **Los marcadores de omisión de CI se disparan al documentarlos** | Dos veces en dos jornadas: el commit que explicaba la trampa la citó literal y GitHub la leyó como orden — cero corridas, cero check runs, PR bloqueado | Para las cadenas que GitHub interpreta, **documentar no alcanza**: se citan partidas o descritas en prosa. Nunca en su forma literal |
| **Tocar `plugins/` sin mover la versión** | `frontera.sh` CHEQUEO 1 pone el CI en rojo | Bumpear `plugin.json` version — y recordar que por §1 eso **publica** |
| **Un PR que queda pendiente sin corrida** | `coherencia` es check requerido: sin corrida el PR no se puede mergear nunca | `gh workflow run "coherencia del contrato" --ref <rama>` |
| **`gh auth switch` altera la cuenta activa global del humano** | S14: el dueño quedó operando con otra cuenta sin pedirlo | Credenciales **por operación**: `GH_TOKEN=$(gh auth token --user <cuenta>) gh <comando>` |

---

## 7. Cómo se verifica el repo

Los dos cables y sus dos baterías corren solos en cada PR
(`.github/workflows/coherencia.yml`) y también en local, en segundos y sin dependencias más allá de
`jq`:

```bash
bash .github/scripts/coherencia-contrato.sh .   # las vistas contra la fuente — hacia adentro
bash .github/scripts/bateria-sembrada.sh .      # ¿el chequeo FALLA cuando debe?
bash .github/scripts/frontera.sh .              # el contrato contra el disco — hacia afuera
bash .github/scripts/bateria-frontera.sh .      # ¿el cable de frontera detecta?
```

**Cada cable va con su batería a propósito** (`decisiones/030`): el criterio de aceptación no es que
el chequeo pase, sino que **falle cuando debe**. Una garantía verificada una sola vez es histórica —
si alguien rompe la detección, el cable seguiría verde y nadie se enteraría.

### Los tres códigos de salida, y el del medio es el que importa

| Salida | Significa |
|---|---|
| `0` | VERDE — coincide |
| `1` | ROJO — hay drift, con el ADR o el archivo señalado |
| **`2`** | **FRENA ≠ FALLA.** Falta una precondición y el cable **no pudo evaluar nada**. Jamás es un verde, y jamás es silencio |

Un `exit 2` leído como «pasó» es exactamente el falso verde que estos cables existen para evitar.

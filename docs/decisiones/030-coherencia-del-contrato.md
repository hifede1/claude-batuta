# 030 — Coherencia del contrato: fuente única y verificación mecánica

**Estado:** ✅ **FIRMADA** · 2026-07-30 · **Firmada por:** Fede
**Procedencia de la firma:** dos actos rastreables (`018`). **(1) Apertura sin decisión:** este ADR se
abrió en el PR #77 del 2026-07-30 **sin opción elegida** — nació ⏳ PENDIENTE, el caso que `024`
reserva para cuando la elección humana todavía no ocurrió. **(2) Elección:** en la misma sesión
interactiva del 2026-07-30, Fede eligió **«opción 2 — doctrina + verificación mecánica»** entre las
tres opciones presentadas con sus tradeoffs y con la recomendación y su contrapunto a la vista.
**Ratifica al mergear este PR.**
**superaA:** — *(no supera a nadie; complementa `006` precisando su alcance, y fija el rol de `FICHA.md` §10, del artefacto de estado y de `PLAN.md` como vistas derivadas)*
**Origen:** análisis de la serie de mantenimiento S10–S15 (2026-07-30). No es un hallazgo de corrida:
es el patrón que emerge al leer las seis sesiones juntas.

## Contexto / problema

**Las seis sesiones de mantenimiento post-v0 arreglaron el mismo defecto seis veces.** Ninguna
agregó capacidad; todas corrigieron divergencia entre documentos que declaran lo mismo:

| Sesión | Qué divergía | Cómo se autodescribe |
|---|---|---|
| S10 | `registro-de-cadena` §4 omitía un modo de path que `plugins-claude-code.md:70` sí declaraba | «precisión de documentación, cero cambio de comportamiento» |
| S11 | `FICHA.md` §10 listaba `015` como firmada **y** pendiente | «contabilidad, cero cambio de comportamiento» |
| S12 | `023` FIRMADA y `registro-de-cadena.md` §3 sin reflejarla | «contabilidad y precisión. Cero decisión nueva» |
| S13 | `009` autenticaba por `merged_by` sobre una premisa falsa | «bajar `024` y `025` a contrato. Cero decisión nueva» |
| S14 | mecanismo de credenciales sin documentar | 1 criterio **retirado** |
| S15 | regla de `perimetro` §7 con disparador que nunca ocurre | «tenía una sola precondición» |

Y hay un séptimo caso **vivo al firmar este ADR**: el label `externo`. La decisión de la mesa chica
del 2026-07-24 se aplicó en `batuta.md:604-616` (crear el label con `gh label create`) y **no se
propagó** a `:632`, `:637`, `:658` ni `:729`, que lo siguen tratando como hueco-a-construir. El
autochequeo de `:658` **frena por hacer lo que `:613` ordena**.

### La causa raíz no es descuido: es estructura

El estado de un ADR vive **en cuatro lugares**, tres de los cuales son copias que no se declaran
copias y no apuntan a la fuente:

| Dónde | Rol real | Rol declarado (antes de este ADR) |
|---|---|---|
| `decisiones/NNN.md` | la fuente | la fuente |
| `FICHA.md` §10 | copia en prosa (~250 líneas) | ninguno — se lee como fuente |
| `docs/audits/<proyecto>-estado.json` | copia estructurada | ninguno |
| `PLAN.md` («bloqueada por») | copia | ninguno |

La propagación es **100 % manual** y no hay gate. Con esa estructura el drift no es un accidente:
es la salida esperada del sistema.

### La doctrina del propio proyecto ya juzgó esto

> «Un control que no puede fallar tampoco puede detectar nada, y es peor que no tenerlo: figura en la
> lista de causales y **da falsa cobertura**.» — `registro-de-cadena.md:120`

> «Un ADR firmado que no baja al contrato operativo **es una intención, no una regla**.» — S12

Las dos reglas se escribieron para juzgar **el proyecto que `batuta` orquesta**. Nunca se aplicaron a
`batuta` **como sistema de documentos**.

### Y el peaje está medido

La deuda del artefacto de estado lo dice con fecha:

> «El `estado.json` arrastró a `026` como decisión pendiente después de que el ADR quedara FIRMADA…
> la vista derivada envejeció sola. Lo cazó una corrida real de `batuta` el 2026-07-28, **NO la
> re-auditoría de ese mismo día, que lo miró y no lo vio**.»

Un control cuyo mecanismo es *«alguien lee con atención»* ya falló, con evidencia fechada.

## Opciones evaluadas

### 1. Solo doctrina — declarar fuente vs vista derivada, sin mecanismo — *descartada*

`decisiones/` se declara **LA fuente** del estado de un ADR; `FICHA.md` §10, el artefacto de estado
y `PLAN.md` se declaran **vistas derivadas** con puntero a la fuente y regla de precedencia. §10 pasa
de prosa duplicada a tabla de punteros.

- **A favor:** cero superficie nueva, cero tensión con `006`, se hace en una sesión S. Reusa un patrón
  que el proyecto ya tiene funcionando («el snapshot orienta, GitHub decide»).
- **Contra:** **sigue siendo un cartel.** Es exactamente la clase de control que falló el
  2026-07-28. Reduce la superficie de drift pero no lo detecta.

**Por qué se descarta:** no se descarta su contenido —la opción 2 lo incluye entero— sino su
suficiencia. Elegirla sola sería reafirmar el mecanismo que la evidencia descalifica.

### 2. Doctrina + verificación mecánica — ✅ **ELEGIDA**

La opción 1, más un chequeo que corre **sin que nadie lo pida** en cada PR. Alcance inicial mínimo:
el campo que ya falló.

- **A favor:** es el único que convierte la regla en cable. Verificado en escritorio el 2026-07-30:
  un chequeo de ~60 líneas dio VERDE contra el repo real y ROJO contra el drift de `026` sembrado,
  en 0,1 s — el mismo drift que la re-auditoría miró y no vio. Trajo un segundo chequeo gratis (que
  los 27 ADRs tengan su línea de sello).
- **Contra:** **primera superficie de CI del proyecto**, que hay que mantener. Y un chequeo mal
  escrito da falsa cobertura, el pecado exacto que viene a evitar.
- **Dependencia que tenía abierta:** el alcance de `006`. **Resuelta por esta firma** — ver abajo.

### 3. Doctrina + verificación delegada a la re-auditoría — *descartada*

La opción 1, y que `/audit-tracker` verifique campo por campo en cada re-auditoría — lo que la deuda
vigente proponía.

- **A favor:** cero superficie nueva, respeta la delegación (auditar es tarea del delegado).
- **Contra:** **ya falló, con fecha.** La re-auditoría del 2026-07-28 lo miró y no lo vio.

**Por qué se descarta:** elegirla sería reafirmar el control que la evidencia ya descalificó.

## Lo que esta firma decide

### 1. La jerarquía fuente ↔ vista derivada

`docs/decisiones/` es **LA fuente** del estado de un ADR. `FICHA.md` §10, el artefacto de estado y
`PLAN.md` son **vistas derivadas**: declaran que lo son, apuntan a la fuente, y **ante divergencia
manda `decisiones/`**.

Es el mismo patrón que el proyecto ya aplica tres veces —«el snapshot orienta, **GitHub decide**»—
subido un nivel: **el ADR decide, la ficha orienta.**

### 2. El alcance de `006` queda PRECISADO — no ampliado

La deuda vigente leía: *«por `decisiones/006` (sustrato markdown puro) no hay test que clave los
criterios»*. **Esta firma adopta la lectura estricta:**

> `006` fija el sustrato **del producto** — el comando es `.md`, sin código, sin build, sin
> dependencias de instalación. **Un chequeo de coherencia entre documentos no cambia el sustrato del
> producto: es verificación, no producto.**

Dos apoyos: `006` habla del comando y de lo que se instala, no de la infraestructura de verificación
del repo; y hay **precedente en el propio repo** — el artefacto de estado **ya no es markdown** y
nunca se consideró que violara `006`.

**Lo que esta precisión NO habilita:** ni build del comando, ni dependencias en lo que se instala, ni
lógica de producto fuera de markdown. Sigue vigente que los **criterios de aceptación de una sesión**
se verifican con **corridas sembradas**, no con tests unitarios. Lo único que se habilita es
verificar **coherencia entre documentos del repo**.

### 3. El criterio de aceptación es que el chequeo FALLE cuando debe

El contrapunto de `014` que acompañó la recomendación **se adopta como criterio, no como nota**:

> Un cable mal puesto es peor que el cartel, porque el cartel no promete nada.

Medido el 2026-07-30 construyendo el chequeo de prueba, dos fallas en un mismo script:

1. **Muerte silenciosa** — `set -e` más un `grep` sin match mataron el script tras imprimir el
   encabezado. **Un chequeo muerto se ve igual que un chequeo que pasa.** De ahí que el chequeo deba
   **frenar distinto de fallar**: precondición ausente → salida `2` explícita, jamás silencio.
2. **Falso positivo por prosa** — un `grep PENDIENTE` a lo bruto marca `026` como pendiente por su
   línea 120, que es una **mención**, no su sello. El chequeo ancla en `^**Estado:**`. **Los cables
   se ponen donde vive la verdad, no donde aparece la palabra.**

Por eso el criterio no es «el chequeo pasa» sino **una corrida sembrada que demuestre que FALLA
cuando debe**. Un chequeo que nunca se vio fallar es una intención con formato de comando.

## Alcance decidido

Mínimo deliberado. Un cable puesto, no una suite:

1. Todo ADR en `decisiones/` tiene su línea de sello `^**Estado:**`.
2. Los ADRs con sello PENDIENTE coinciden **exactamente** con `decisiones_pendientes` del artefacto
   de estado. *(El campo que ya falló.)*
3. Todo `FIRMADA` declarado en `FICHA.md` §10 tiene su ADR con sello y `Procedencia`.

**Fuera del alcance inicial, declarado:** la verificación de la **prosa** de §10 contra el cuerpo de
cada ADR. Es el frente grande y no se ataca con un parser — se ataca reduciendo §10 a punteros
(decisión 1 de arriba), que es lo que lo vuelve innecesario.

## Consecuencias declaradas

- El proyecto adquiere su **primer `.github/workflows/`**. La deuda de verificación estructural
  —«`claude-batuta` no tiene CI»— deja de ser un límite asumido y pasa a ser trabajo con asiento.
- `006` queda con su alcance **precisado por escrito**. Un lector futuro que lo invoque contra un
  chequeo de coherencia tiene acá la lectura que rige.
- El label `externo` y el título de `FICHA.md` §4 —«Las 6 fases de una corrida», que describe **v1**
  en la precondición que `batuta` lee en cada corrida— caen como **aplicación de la regla de
  propagación**, no como items sueltos.
- **Lo que este ADR NO resuelve:** el drift en **prosa**. Si `FICHA.md` §10 no se reduce a punteros,
  el chequeo 3 solo verifica que el ADR exista con sello — no que la prosa de §10 diga lo mismo que
  el ADR. La reducción a punteros es parte de esta decisión, y sin ella el cable queda a medias.

## Nota de numeración

Este ADR toma **030** y no `029`. La deuda vigente del artefacto de estado reserva **`029`** como
candidato para la decisión del 2026-07-28 —«ante discrepancia de identidad al arrancar, `batuta`
FRENA y no restaura»—, que ya está **tomada y aplicada al contrato** (`batuta.md:34-69`) y solo le
falta asiento en la fuente. Esa decisión es anterior; le corresponde el número anterior.

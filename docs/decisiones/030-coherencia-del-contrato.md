# 030 — Coherencia del contrato: fuente única y verificación mecánica

**Estado:** ⏳ **PENDIENTE** · **Dueño:** Fede · **Desbloquea:** elegir opción entre las tres de abajo
**Por qué nace PENDIENTE:** por `024`, el patrón corto exige que el acto humano de elección **ya haya
ocurrido**. Acá no ocurrió: la decisión se abre para que el dueño la estudie. Es exactamente el caso
que `024` reserva para el estado PENDIENTE.
**superaA:** — *(no supera a nadie; complementa `006` y precisa el rol de `FICHA.md` §10 y del artefacto de estado)*
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

Y hay un séptimo caso **vivo hoy**: el label `externo`. La decisión de la mesa chica del 2026-07-24
se aplicó en `batuta.md:604-616` (crear el label con `gh label create`) y **no se propagó** a
`:632`, `:637`, `:658` ni `:729`, que lo siguen tratando como hueco-a-construir. El autochequeo de
`:658` **frena por hacer lo que `:613` ordena**.

### La causa raíz no es descuido: es estructura

El estado de un ADR vive **en cuatro lugares**, tres de los cuales son copias que no se declaran
copias y no apuntan a la fuente:

| Dónde | Rol real | Rol declarado |
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

### 1. Solo doctrina — declarar fuente vs vista derivada, sin mecanismo

`decisiones/` se declara **LA fuente** del estado de un ADR; `FICHA.md` §10, el artefacto de estado
y `PLAN.md` se declaran **vistas derivadas** con puntero a la fuente y regla de precedencia («ante
divergencia manda `decisiones/`»). §10 pasa de prosa duplicada a tabla de punteros.

- **A favor:** cero superficie nueva, cero tensión con `006`, se puede hacer en una sesión S.
  Reusa un patrón que el proyecto ya tiene funcionando («el snapshot orienta, GitHub decide»).
- **Contra:** **sigue siendo un cartel.** Es exactamente la clase de control que falló el
  2026-07-28. Reduce la superficie de drift pero no lo detecta.
- **Costo lateral:** §10 pierde la lectura de corrido — hoy se entiende el proyecto entero leyendo
  esa sección.

### 2. Doctrina + verificación mecánica en CI

La opción 1, más un chequeo que corre **sin que nadie lo pida** en cada PR. Alcance inicial mínimo:
el campo que ya falló.

- **A favor:** es el único que convierte la regla en cable. Verificado en escritorio el 2026-07-30:
  un chequeo de ~60 líneas dio VERDE contra el repo real y ROJO contra el drift de `026` sembrado,
  en 0,1 s — el mismo drift que la re-auditoría miró y no vio. Trajo un segundo chequeo gratis (que
  los 27 ADRs tengan su línea de sello).
- **Contra:** **primera superficie de CI del proyecto**, que hay que mantener. Y un chequeo mal
  escrito da falsa cobertura, el pecado exacto que viene a evitar — probado en la misma prueba: la
  primera versión del script **murió en silencio** por `set -e` más un `grep` sin match, y un
  chequeo muerto se ve igual que uno que pasa. También hay que anclar en la línea del sello: un
  `grep PENDIENTE` a lo bruto marca `026` como pendiente por su línea 120, en prosa.
- **Dependencia abierta:** el alcance de `006`. La deuda vigente lee «por `decisiones/006` (sustrato
  markdown puro) no hay test que clave los criterios». Lectura alternativa a decidir acá: `006` fija
  el sustrato **del producto** —el comando es `.md`, sin build, sin dependencias de instalación— y un
  chequeo de coherencia entre documentos **no cambia el sustrato del producto**: es verificación, no
  producto. Precedente en el propio repo: el artefacto de estado **ya no es markdown** y nadie
  consideró que violara `006`.

### 3. Doctrina + verificación delegada a la re-auditoría

La opción 1, y que `/audit-tracker` verifique campo por campo en cada re-auditoría — lo que la deuda
vigente propone.

- **A favor:** cero superficie nueva, respeta la delegación (auditar es tarea del delegado).
- **Contra:** **ya falló, con fecha.** La re-auditoría del 2026-07-28 lo miró y no lo vio. Elegir
  esta opción es reafirmar el control que la evidencia descalifica.

## Recomendación — **MEDIA** (rúbrica `014`)

**Opción 2.**

| Condición de `014` | ¿Se cumple? |
|---|---|
| Evidencia directa | **Sí** — el drift está medido y fechado en la deuda del artefacto de estado; el chequeo se corrió contra el repo real y contra el drift sembrado |
| Reversible | **Sí** — borrar un workflow es trivial y no deja rastro en el producto |
| Sin dependencias abiertas | **No** — depende de resolver el alcance de `006` |

Falta **una** de las tres → **MEDIA**. La que falla es la tercera, y es la que el dueño tiene que
resolver: sin esa lectura de `006`, la opción 2 no se puede ejecutar.

**Contrapunto (obligatorio por `014`):** el argumento más fuerte en contra no es el mantenimiento —
es que **un cable mal puesto es peor que el cartel**, porque el cartel al menos no promete. La prueba
del 2026-07-30 lo mostró dos veces en un mismo script (muerte silenciosa; falso positivo por prosa).
Si se elige la opción 2, el criterio de aceptación tiene que ser **una corrida sembrada que verifique
que el chequeo FALLA cuando debe**, no solo que pasa cuando todo está bien. Un chequeo que nunca se
vio fallar es una intención con formato de comando.

## Si se elige la opción 2 — alcance propuesto

Mínimo deliberado. Un cable puesto, no una suite:

1. Todo ADR en `decisiones/` tiene su línea de sello `^**Estado:**`.
2. Los ADRs con sello PENDIENTE coinciden **exactamente** con `decisiones_pendientes` del artefacto
   de estado. *(El campo que ya falló.)*
3. Todo `FIRMADA` declarado en `FICHA.md` §10 tiene su ADR con sello y `Procedencia`.

Fuera del alcance inicial, declarado: la verificación de la **prosa** de §10 contra el cuerpo de cada
ADR. Es el frente grande y no se ataca acá — se ataca reduciendo §10 a punteros (opción 1, que la 2
incluye).

## Consecuencias declaradas

- Si se elige **1** o **3**: el drift sigue siendo detectable solo por lectura. Queda escrito que se
  aceptó ese costo a conciencia, igual que `023` aceptó el incremento manual sin gate.
- Si se elige **2**: el proyecto adquiere su primer `.github/workflows/`, y `006` queda con su
  alcance precisado por escrito — no ampliado, precisado.
- En los tres casos, el label `externo` y el título de `FICHA.md` §4 («Las 6 fases de una corrida»,
  que describe **v1** en la precondición que `batuta` lee en cada corrida) caen como aplicación de la
  regla de propagación, no como items sueltos.

## Nota de numeración

Este ADR toma **030** y no `029`. La deuda vigente del artefacto de estado reserva **`029`** como
candidato para la decisión del 2026-07-28 —«ante discrepancia de identidad al arrancar, `batuta`
FRENA y no restaura»—, que ya está **tomada y aplicada al contrato** (`batuta.md:34-69`) y solo le
falta asiento en la fuente. Esa decisión es anterior; le corresponde el número anterior.

# 034 — Cuenta de agente dedicada: el agujero de `009` se cierra en vez de aceptarse

**Estado:** ✅ **FIRMADA** · 2026-08-04 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«cuenta de agente dedicada»** entre **cuatro** opciones
presentadas con sus tradeoffs —(a) cuenta dedicada · (b) `estebaproject` acotada a un repo sandbox ·
(c) cuenta efímera que se crea, mide y se borra · (d) declarar la tabla de §7 **no medible** con su
motivo— en **sesión interactiva del 2026-08-04**, al preguntar cómo continuar S19. **Ratifica al
mergear este PR** — `merged_by` == dueño anclado (`009`), **con la salvedad que este ADR viene
justamente a cerrar**: hasta que la cuenta exista y opere, ese metadato **no discrimina**. Sello en el
PR que lo propone (`024`).

**superaA:** `decisiones/028` **completo** — no en parte. `028` decidió «sin cuenta: acepto el agujero
de `009`, declarado»; este ADR revierte esa elección. `028` **conserva su sello y su fecha** (`018`:
ninguna firma se reescribe) y su análisis sigue siendo correcto para el momento en que se tomó.
**Repone** `decisiones/025`, que quedó vigente pero inaplicable desde `027`.
**Cierra** el punto 3 de `027`, que dejó la cuenta del agente **explícitamente sin definir**.
**Origen:** S19 · C2 exige medir con `--user <agente>` y sin `<agente>` esos comandos no tienen
argumento.

---

## Contexto / problema

`028` aceptó el agujero de `009` **por escrito y con los ojos abiertos** — y su razonamiento no era
malo. Evaluó tres opciones y descartó crear una cuenta dedicada por **costo de mantener una identidad
más en un taller de una persona**, cuando lo que se compraba a cambio era, en ese momento, teórico.

**Lo que cambió no es el costo: es que el precio ya se está pagando y se puede ver.**

`028` lo dijo sin eufemismos: *«un merge del agente y uno del humano son estructuralmente idénticos.
Cuando un registro de este proyecto dice "autenticado por `merged_by` == dueño", dice algo verdadero
de hecho y no demostrable por ese metadato»*. Once días después, eso ya no es una nota al pie:

- **Cada firma de la serie S16–S19 arrastra la salvedad.** La ratificación de `#111` —de ayer— es
  verdadera y **no demostrable**. Lo mismo la de `#108`, `#106`, `#104`.
- **`031` repuso la protección de rama sin review requerido** *porque* no hay cuenta de agente
  (`027` punto 4): sin dos cuentas, GitHub no permite aprobar el PR propio. El flanco del cable se
  cerró; el de la identidad quedó abierto **por la misma causa**.
- **S19 se topó con el muro.** La tabla de `references/perimetro-de-confianza.md` §7:265-269 está
  declarada **CONFUNDIDA** y su re-medición (C2) exige `gh auth switch --user <agente>` y
  `GH_TOKEN=$(gh auth token --user <agente>)`. **Sin `<agente>`, esos comandos no tienen argumento.**
  El taller no puede medir su propio mecanismo de identidad porque no tiene una segunda identidad.

Y el flanco no es sólo formal. El **2026-07-28** dos comandos completos del taller corrieron con la
cuenta de otro proyecto y **se detectó por accidente**, porque un comando devolvió otro login.

## Opciones evaluadas

| # | Opción | Tradeoff |
|---|---|---|
| **1** | **Cuenta dedicada** ✅ *(elegida)* | Costo real de crear, autenticar y mantener una identidad más. A cambio: destraba C2 **y** cierra el agujero de `009` — las firmas pasan a ser demostrables. |
| 2 | `estebaproject` acotada a un repo sandbox | Barata y sin cuenta nueva; el efecto medido es local (`~/.config/gh/hosts.yml`), así que el repo destino es indiferente. Pero sigue usando una cuenta ajena y **deja el agujero de `009` intacto**: destraba S19 y nada más. |
| 3 | Cuenta efímera: crear, medir, borrar | Costo de creación casi idéntico al de la permanente, **sin** el beneficio permanente. Cero mantenimiento a futuro; agujero intacto. |
| 4 | Declarar §7 **no medible** con su motivo | `PLAN.md:744` lo permite explícitamente. Motivo honesto y estructural. Precio alto y permanente: §7 queda CONFUNDIDA **para siempre**, y con ella el sustrato de `009`/`025`/`028`/`029`. |

**Por qué la 1 y no la 2**, que era la barata: la 2 resuelve el síntoma —falta un argumento para el
comando— y deja intacta la enfermedad. Este proyecto ya tiene registrado adónde lleva eso: la batería
de coherencia arregló **el número** del ADR sembrado y dejó viva **la asignación** un renglón más
abajo; el mismo defecto volvió a morder catorce días después. Elegir la 2 habría sido comprar la
medición y seguir firmando sin poder probarlo.

## Decisión

**El taller tiene una cuenta de agente dedicada. El agujero de `009` se CIERRA en vez de aceptarse.**

### Las tres propiedades que la cuenta debe cumplir — verificadas ANTES de adoptarla

Esto no es ceremonia: es la regla que `027` fijó después de que el agente adoptara `estebaproject`
heredándola del default de `gh` **sin verificar de quién era**.

1. **Sin historia previa.** Creada para este propósito. No se recicla una cuenta existente, no se
   toma la que esté activa, no se hereda de ningún default.
2. **Único propósito: ser el agente de este taller.** No pertenece a otro proyecto ni se comparte con
   uno.
3. **Confirmada por el dueño como suya y disponible** — explícitamente, no deducida por el agente de
   ninguna señal del entorno.

**Permisos: `push = true`, `admin = false`** — lo que `025` prescribía.

> **El login concreto NO se fija en este ADR.** Se completa cuando la cuenta exista y el dueño la
> confirme. Fijarlo antes sería adivinarlo, y adivinar la identidad es exactamente el error que `027`
> corrigió. **La cuenta la crea el dueño: el agente jamás se auto-provee** (`FICHA.md` §5, campo
> QUIÉN del Manifiesto de externos).

### Qué recupera esta decisión

Todo lo que S13 construyó y que sobrevivió a la caída de `027` **sin escribir una línea nueva**, como
`028` mismo anticipó: *«el día que se cree una cuenta dedicada, todo eso vuelve a operar»*.

- **`025` vuelve a ser aplicable**: el agente deja de operar con la credencial del dueño.
- **`merged_by` vuelve a discriminar** humano de máquina — el primer salvo de
  `registro-de-cadena.md` §6 recupera su **valor probatorio**, que `028` le había quitado.
- **El canal de firma puede volver al review de PR**, que `027` punto 4 había vuelto imposible.
- **C2 de S19 queda destrabada**: `<agente>` existe.

## Consecuencias

**Se paga** el costo que `028` había evitado: crear, autenticar y mantener una identidad más, y
recordar operar con ella. Es real y no se minimiza.

**Se gana** que las firmas del proyecto sean **demostrables** y no sólo verdaderas — la propiedad
sobre la que se apoya todo el modelo de ratificación (`009`, `018`, `025`, `029`).

**Límite explícito, y se declara para que no se lea como olvido:** este ADR **NO repone el review
requerido en la protección de rama**. Con dos cuentas vuelve a ser posible el canal que `027` punto 4
retiró y que `031` dejó deliberadamente sin reponer, **pero eso es otra decisión y necesita su propio
ADR** que declare qué punto de `031` supera. Meterlo acá sería ampliar el alcance por la ventana, que
es el modo en que este proyecto ya se rompió una vez.

**Este ADR NO re-autentica el pasado** (`018`). Los actos de S10 a S19 quedan como están: reales, con
**prueba débil**, tratables como **no concluyentes** — jamás como eslabón roto retroactivo
(`registro-de-cadena.md` §6 al cierre de los salvos). Lo que cambia es de acá en adelante.

**Reversión:** si mantener la cuenta resulta más caro de lo previsto, el camino es un ADR que declare
qué punto de éste supera —el patrón de `031`—, no volver en silencio a operar con la credencial del
dueño.

## Estado de aplicación

⛓️ **Pendiente del externo.** La cuenta la crea el dueño (en curso al firmarse este ADR). Hasta que
exista, esté confirmada y autenticada:

- `merged_by` **sigue sin discriminar** — la salvedad de `028` sigue operando de hecho aunque su
  decisión esté superada;
- **C2 de S19 sigue bloqueada**;
- el canal de firma sigue siendo el **comentario `✅ validado`**, no el review.

**Decidir no es aplicar, y este ADR no finge lo contrario.**

# 028 — Sin cuenta de agente: el agujero de `009` se acepta, declarado

**Estado:** ✅ **FIRMADA** · 2026-07-26 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«sin cuenta: acepto el agujero de `009`»** entre tres
opciones presentadas con sus tradeoffs —crear una cuenta dedicada · aceptar el agujero · postergar—,
en sesión interactiva del 2026-07-26, tras la reversión de `027`. **Ratifica al mergear este PR** —
`merged_by` == dueño anclado (`009`), **con la salvedad que este mismo ADR declara**: esa
autenticación ya no discrimina, y es precisamente lo que se acepta.

**superaA:** completa a `027` — que revirtió la cuenta sin elegir reemplazo, y dejó esa elección
abierta a propósito.
**Origen:** consecuencia declarada de `027`

## Contexto / problema

`decisiones/009` fija que la firma se autentica por **`merged_by` == dueño anclado**. Ese criterio
**solo discrimina si el agente NO comparte esa credencial** — cosa que `025` resolvió separando
cuentas y que `027` revirtió al descubrirse que la cuenta elegida pertenecía a otro proyecto.

`027` dejó la elección de cuenta **abierta a propósito**: no se hereda de ningún default, que es el
error que ese ADR corrige. Este ADR la cierra.

## Opciones evaluadas

1. **Crear una cuenta dedicada.** Sin historia previa, único propósito ser el agente de este taller.
   Recupera todo lo que S13 ganó, esta vez sobre premisa verificada. Descartada por el dueño: costo de
   crear, autenticar y mantener una identidad más para un taller de una persona.
2. **Sin cuenta: aceptar el agujero, declarado.** ✅ *(elegida)*
   Cero fricción nueva. El precio es real y se paga por escrito, no en silencio.
3. **Postergar.** Descartada: dejar dos decisiones abiertas —esta y `026`— mantenía al agente sin vía
   legítima para una clase entera de trabajo, que es la condición que hizo que una regla se rompiera
   sola en S14.

## Decisión

**El agente opera con la credencial del dueño (`hifede1`), y el hueco de autenticación de `009` queda
ACEPTADO y DECLARADO.**

Lo que eso significa, sin eufemismos:

> **`merged_by` NO prueba quién actuó.** Un merge del agente y uno del humano son estructuralmente
> idénticos. Cuando un registro de este proyecto dice «autenticado por `merged_by` == dueño», dice
> algo **verdadero de hecho y no demostrable por ese metadato**.

Consecuencias operativas que quedan fijadas:

1. **El primer salvo de `registro-de-cadena.md` §6** —el PR de decisión del dueño— **conserva su
   forma pero pierde su valor probatorio**. Su condición ya está escrita en el propio salvo desde
   S13: *«autentica SOLO si el agente no comparte la credencial del dueño»*. Hoy la comparte, así que
   **el salvo no autentica**: se lo trata como declaración, no como prueba.
2. **El canal de firma vuelve al comentario `✅ validado`**, porque sin cuentas separadas GitHub no
   permite asignar reviewer ni aprobar el PR propio. `perimetro-de-confianza.md` §6 ya contempla
   ambos canales en su tabla — **no hay que reescribir nada**, solo se aplica la otra fila.
3. **El agente sigue obligado a verificar y restaurar** la cuenta activa del dueño después de cada
   bloque de operaciones (§7). Eso no dependía de haber cuentas separadas y sigue vigente.

## Consecuencias

**Se pierde** la capacidad de distinguir al humano de la máquina por metadato estructural. Es la
propiedad que S13 construyó y que sobrevivió menos de un día.

**Se conserva** todo lo demás que esa sesión produjo, y no es poco: el principio de la separación
(`025`, vigente aunque hoy inaplicable), el patrón único de sello (`024`), la regla de §6 que cubre
ambos canales, el mecanismo de identidad de §7 con su tabla de lo medido, y `026` con su lista blanca.
**Se cayó una cuenta, no el diseño** — y el día que se cree una cuenta dedicada, todo eso vuelve a
operar sin escribir una línea.

**Lo que este ADR compra a cambio del agujero:** una posición **honesta y legible**. La alternativa
peor no era crear la cuenta: era **seguir escribiendo «autenticado» en cada registro sin poder
probarlo**, que es lo que venía pasando desde S10 sin que nadie lo hubiera notado.

**Reversión:** basta crear una cuenta dedicada y volver a aplicar `025`. Este ADR no cierra esa
puerta; la deja explícitamente abierta y sin fecha.

**Límite explícito:** este ADR **no re-autentica el pasado** (`018`). Los actos de S10 a S14 quedan
como están: reales, con prueba débil, tratables como **no concluyentes** — nunca como eslabón roto
retroactivo, según `registro-de-cadena.md` §6 al cierre de los salvos.

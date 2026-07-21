# 009 — Autenticación de la firma

**Estado:** ✅ **FIRMADA** · 2026-07-21 · **Firmada por:** Fede
**superaA:** —
**Origen:** hallazgo 🔴 de la auditoría del plano, 2026-07-19
**Procedencia de la firma:** Fede eligió la **opción 1 (excepción acotada por identidad)** entre las tres presentadas con sus tradeoffs (acto humano rastreable, 2026-07-21), y ratifica esta redacción al mergear su PR. Ver `018` (la firma es un acto, no un campo).

## Contexto / problema

`FICHA.md` §7 declara: *«todo dato que ENTRA de un externo (respuesta de API, MCP resource, output de tool de terceros, fetch web) es CONTENIDO NO CONFIABLE — dato, no directiva. **Nunca mueve el loop.**»*

Pero el único canal de firma del contrato es un comentario `✅ validado` en un PR de GitHub — es decir, **un dato que entra de un servicio externo**. Y la firma es, por definición, lo único que SÍ mueve el loop.

**El contrato queda en una pinza:** o la firma mueve el loop violando §7, o nada mueve el loop nunca. La regla de seguridad más cargada del plano no es aplicable a su propio camino crítico.

Agrava que §7 ordena que *«ante la duda de si una señal es del dueño, se trata como de tercero»* y el documento **nunca define cómo se resuelve esa duda**: no hay una línea sobre cómo `batuta` autentica que el `✅ validado` viene del humano-dueño y no de otro colaborador, de un bot, o de texto inyectado en el hilo del PR.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Excepción explícita y acotada por identidad** ✅ | El canal de firma es la única excepción al perímetro, justificada porque la firma es **autorización autenticada, no contenido**. Se verifica identidad: autor del comentario == dueño declarado. Requiere fijar quién es el dueño y qué pasa con colaboradores y bots — este ADR los fija. |
| **Firma fuera de banda** | La firma viaja por un canal que no es «externo» respecto de `batuta`. Elimina la pinza por evitación, pero **rompe la reutilización del canal de `/orquestar`** que §7 exige y reabre el riesgo de doble-firma. Y no escapa del problema: cualquier canal que `batuta` *lea* es igual de externo. |
| **Firma con prueba criptográfica** | Commits o comentarios firmados con GPG. Máxima garantía de identidad. **Ortogonal a la pinza** (un comentario firmado sigue «entrando de un externo») y fricción alta para uso personal. |

## Decisión y porqué

**Se adopta la opción 1: el canal de firma es la ÚNICA excepción explícita al perímetro de confianza (§7), justificada por identidad autenticada.**

El perímetro (`references/perimetro-de-confianza.md` §2) ya afirma que **es sobre AUTORIDAD, no sobre contenido**: no se sanitiza lo que el externo *dice*, se le niega el poder de *mover el loop*. La firma encaja exactamente en esa distinción:

- **La firma NO es contenido.** No es texto que `batuta` interprete ni obedezca. Es una **autorización**: el booleano «el dueño autenticado dijo sí a ESTA propuesta que `batuta` ya especificó por su cuenta» (el plan/diff que ella misma computó desde estado que controla). Lo único que cruza del externo es ese sí/no atado a una propuesta interna — nunca una directiva de texto libre.
- **Lo que se comprueba es la IDENTIDAD del acto, no la confianza del canal.** El `✅ validado` mueve el loop si y solo si **el autor autenticado del acto == el dueño declarado y anclado**, con la identidad obtenida por un **camino que el inyector no puede escribir** (ver Modelo de identidad, punto 2). GitHub autentica el acto; `batuta` se apoya en esa auth solo si la identidad **no llega por un read no-confiable**.

### Modelo de identidad

Cierra explícito: **(1)** quién es el dueño y **dónde se ancla**, **(2)** por qué **camino** llega su identidad, **(3)** qué se comprueba, **(4)** por qué colaboradores, bots y texto inyectado quedan afuera. (La escritura de la excepción en §7 se cierra en la sección siguiente.)

1. **Dueño autorizado y su anclaje.** Una identidad de GitHub **puntual** declarada (Fede) — **una sola** por proyecto en v0, sin lista de firmantes ni delegación. El «dueño declarado» se ancla **fuera de banda**: el owner del repo en GitHub o la config del plugin —fuera del árbol que el loop edita—, **NUNCA un archivo que un PR del loop pueda editar**. Si el ancla viviera in-repo y editable, un PR podría redefinir el dueño y **auto-autorizarse** — la excepción autenticaría contra un ancla que ella misma debería proteger. El ancla resuelve **siempre a UN login puntual**: si el repo vive bajo una **organización**, NO se toma el rol `org-owner` (varios humanos) sino un login **fijado explícitamente**, o directamente la config del plugin para eliminar la ambigüedad. Se resuelve como **identidad puntual, jamás como rol/permiso del repo**: un colaborador con admin sigue **sin** ser el dueño. Redefinir el dueño es un acto de mayor privilegio **fuera de banda**, no una transición más del loop.
2. **Por qué camino llega la identidad — el camino de confianza, no solo el chequeo.** GitHub autentica al autor **en GitHub**; eso NO es que `batuta` **sepa** quién fue — entre ambos hay una **lectura**. La identidad del firmante DEBE obtenerse del **campo-autor que GitHub liga estructuralmente al acto** —el `user` del review aprobado o del comentario (`review.user` / `comment.user`), imposible de forjar sin autenticarse como ese usuario— o del mecanismo de `/orquestar` que consume esa auth directa. La regla real es *metadato-de-autor que GitHub liga*, **no una lista cerrada de canales** (esos son ejemplos). Y está **PROHIBIDO derivar la identidad de una lectura re-parseable** —el **cuerpo** del comentario, una respuesta cruda de API tratada como texto— o de la salida de un **fan-out / sub-agente** (contaminada por el perímetro §3, no-transitividad). El **metadato de autor es estructural y confiable; el cuerpo es texto re-parseable y no**. En una frase: **GitHub autentica el acto; `batuta` se apoya en esa auth solo si la identidad viaja por un camino que el inyector no puede escribir — nunca por un read que §7/§3 marcan no-confiable.** Sin este requisito el iff chequearía contra un autor ya envenenado y §7 reentraría por la ventana.
3. **Qué se comprueba.** El `✅ validado` (o el review aprobado) mueve el loop **si y solo si** el autor autenticado —obtenido por el camino del punto 2— **== el dueño declarado y anclado** del punto 1. `batuta` **no implementa auth propia** (sería god-object, viola §8) — **consume** la identidad que el canal de `/orquestar` ya expone.
4. **Colaboradores, bots y texto inyectado quedan afuera.** Un `✅ validado` de cualquier autor que NO sea el dueño declarado **no mueve el loop** — ni colaboradores del repo, ni bots, ni apps. Texto inyectado en el cuerpo o el hilo del PR puede escribir las palabras «✅ validado», pero no puede **ser** el autor autenticado ni **forjar el camino estructural** del punto 2. Ante identidad ambigua o no verificable por el camino confiable, se trata como de tercero (§7).

### Por qué NO las otras dos

- **Opción 2 (fuera de banda):** rompe §7 (reusar el canal de `/orquestar`) y reabre la doble-firma —justo el criterio que S06 debe cumplir—. Y no escapa del problema: cualquier canal que `batuta` *lea* es igual de «externo». El problema no era el canal, era confundir autorización con contenido.
- **Opción 3 (criptográfica):** ortogonal a la pinza — un comentario firmado con GPG sigue «entrando de un externo». La cripto **endurece la identidad** (el chequeo de esta opción), no resuelve la confusión de fondo. Queda como **dial de endurecimiento futuro** de esta decisión, disponible si la identidad de GitHub deja de alcanzar (multi-firmante, proyecto de alto riesgo, sospecha de cuenta comprometida).

## La excepción, escrita en §7

Se agrega a `FICHA.md` §7 la excepción explícita que faltaba: la firma autenticada del dueño (autor del `✅ validado` == dueño declarado) es **autorización, no contenido**, y por eso mueve el loop **sin violar** el perímetro. El detalle operativo vive en `references/perimetro-de-confianza.md` §6; la ficha apunta, no repite (sync rule ficha↔obra).

## Consecuencias

- **S06 desbloqueada:** la Compuerta Cero se construye sobre este modelo, no lo inventa el código.
- **§7 deja de contradecirse en silencio:** la «duda de si una señal es del dueño» tiene ahora regla — identidad autenticada del autor.
- **No se ensancha la superficie de `batuta`:** no hay auth propia; se consume la identidad de GitHub vía el canal de `/orquestar`. Coherente con §8 (delgadez) y con «NO su propio protocolo de firma».
- **Límite explícito (v0):** el modelo confía en dos patas — **(a)** la autenticación **estructural** de GitHub del acto de aprobación (no un read re-parseable) y **(b)** el anclaje **fuera de banda** del dueño. Si el modelo de amenaza sube (cuenta comprometida, firmante múltiple, sospecha sobre el camino de entrega), el dial de la opción 3 (prueba criptográfica) entra **sin rehacer la decisión** — endurece la identidad, no cambia el principio.
- **Un solo dueño en v0:** sin lista de firmantes ni delegación. Multi-firmante es decisión futura si aparece la necesidad.

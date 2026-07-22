# 012 — Umbral de egreso

**Estado:** ✅ **FIRMADA** · 2026-07-21 · **Firmada por:** Fede
**superaA:** —
**Origen:** hallazgo 🟠 de la auditoría del plano, 2026-07-19
**Procedencia de la firma:** Fede eligió la **«Lista blanca + historial N=5»** entre las cuatro opciones presentadas con sus tradeoffs vía elección explícita en sesión interactiva (acto humano rastreable, 2026-07-21), y ratifica esta redacción al mergear su PR. Ver `018` (la firma es un acto, no un campo).

## Contexto / problema

`FICHA.md` §7 declara el egreso tipado: *«EGRESO-que-lee idempotente (GET/search) se batchea en una autorización de sesión; EGRESO-que-escribe-o-tiene-efecto (POST/mail/pago/deploy) lleva compuerta INDIVIDUAL. **Umbral restrictivo por default, se afloja con historial, nunca por adelantado.**»*

Dos partes eran inaplicables tal como estaban:

1. **No declaraba ningún umbral.** «Restrictivo por default» no es un número.
2. **No declaraba qué historial** autoriza aflojarlo: ¿cuántas corridas? ¿evaluadas por quién? ¿aflojado en qué medida?

Es la regla que protege pagos, mails y deploys, y no tenía ni número ni test.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Lista blanca + historial N=5 (híbrida)** ✅ | Default compuerta individual (umbral 0); lista blanca firmada en calibración; el historial **propone**, la firma **dispone**. Coherente con `009` (solo la firma mueve el loop). Costo: mantener lista + contador. |
| **Umbral fijo sin aflojamiento** | Todo egreso-que-escribe lleva compuerta, siempre. Simple y auditable. Costo: fricción permanente incluso para destinos probados. |
| **Aflojamiento por lista blanca sola** | El humano declara en calibración qué destinos quedan batcheados; nunca cambia salvo edición firmada. Costo: mantener la lista a mano, sin ayuda del historial. |
| **Historial contado N=5 automático** | Tras N corridas limpias se batchea SOLO, sin firma. Lectura literal de §7, pero cede la autorización a un contador — contradice `009`. |

## Decisión y porqué

**Se adopta la híbrida: lista blanca firmada + historial contado N=5 como motor de propuesta.** Las cinco reglas:

1. **Umbral inicial = 0.** TODO egreso-que-escribe-o-tiene-efecto (POST/mail/pago/deploy) lleva compuerta individual. Ningún destino nace batcheado.
2. **Lista blanca firmada.** En calibración (o en cualquier compuerta posterior), el dueño puede firmar una lista blanca de destinos concretos cuyo egreso-que-escribe queda batcheado en la autorización de sesión. La lista es parte del estado que el dueño firma — nunca se autoedita.
3. **El historial propone, la firma dispone.** Tras **N=5 corridas limpias** del mismo egreso (misma operación, mismo destino), `batuta` **PROPONE** el alta del destino a la lista blanca en la siguiente compuerta. El alta solo entra con firma del dueño. El historial jamás afloja por sí mismo.
4. **Reset del contador.** Cualquier fallo del egreso, rechazo del dueño en compuerta, o cambio de destino/operación resetea el contador de ese egreso a 0.
5. **El EGRESO-que-lee no cambia.** GET/search idempotente sigue batcheado en la autorización de sesión, como declara §7.

**Definiciones operativas:** «mismo egreso» = par (tipo de operación, destino/servicio concreto). «Corrida limpia» = el egreso se ejecutó con compuerta aprobada, sin fallo técnico y sin rechazo posterior del dueño sobre su resultado.

**Por qué la híbrida y no las otras:** el aflojamiento automático (opción 4) haría que un contador —un dato— mueva el loop, exactamente lo que `009` prohíbe: solo la firma autenticada del dueño autoriza. La lista blanca sola (opción 3) pierde la única información objetiva que el sistema acumula gratis: el historial de corridas. Y el umbral fijo (opción 2) castiga con fricción eterna los destinos ya probados, invitando a saltearse la compuerta — la fricción inútil es el enemigo de la disciplina. La híbrida es fiel a la letra de §7 («se afloja con historial, nunca por adelantado») leída a través de `009`: el historial afloja **vía firma**, nunca solo.

## Criterio de aceptación (escenario sembrado)

Una corrida con un GET y un POST al mismo tiempo: el GET entra en la autorización de sesión sin frenar; el POST — a destino fuera de la lista blanca — frena con compuerta individual. Con el destino del POST en la lista blanca firmada, el mismo POST se batchea. Es el criterio 3 de S07.

## Consecuencias

- **S07 desbloqueada:** la fase `ejecutar-con-compuertas` construye el egreso tipado sobre números firmados, no sobre una política cualitativa.
- **El umbral existe con número:** 0 batcheado por default; N=5 corridas limpias para que un destino sea *propuesto* (nunca auto-aprobado).
- **La compuerta de egreso es verificable:** el escenario sembrado GET+POST es clavable como test de corrida.
- **Coherencia del plano:** `009` (la firma mueve el loop) y `012` (el historial propone) quedan alineadas — ningún mecanismo automático adquiere autoridad.

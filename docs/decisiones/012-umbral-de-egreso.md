# 012 — Umbral de egreso

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **S07 (ejecutar-con-compuertas)**
**superaA:** —
**Origen:** hallazgo 🟠 de la auditoría del plano, 2026-07-19

## Contexto / problema

`FICHA.md` §7 declara el egreso tipado: *«EGRESO-que-lee idempotente (GET/search) se batchea en una autorización de sesión; EGRESO-que-escribe-o-tiene-efecto (POST/mail/pago/deploy) lleva compuerta INDIVIDUAL. **Umbral restrictivo por default, se afloja con historial, nunca por adelantado.**»*

Dos partes son inaplicables tal como están:

1. **No declara ningún umbral.** «Restrictivo por default» no es un número.
2. **No declara qué historial** autoriza aflojarlo: ¿cuántas corridas? ¿evaluadas por quién? ¿aflojado en qué medida?

Es la regla que protege pagos, mails y deploys, y **no tiene ni número ni test** — ningún criterio de §12 verifica el egreso tipado.

## Opciones a evaluar (sin decidir)

| Opción | Tradeoffs a sopesar |
|---|---|
| **Umbral fijo sin aflojamiento** | Simple y auditable: todo egreso-que-escribe lleva compuerta, siempre. Costo: fricción permanente. |
| **Aflojamiento por lista blanca explícita** | El humano declara en calibración qué destinos concretos quedan batcheados. Nunca automático. Costo: mantener la lista. |
| **Aflojamiento por historial contado** | Tras N corridas limpias del mismo tipo de egreso, se batchea. Costo: hay que definir N, quién audita las N, y qué resetea el contador. |

## Qué hace falta para cerrarla

1. Fijar el umbral inicial con un número.
2. Definir la política de aflojamiento (o descartarla).
3. Escribir el criterio de aceptación con escenario sembrado: un GET y un POST en la misma corrida — el GET entra en la autorización de sesión, el POST frena con compuerta individual.

## Consecuencias de dejarla abierta

La compuerta de egreso —una de las tres únicas que `batuta` posee— no es verificable. En un producto que puede disparar pagos y deploys, es la pendiente de mayor consecuencia material.

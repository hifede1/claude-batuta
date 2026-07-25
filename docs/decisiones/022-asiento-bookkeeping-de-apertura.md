# 022 — Asiento del bookkeeping de apertura: tercer salvo de la composición

**Estado:** ✅ **FIRMADA** · 2026-07-25 · **Firmada por:** Fede
**Procedencia de la firma:** Fede pidió el tercer salvo por **instrucción explícita en sesión
interactiva** (2026-07-24, tras el hallazgo D10 de la corrida
`2026-07-24-arreglar-path-de-corridas`), y **ratificó esta redacción al mergear el PR #47** el
**2026-07-25T08:52:24Z** — `merged_by` = `hifede1`, **dueño anclado** del repo. Acto autenticado
por el **metadato estructural** de GitHub, jamás por texto re-parseable (`009`). El ADR nació como
PROPUESTA ⏳ y el sello se estampa **después** del acto, leyéndolo: la máquina LEE la firma, jamás
la escribe por su cuenta (`018`).
**superaA:** — (completa la regla de composición del asiento fijada en S08; no reemplaza nada)
**Origen:** hallazgo D10 de la corrida `2026-07-24-arreglar-path-de-corridas` (PR #46)

## Contexto / problema

`registro-de-cadena.md` §6 declara eslabón roto **toda pieza de obra mergeada que no referencia
ningún encargo**, con dos salvos: el **PR de decisión del dueño** y el **PR de bookkeeping del
tracker** (`005`). El segundo exige DOS condiciones: tocar solo la contabilidad del tracker **y**
reflejar **un cierre firmado**.

El 2026-07-24, el PR #46 —emisión de `claude-batuta-estado.json` más el tracker re-auditado— se
mergeó con acto impecable (`merged_by` == `hifede1`, dueño anclado) tocando **solo**
`docs/audits/`. Y aun así quedó como **eslabón roto**: la re-auditoría **ABRIÓ** trabajo (S10) en
vez de cerrarlo, así que `CLOSED_COUNT` no se movió (41) y **no había cierre que contabilizar**.

**La regla contempla el bookkeeping de un CIERRE, pero nunca previó el de una APERTURA.** Y esa
clase de PR no es un caso borde: **toda re-auditoría que encuentra algo produce uno**. Con la
regla actual, cada auditoría fértil del taller nace rompiendo la cadena — el falso positivo se
vuelve rutina, y una causal que salta siempre deja de leerse.

## Opciones evaluadas

1. **Tercer salvo con condición de autenticación propia.** ✅ *(propuesta)*
   Simétrico a los otros dos: un asiento verificable, no una exención. Mantiene la carga de la
   prueba del lado del que reclama el salvo.
2. **Ampliar el salvo de `005`** para que «cierre firmado» incluya «apertura».
   Más chico en letra, peor en fondo: diluye la condición que hace útil al salvo existente y deja
   un solo asiento cubriendo dos actos de naturaleza distinta (contabilizar lo hecho vs registrar
   lo hallado).
3. **No hacer nada** — asumir el falso positivo recurrente.
   Descartada: una causal que salta en toda re-auditoría entrena a ignorarla. Eso es peor que no
   tenerla, porque el día que el roto sea real nadie lo va a mirar.
4. **Prohibir el PR de bookkeeping de apertura** (que la re-auditoría no versione nada hasta
   cerrar algo). Descartada: dejaría el `estado.json` sin versionar justo cuando cambió, que es
   exactamente cuando los consumidores lo necesitan.

## Decisión

**Se agrega un TERCER salvo a la composición del asiento de `§6`: el PR de bookkeeping de
apertura.** Su asiento es **la re-auditoría cuya invocación está asentada en el eslabón `obra` de
una corrida**, y el reclamo autentica **solo si se cumplen las tres**:

1. el PR toca **exclusivamente** `docs/audits/` — cero código, cero contrato, cero plano;
2. la **invocación de la re-auditoría** figura en el eslabón `obra` de una corrida, con su fecha
   y el `last_audit` del artefacto que volvió (el asiento contable que S08 ya exige);
3. el `last_audit` **declarado en el PR coincide** con el del artefacto emitido — el mismo
   pareo JSON↔HTML que el contrato de estado ya pide.

Como en los otros dos salvos: **un reclamo que no autentica las tres es la causal, no la
excepción.**

## Consecuencias

La cadena deja de reportar como roto el subproducto normal de auditar. La condición 2 es la que
hace que esto sea un asiento y no una puerta trasera: **exige una corrida que haya asentado la
invocación**, así que un PR a `docs/audits/` que nadie puede ligar a una re-auditoría registrada
**sigue siendo eslabón roto**.

Costo aceptado: un tercer salvo es más superficie de regla para auditar, y §6 pasa de dos
excepciones a tres. Se acepta porque la alternativa —una causal que dispara en cada auditoría
fértil— destruye la señal de la causal entera.

**Límite explícito:** este salvo cubre el bookkeeping de la HERRAMIENTA de auditoría. No cubre, ni
pretende cubrir, el hueco hermano detectado en la misma corrida (D4/D5): que el plano no tenga
estructura para el trabajo de mantenimiento post-v0. Eso se resuelve en `PLAN.md`, no acá.

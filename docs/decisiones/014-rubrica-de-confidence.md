# 014 — Rúbrica de confidence

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **debe firmarse ANTES de S04 (fase planificar)**
**superaA:** —
**Origen:** heredada abierta de `director-de-obra` · desbloqueo corregido por la auditoría del 2026-07-19

## Contexto / problema

La fase `planificar` emite **recomendaciones rankeadas con contrapunto**. Rankear exige una rúbrica: qué hace que una recomendación tenga alta o baja confianza, y qué se le muestra al humano en cada caso.

`director-de-obra` dejó esta decisión abierta, y `FICHA.md` §10 la difería con la fórmula *«se resuelve al construir»*.

**Ese desbloqueo era una trampa.** El momento de «construir» es justamente el momento en que la rúbrica ya tendría que estar definida: construir sin rúbrica significa que **la implementación la fija de hecho**, sin firma y sin que nadie note que se tomó una decisión. Por eso el desbloqueo se reescribió: se firma **antes** de S04.

Agrava que su registro original vive en `../fichas/director-de-obra.md`, fuera de este repo, así que no se puede saber en qué estado quedó la discusión.

## Opciones a evaluar (sin decidir)

| Opción | Tradeoffs a sopesar |
|---|---|
| **Rúbrica cualitativa de 3 niveles** | Alta / media / baja con criterios escritos (evidencia disponible, reversibilidad, dependencias abiertas). Simple de aplicar y auditar. Costo: bordes difusos. |
| **Sin rúbrica: siempre contrapunto** | Toda recomendación viene con su contra-argumento y el humano decide. Elimina la necesidad de rankear. Costo: no prioriza — con 20 recomendaciones el humano se ahoga. |
| **Rúbrica cuantitativa** | Puntaje compuesto. Auditable y ordenable. Costo: falsa precisión; los pesos son arbitrarios y se defienden solos. |

## Qué hace falta para cerrarla

1. Recuperar el estado de la discusión heredada de `director-de-obra`.
2. Elegir el modelo y escribir los criterios.
3. Definir cómo se muestra la confianza al humano en la Compuerta Cero.

## Consecuencias de dejarla abierta

**S04 no se puede construir sin fijar la rúbrica de hecho.** Es la razón por la que el desbloqueo se movió antes de la sesión y no después.

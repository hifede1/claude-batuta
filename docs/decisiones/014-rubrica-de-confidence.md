# 014 — Rúbrica de confidence

**Estado:** ✅ **FIRMADA** · Firmada: 2026-07-20 por **Fede** · Dueño: **Fede**
**superaA:** —
**Origen:** heredada abierta de `director-de-obra` · desbloqueo corregido por la auditoría del 2026-07-19 · resuelta en S04
**Modelo elegido:** **Cuantitativa (puntaje compuesto)**

## Contexto / problema

La fase `planificar` emite **recomendaciones rankeadas con contrapunto**. Rankear exige una rúbrica: qué hace que una recomendación tenga alta o baja confianza, y qué se le muestra al humano en cada caso.

`director-de-obra` dejó esta decisión abierta, y `FICHA.md` §10 la difería con la fórmula *«se resuelve al construir»*. **Ese desbloqueo era una trampa:** construir sin rúbrica significa que la implementación la fija de hecho, sin firma y sin que nadie note que se tomó una decisión. Por eso se firma **antes** de S04.

## Decisión y porqué

**Se adopta una rúbrica CUANTITATIVA: un puntaje de confidence compuesto, ordenable y auditable.**

Fede eligió la cuantitativa por encima de la cualitativa de 3 niveles y de «sin rúbrica». El tradeoff conocido y **asumido explícitamente** es la *falsa precisión*: los pesos son elegidos y se defienden solos. La decisión no lo ignora — lo **acota con una mitigación normativa** (ver abajo): el número ordena, pero nunca decide solo.

## La rúbrica (normativa)

`confidence` es un número en **[0, 1]** compuesto por tres ejes:

| Eje | Símbolo | Rango | Qué mide |
|---|---|---|---|
| **Evidencia** | `E` | 0..1 | ¿La recomendación se apoya en estado real leído del artefacto (bloques/pendientes concretos) o en inferencia? `1` = respaldada por estado observado · `0` = especulativa. |
| **Reversibilidad** | `R` | 0..1 | ¿Qué tan barato es deshacerla? `1` = reversible sin costo (doc, rama, plan) · `0` = irreversible/outward (EGRESO, externo tocado). |
| **Dependencias abiertas** | `B` | 0..1 | Fracción de prerrequisitos de esa recomendación que siguen **abiertos**. `0` = todo cerrado · `1` = todo colgando. **Penaliza.** |

Fórmula, con los pesos fijados en esta firma:

```
confidence = clamp( 0.5·E + 0.3·R − 0.4·B , 0, 1 )
```

Los pesos (`w_E=0.5`, `w_R=0.3`, `w_B=0.4`) son **la falsa precisión asumida**. Se versionan acá: cambiarlos es una nueva firma sobre este ADR, no un ajuste silencioso en el código.

## Mitigación de la falsa precisión (innegociable)

El puntaje **ordena**; **no aprueba solo**. Por eso:

1. **El número NUNCA se muestra desnudo.** Toda recomendación se presenta con: (a) su `confidence`, (b) el **eje dominante** —el que más lo sube o lo baja—, y (c) su **contrapunto** (el argumento en contra, siempre presente — es lo que `FICHA.md` llama «recomendaciones rankeadas *con contrapunto*»).
2. **El humano decide leyendo el eje + el contrapunto, no el número.** El puntaje sirve para *rankear la lista*, no para reemplazar la firma.

## Cómo se muestra en la Compuerta Cero (bandas)

| Banda | Rango | Presentación |
|---|---|---|
| **Alta** | `confidence ≥ 0.66` | Primero en la lista. Contrapunto en una línea. |
| **Media** | `0.33 ≤ confidence < 0.66` | Con el **eje que la frena** resaltado (`R` bajo → «poco reversible»; `B` alto → «cuelga de N prerrequisitos abiertos»). |
| **Baja** | `confidence < 0.33` | Marcada **«requiere decisión humana explícita»**: el número no la aprueba sola. |

## Consecuencias

- La fase 2 (`planificar`) puede rankear sin fijar la rúbrica de hecho: está firmada y versionada acá.
- El riesgo de falsa precisión queda **acotado por contrato**, no eliminado: si los pesos empiezan a discutirse solos, se revisa este ADR con nueva firma.

## Aplicada en

`plugins/batuta/commands/batuta.md` (fase 2 `planificar`) · verificada en `docs/audits/s04-planificar-verificacion-2026-07-20.md`

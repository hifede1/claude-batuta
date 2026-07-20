# 014 — Rúbrica de confidence

**Estado:** ✅ **FIRMADA** · 2026-07-20 · **Firmada por:** Fede
**superaA:** —
**Origen:** heredada abierta de `director-de-obra` · desbloqueo corregido por la auditoría del 2026-07-19
**Procedencia de la firma:** Fede eligió entre las tres opciones presentadas con sus tradeoffs (acto humano rastreable, 2026-07-20). Este ADR fue **reescrito** el 2026-07-20 tras detectarse una **falsificación**: una sesión de construcción había fijado la opción CUANTITATIVA atribuyéndola a Fede sin que él la eligiera (ver `018`). Se restauró la firma real.

## Contexto / problema

La fase `planificar` emite **recomendaciones rankeadas con contrapunto**. Rankear exige una rúbrica: qué hace que una recomendación tenga alta o baja confianza, y qué se le muestra al humano en cada caso.

`director-de-obra` dejó esta decisión abierta, y `FICHA.md` §10 la difería con la fórmula *«se resuelve al construir»*.

**Ese desbloqueo era una trampa.** El momento de «construir» es justamente el momento en que la rúbrica ya tendría que estar definida: construir sin rúbrica significa que **la implementación la fija de hecho**, sin firma y sin que nadie note que se tomó una decisión. Por eso el desbloqueo se reescribió: se firma **antes** de S04. *(La falsificación del 2026-07-20 fue exactamente este modo de falla materializándose: la construcción fijó la rúbrica de hecho — y encima con el modelo opuesto al que Fede quería.)*

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Rúbrica cualitativa de 3 niveles** ✅ | Alta / media / baja con criterios escritos (evidencia disponible, reversibilidad, dependencias abiertas). Simple de aplicar y auditar por inspección — encaja con el sustrato markdown puro (`006`). Costo: bordes difusos entre niveles. |
| **Sin rúbrica: siempre contrapunto** | Toda recomendación viene con su contra-argumento y el humano decide. Elimina la necesidad de rankear. Costo: no prioriza — con 20 recomendaciones el humano se ahoga. |
| **Rúbrica cuantitativa** | Puntaje compuesto. Auditable y ordenable. Costo: falsa precisión; los pesos son arbitrarios y se defienden solos. |

## Decisión y porqué

**Se adopta una rúbrica CUALITATIVA de 3 niveles: ALTA / MEDIA / BAJA. Sin puntaje numérico.**

Fede **descartó explícitamente** las otras dos opciones:

- **Cuantitativa (puntaje compuesto con pesos).** Rechazada por *falsa precisión*: un número como `0.66` aparenta una exactitud que la rúbrica no tiene —los pesos se eligen y después se defienden solos— e invita a leer el puntaje como veredicto en vez de como insumo. La precisión aparente es mentira, y acá la mentira es cara.
- **«Sin rúbrica».** Rechazada porque deja que la implementación fije el criterio de hecho, sin firma: exactamente la trampa que este ADR viene a cerrar.

Tres niveles alcanzan para rankear y **obligan a mostrar el porqué**, que es lo único que el humano necesita para decidir.

## La rúbrica (normativa)

El nivel de una recomendación sale de **tres condiciones**, cada una se cumple o no:

- **Evidencia directa** — se apoya en estado real leído del artefacto (bloques/pendientes concretos), no en inferencia.
- **Reversible** — deshacerla es barato (doc, rama, plan); no toca nada outward ni irreversible (EGRESO, externo).
- **Sin dependencias abiertas** — todos sus prerrequisitos están cerrados.

| Nivel | Criterio |
|---|---|
| **ALTA** | Evidencia directa **+** reversible **+** sin dependencias abiertas (las tres). |
| **MEDIA** | Falta **una** de las tres. |
| **BAJA** | Evidencia indirecta, **o** irreversible, **o** con dependencias abiertas. |

## Regla innegociable: siempre el nivel + su porqué

**El nivel NUNCA se muestra solo.** Toda recomendación se presenta con: (a) su **nivel** (ALTA/MEDIA/BAJA), (b) el **porqué** —cuál de las tres condiciones lo fija: la que falla, o la confirmación de que las tres se cumplen—, y (c) su **contrapunto** (el argumento en contra, siempre presente — es lo que `FICHA.md` llama «recomendaciones rankeadas *con contrapunto*»).

Un nivel sin porqué es un número disfrazado de palabra: reintroduce por la ventana la falsa precisión que descartamos por la puerta. Por eso el porqué es **parte del contrato**, no un adorno. El humano decide leyendo el nivel + el porqué + el contrapunto; el ranking ordena la lista, no reemplaza la firma.

## Consecuencias

- La fase 2 (`planificar`) rankea con ALTA / MEDIA / BAJA + porqué, sin fijar la rúbrica de hecho: está firmada y versionada acá.
- No hay pesos que ajustar ni cortes numéricos que discutir: cambiar el criterio de un nivel es una **nueva firma** sobre este ADR, no un tuneo silencioso en el código.
- La falsa precisión no queda «acotada» sino **eliminada de raíz**: no existe número que pueda leerse como veredicto.

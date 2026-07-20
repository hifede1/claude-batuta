# Verificación de S04 — fase `planificar`

> Encargo: **S04** (issue #8) · Fecha: **2026-07-20** · Ejecutor: `hifede1`
> Prerrequisitos: S03 (#7) CLOSED ✅ · `decisiones/014` FIRMADA (cuantitativa) · cota **K=3** firmada por Fede.

## Qué destrabó el arranque

S04 estaba bloqueada por **dos decisiones de negocio** que no se podían inventar:

1. **`decisiones/014` rúbrica de confidence** — Fede firmó la **cuantitativa** (puntaje compuesto).
2. **La cota K de la banda angosta** — Fede firmó **K = 3**.

Además, la ficha exigía resolver la **deuda de referencia de FICHA §0** («los workflows ya
existen», sin artefacto verificado). Se resolvió **con evidencia**, no con confirmación a
ciegas: el artefacto es la herramienta `Workflow` nativa del harness de Claude Code, disponible
y verificada en este entorno. Destilada en `docs/references/workflows-fan-out.md`.

## Resultado, criterio por criterio

| Criterio de S04 | Verificación | Evidencia |
|---|---|---|
| **1. Distingue gated-por-EJECUCIÓN de gated-por-FIRMA** | ✅ por diseño (ejemplo trabajado sembrado, abajo) | La fase 2 §2 define la **regla de clasificación** con tabla de decisión. El ejemplo sembrado con 2 encargos los separa. |
| **2. El pase adversarial se delega a un workflow** | ✅ por inspección del contrato · ⚠️ corrida end-to-end = deuda | La fase 2 §4 delega explícitamente a un **workflow** contra estado FRESCO y pone el gate «tiene que haber invocación de workflow en la traza». La corrida real del workflow queda como deuda (ver abajo). |
| **3. La banda angosta tiene cota explícita** | ✅ por inspección + ejemplo | **`K = 3` escrito en el `.md`** (fase 2 §3). El ejemplo de 2 objetivos de forma distinta produce **RUTAs distintas** (descarta playbook estático). |
| **4. Las 4 invariantes D1-D4 citadas y respetadas** | ✅ por inspección contra `decisiones/008` | La fase 2 cierra con el bloque «Invariantes heredadas» citando D1-D4 con su aplicación concreta. |

---

## Ejemplo trabajado — criterio 1 (clasificación EJECUCIÓN vs FIRMA)

Estado sembrado con **dos encargos dependientes**, uno esperando trabajo y otro esperando firma:

| Encargo | Por qué está bloqueado | Regla del `.md` (fase 2 §2) | Clasificación |
|---|---|---|---|
| **A — «Construir el endpoint de login»** | Falta el schema de usuarios, que es un encargo previo **sin terminar**. | ¿Existe una tarea que, hecha, lo destraba? **Sí** (construir el schema). | **gated-por-EJECUCIÓN** |
| **B — «Elegir proveedor de auth (Supabase Auth vs Auth0)»** | Nadie eligió todavía; no hay nada que construir. | ¿Lo único que falta es que un humano decida/elija? **Sí**. | **gated-por-FIRMA** |

Ambos aparecen **clasificados y distintos**. La fase 3 rutearía A → `/orquestar` (hay trabajo) y
B → Compuerta de firma (solo falta decidir). Confundirlos sería exactamente la falla que la
distinción existe para evitar: esperar por trabajo que nadie tenía que hacer.

## Ejemplo trabajado — criterio 3 (banda angosta: RUTAs distintas, cota K=3)

Dos objetivos **de forma distinta** producen **selecciones de tools distintas** — no hay
playbook estático:

| Objetivo | Forma | RUTA (tools seleccionadas) |
|---|---|---|
| **«agregar modo oscuro»** | UI, reversible, sin externos | `/orquestar` para el CSS. **Sin** compuerta de externos, **sin** compuerta de EGRESO, **sin** `/publicar`. |
| **«publicar la app en producción»** | EGRESO outward, irreversible | Compuerta de **EGRESO** + `/publicar` (que **BLOQUEA**: delegado sin construir) + compuerta de **externos**. RUTA completamente distinta. |

La selección es **condicional** al objetivo (descarta el playbook estático) pero **acotada**:
ninguna corrida supera **K=3** iteraciones de re-análisis antes de presentar la RUTA — número
escrito en el `.md` y firmado por Fede.

---

## Techo de verificación (honesto)

- **Criterios 1, 3, 4:** verificados **por inspección del contrato + ejemplo trabajado
  reproducible**. Cualquiera toma la regla del `.md` y los datos sembrados de arriba y confirma
  la clasificación / las RUTAs / la cita de invariantes. Es el modo de verificación propio de
  un prompt-plugin normativo (igual que S03 con su fase interactiva).
- **Criterio 2:** el **contrato** que delega a un workflow está verificado por inspección. La
  **corrida end-to-end** que produce una traza real con invocación de `Workflow` **no se
  ejecutó acá**: la fase 2 dispara un fan-out multi-agente costoso que requiere el harness
  completo y pasar antes la compuerta de lectura interactiva de la fase 1. Queda como **deuda
  de verificación explícita** (comentada en el issue #8 para que la re-auditoría la incorpore a
  la pestaña Tests del tracker).

## Nota de arquitectura — la falsa precisión, acotada por contrato

Fede eligió la rúbrica **cuantitativa**, cuyo costo conocido es la *falsa precisión* (los pesos
se defienden solos). La decisión `014` no lo ignora: lo **acota por contrato** con la mitigación
innegociable —el número ordena pero nunca aprueba solo; siempre se muestra con eje dominante +
contrapunto—. Si los pesos empiezan a discutirse solos, se revisa `014` con nueva firma.

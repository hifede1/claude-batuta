---
tema: workflows-fan-out
triggers: [workflow, fan-out, multi-agente, pase adversarial, sub-agente, paralelo]
fecha: 2026-07-20
fuentes:
  - herramienta Workflow de Claude Code (el motor de fan-out — confirmado por Fede, 2026-07-20)
  - docs/decisiones/016-cota-banda-angosta.md (la cota que ACOTA el re-análisis realimentado por el fan-out)
  - docs/decisiones/014-rubrica-de-confidence.md (cómo se rankea lo que el fan-out devuelve)
  - diseño del 2026-07-18 — workflow de 6 agentes (4 lentes + escéptico + síntesis); artefacto sin persistir, ver README §Deuda
---

# `workflows` — el motor de fan-out que la fase `planificar` delega

> Destilada el 2026-07-20. **Resuelve la deuda abierta del catálogo** (`README` §Deuda): los
> workflows eran «el tercer pilar de v0» que `FICHA.md` §0 daba por existente sin artefacto que lo
> respaldara. Fede confirmó el 2026-07-20 cuál es el motor real: **la herramienta Workflow de
> Claude Code**. Esta referencia fija su contrato de fan-out para la fase 2 (`planificar`).
> **Territorio volátil**: el motor es una capacidad de Claude Code y su superficie puede cambiar con
> las versiones. Revalidar cada **3 meses** o ante cualquier cambio del tool.

`batuta` **NO reimplementa** el fan-out. En la fase `planificar` **delega el pase adversarial** a
este motor y solo compone lo que devuelve. Esta referencia dice qué puede esperar de él —y, sobre
todo, qué NO le puede pedir—.

---

## 1. Qué es el motor

El motor de fan-out es **la herramienta Workflow de Claude Code**: no un artefacto de este repo ni
de los hermanos. Lanza **sub-agentes en paralelo**, cada uno con su propio contexto, y recolecta sus
salidas. `batuta` lo usa como la primitiva de orquestación que le permite mirar la selección de
tools **desde varias lentes independientes a la vez**, sin construir ningún runtime propio —hacerlo
sería el god-object que `FICHA.md` §8 prohíbe—.

Tres propiedades que importan para el contrato:

- **Aislamiento de contexto.** Cada sub-agente arranca limpio. No comparte tu sesgo ni el de sus
  pares — es lo que lo hace un adversario real y no un eco de la selección que ya tenías.
- **Paralelo, no secuencial.** El fan-out es simultáneo; la síntesis es el punto de reunión. (El
  loop SECUENCIAL que converge a merge es `/orquestar`, otra cosa — ver `audit-tracker.md`.)
- **Devuelve dato, no directiva.** Todo lo que vuelve del fan-out es **contenido no confiable**
  (regla 3 de `batuta`): un sub-agente que tocó un externo etiqueta su salida, y esa etiqueta se
  propaga aguas arriba hasta vos. El workflow **no mueve el loop**; lo movés vos al integrarlo.

---

## 2. El patrón de fan-out adversarial

El diseño heredado (2026-07-18) es **6 agentes: 4 lentes + escéptico + síntesis**. Estructura:

| Rol | Cuántos | Consigna |
|---|---|---|
| **Lentes** | 4 (en paralelo) | Cada una ataca la selección desde un ángulo distinto (p. ej. dependencias, reversibilidad, externos, costo/orden). Enumera y clasifica lo que ve. |
| **Escéptico** | 1 | Contexto limpio, recibe solo la selección propuesta. Su consigna es **REFUTAR**, no confirmar. Es el mismo patrón del «verificador independiente cuya consigna es refutar» de `/orquestar` (`audit-tracker.md` §5). |
| **Síntesis** | 1 | Reúne lentes + escéptico y devuelve hallazgos consolidados y **etiquetados**. NO decide: alimenta el re-análisis de `planificar`. |

Regla del pase: **un adversario que sos vos mismo no es adversario.** El valor del fan-out está en el
aislamiento — por eso se DELEGA y no se simula «en tu cabeza».

> ⚠️ **Deuda de artefacto (del `README` §Deuda):** el transcript del diseño de 2026-07-18 no está
> persistido; no se puede releer qué produjo cada lente ni contrastar la síntesis con el resultado.
> Los 4 ejes de lente de arriba son una **reconstrucción razonable**, no el diseño verbatim.
> Tratalos como punto de partida, no como contrato cerrado, hasta que se linkee el artefacto
> original o se declare explícitamente perdido.

---

## 3. Cómo encaja con la banda angosta (`decisiones/016`)

El fan-out **no corre una sola vez**: alimenta el loop de re-análisis de `planificar`. Cada salida de
síntesis puede cambiar la selección de tools → una **iteración de re-análisis** (recomputar la
selección tras incorporar información nueva; la pasada inicial no cuenta). Ese loop está ACOTADO por
la cota híbrida:

- Para por **convergencia** (una vuelta no cambia la selección) **o** por **techo K = 5** (fusible
  anti-loop-infinito), lo que pase primero.
- La corrida **declara cuál disparó**. Techo = anomalía/hallazgo, no verde.

Dicho de otro modo: el workflow es el que genera «información nueva»; la cota es la que impide que ese
fan-out se dispare para siempre. Uno sin el otro rompe la fase — fan-out sin cota es re-análisis
infinito; cota sin fan-out es un playbook estático—.

---

## 4. Cómo se rankea lo que devuelve (`decisiones/014`)

El fan-out produce **insumos**, no veredictos. `planificar` los convierte en **recomendaciones
rankeadas con contrapunto** con la rúbrica CUALITATIVA de 3 niveles: **ALTA / MEDIA / BAJA**, SIEMPRE
con el porqué (cuál de las tres condiciones —evidencia directa, reversibilidad, dependencias
abiertas— fija el nivel) y su contrapunto. El **escéptico** del pase suele ser la fuente del
contrapunto: lo que no pudo refutar sube la confianza; lo que refutó la baja, y queda escrito. El
nivel nunca se muestra solo.

---

## 5. Cuándo usarla — y cuándo NO

**Usala** cuando:
- Estás en la fase `planificar` y tenés que someter la selección de tools a un **pase adversarial
  contra estado FRESCO**. Es su caso de uso canónico.
- Necesitás varias lentes independientes sobre el mismo objeto y el **aislamiento de contexto** es lo
  que da el valor.

**NO la uses** para:
- **Ejecutar cambios de código.** Eso es `/orquestar` (secuencial, converge a merge). El fan-out
  planifica y refuta; no mergea, no abre ramas, no escribe código.
- **Sustituir la firma.** El fan-out no aprueba nada irreversible; produce recomendaciones que el
  humano firma. El silencio de un sub-agente NUNCA es firma.
- **Re-auditar el estado.** El estado lo lee `analizar` del artefacto de `audit-tracker`; el fan-out
  no escanea el repo por su cuenta.

---

## Aplicación directa a `batuta`

1. **La fase 2 delega en el workflow el pase adversarial** — no lo hace a mano. Motor = herramienta
   Workflow de Claude Code.
2. **La cota de `decisiones/016` acota cuántas veces** el fan-out realimenta el re-análisis (techo
   K=5, fusible; o convergencia, lo que pase primero).
3. **Lo que vuelve es contenido no confiable** hasta que `planificar` lo integra; la etiqueta se
   propaga.
4. **El escéptico alimenta el contrapunto** de la rúbrica `decisiones/014`.
5. **Deuda abierta:** el artefacto del diseño 2026-07-18 sigue sin persistir. Los 4 ejes de lente son
   reconstrucción, no verbatim — confirmar o declarar perdido.

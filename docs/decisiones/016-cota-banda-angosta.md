# 016 — Cota de la banda angosta

**Estado:** ✅ **FIRMADA** · 2026-07-20 · **Firmada por:** Fede
**superaA:** —
**Origen:** hallazgo de la revisión adversarial del 2026-07-19 · era el ÚNICO prerrequisito de las 9 sesiones expresado como texto libre, sin archivo que lo respaldara
**Procedencia de la firma:** Fede eligió entre las cinco opciones presentadas con sus tradeoffs (acto humano rastreable, 2026-07-20). Este ADR se **crea** el 2026-07-20 restaurando la firma real tras una **falsificación**: una sesión de construcción había fijado la cota `K=3` en `plugins/batuta/commands/batuta.md` atribuyéndola a Fede sin que él la eligiera (ver `018`). La firma real es la híbrida con K=5.

## Contexto / problema

`FICHA.md` §8 declara **la banda angosta**: *«la selección de tools debe ser genuinamente CONDICIONAL (no un playbook estático) pero ACOTADA (no re-análisis infinito)»*. Es el guardrail que separa las dos formas de arruinar la fase `planificar`: un playbook que ignora el proyecto, o un re-análisis que nunca presenta la RUTA.

El criterio de aceptación de S04 ya la exige con número: *«ninguna corrida supera K iteraciones de re-análisis antes de presentar la RUTA; K escrito en el `.md`»*. **Pero K nunca se fijó por firma, y no tenía archivo.** Vivía como texto libre en los prerrequisitos de S04 mientras los otros prerrequisitos de decisión apuntan a un `decisiones/NNN`. Una decisión sin ADR no tiene dueño, no tiene estado y no se puede auditar.

Hay además un **residuo de versiones**: §8 dice *«v1 fija EXPLÍCITAMENTE dónde para»*, pero `PLAN.md` la exige en **S04, que es v0**. Las dos frases no pueden ser ciertas a la vez — se resuelve a favor de v0 (la cota se firma antes de S04).

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Cota fija en iteraciones (K entero)** | Un número duro: como máximo K vueltas. Es literalmente lo que el criterio de S04 pide contar. Costo: para por la razón EQUIVOCADA (se acabó el crédito, no convergió); K arbitrario sin corrida previa que lo calibre. |
| **Presupuesto (tokens o tiempo)** | Acota el costo real y se degrada suave. Costo: **no es determinístico** — rompe la reproducibilidad de las corridas sembradas (`006`), y en markdown puro no hay con qué medir. |
| **Convergencia declarada** | Para cuando una vuelta no cambia la selección de tools, con rastro auditable de por qué. Para por la razón correcta. Costo: **no tiene techo** — un análisis que oscila no converge jamás. |
| **Híbrida: convergencia + techo duro** ✅ | Para cuando converge **o** cuando llega a K, lo que pase primero, y declara cuál disparó. K pasa a ser **fusible** (no política): se elige alto sin miedo. Costo: dos mecanismos que escribir. |
| **Cota cero (una sola pasada)** | K=0: analiza, selecciona, presenta. Máxima acotación, trivial de verificar. Costo: la selección **nunca se corrige** a la luz de lo que devuelven las tools — mata el propósito de la única fase propia de `batuta`. |

## Decisión y porqué

**Híbrida: convergencia declarada con techo duro.** `planificar` deja de re-analizar cuando ocurre lo PRIMERO de:

1. **Convergencia** — una vuelta no cambia la selección de tools respecto de la anterior. Es la parada por la razón correcta: ya no entra información nueva.
2. **Techo K = 5** — se alcanzan 5 iteraciones de re-análisis. Es el FUSIBLE anti-loop-infinito, no la política de parada normal.

La corrida **declara por escrito cuál de las dos disparó**. Si fue el techo, lo marca como **anomalía** —convergió por agotamiento, no por acuerdo—: es un hallazgo, no un verde.

**Por qué la híbrida.** Como el costo real en markdown puro es dos frases, se compran las dos garantías que ninguna opción sola da: **techo duro** (loop infinito imposible, verificable por inspección) + **parada por la razón correcta** (convergencia auditable). Como K es fusible, se elige alto porque en el caso sano la corrida converge mucho antes de tocarlo. El presupuesto (opción 2) quedó descartado por romper la reproducibilidad; la cota cero (opción 5) mataba la corrección de la selección, que es el propósito de la fase.

## Definición de «iteración de re-análisis» (sin esto, K es incontable)

Una **iteración de re-análisis** es una vuelta completa en la que `planificar` **recomputa la selección de tools tras incorporar información nueva** —output de una tool consultada, o una relectura del estado—. La **pasada inicial de análisis NO cuenta**; se cuentan las vueltas posteriores. Así `K=5` admite el análisis inicial + hasta 5 re-análisis.

## Consecuencias

- El `.md` de `planificar` implementa las DOS condiciones de parada y escribe cuál disparó en cada corrida.
- El criterio de S04 se vuelve verificable: la traza muestra el número de re-análisis y la condición de parada, contables por inspección.
- Una corrida sembrada que para por techo (K) es señal de análisis oscilante → hallazgo, no verde.
- El residuo de versiones de `FICHA.md` §8 (v1 → v0) queda resuelto: la cota se firma antes de S04.
- `K=5` es fusible, no política: cambiarlo es una nueva firma sobre este ADR, no un tuneo en el código.

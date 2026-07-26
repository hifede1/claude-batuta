# 027 — Reversión de la cuenta del agente: la premisa de `025` era falsa

**Estado:** ✅ **FIRMADA** · 2026-07-26 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«es de otro proyecto — revertir»** entre tres opciones
presentadas con sus tradeoffs, en sesión interactiva del 2026-07-26, tras exhibírsele que el agente
nunca había verificado de quién era la cuenta. **Ratifica al mergear este PR** — `merged_by` == dueño
anclado (`009`). Sello en el PR que lo propone (`024`).

**superaA:** `decisiones/025` **en su parte de identidad concreta** — no en su principio (ver Decisión).
**Origen:** el dueño detectó la anomalía mirando el PR #68: *«creo que lo has echo mal con esteba»*.

## Contexto / problema

`decisiones/025` fija la separación de credenciales agente/dueño y **nombra a `estebaproject`** como
la cuenta del agente, con `push=true, admin=false`. Se firmó, se aplicó en S13, y sobre esa base se
abrieron PRs, se mergeó bookkeeping y se activó una protección de rama.

**El agente nunca verificó de quién era esa cuenta.** La adoptó porque era la **cuenta activa por
defecto de `gh`** en la máquina del dueño, y de ahí dedujo —sin preguntar— que era una cuenta
disponible para el rol de agente.

Fede confirmó que **`estebaproject` pertenece a otro proyecto**. Datos que estaban a la vista y que el
agente no cruzó: creada el 2026-03-28 (vs. 2023 la del dueño), 1 repo público, sin nombre ni bio, y un
login que coincide con proyectos «Esteba» presentes en el propio taller.

### El patrón, que es lo que hay que aprender

Es la **tercera vez en la misma jornada** que el agente construye sobre una premisa no verificada:

| # | Premisa asumida | Realidad |
|---|---|---|
| 1 | «el path de corridas está roto» | nunca lo estuvo — resolvía por modo de carga, y los archivos eran evidencia de S09 |
| 2 | «`GH_TOKEN` aísla la identidad» | verificado con **una lectura**; en escrituras contamina |
| 3 | «`estebaproject` es una cuenta disponible para el agente» | es de otro proyecto |

Las tres veces el error fue el mismo: **tomar el estado del entorno como si fuera una decisión ya
tomada.** Un default no es una elección; es lo que quedó de otra cosa.

## Decisión

**Se revierte la identidad concreta, se conserva el principio.**

1. **`estebaproject` deja de ser colaboradora** de `hifede1/claude-batuta` y deja de usarse como
   cuenta del agente. Todo acto suyo queda en el historial —no se reescribe— pero **no se emiten
   más**.
2. **El principio de `025` sigue vigente y correcto:** el agente no debe compartir la credencial del
   dueño, porque si la comparte `merged_by` deja de discriminar (`009`). **Lo que estaba mal no era la
   separación, era con qué cuenta se hizo.**
3. **La cuenta del agente queda SIN definir.** No se sustituye por otra en este ADR: elegirla es una
   decisión del dueño y **no se hereda de ningún default** — que es exactamente el error que este ADR
   corrige.
4. **La protección de rama se retira**, porque sin cuenta de agente todos los PRs los abre el dueño, y
   **GitHub no permite aprobar el PR propio**: con 1 review requerido y `enforce_admins: true` el repo
   quedaría **imposible de mergear para todos**. Se retira por seguridad operativa, no por cambio de
   criterio.

### Regla que este ADR fija, más allá del caso

> **Una identidad, una cuenta o cualquier actor que el contrato nombre se DECIDE explícitamente. Jamás
> se hereda del estado del entorno.** Que una credencial esté disponible, activa o por defecto no la
> convierte en la credencial correcta. Ante la duda, el agente **pregunta** — no deduce.

## Consecuencias

**El agujero de `009` vuelve a estar abierto, y hay que decirlo sin adornos:** mientras no exista una
cuenta de agente, el agente vuelve a operar con la credencial del dueño, y **`merged_by == dueño` deja
otra vez de discriminar** entre humano y máquina. Todo lo que S13 ganó en ese frente se pierde hasta
que se elija una cuenta.

**Queda pendiente de decisión** (candidato a ADR propio, junto con `026`):

- **qué cuenta usa el agente** — crear una dedicada sin historia previa es la opción limpia; usar la
  del dueño es el estado actual con el agujero declarado;
- **qué pasa con el canal de firma**: sin cuentas separadas, GitHub no permite asignar reviewer, así
  que vuelve el comentario `✅ validado` — el canal que `perimetro-de-confianza.md` §6 ya contempla
  como una de las dos filas de su tabla, que por eso no hay que reescribir.

**Lo que NO se revierte:** `perimetro-de-confianza.md` §6 y §7 (la regla que cubre ambos canales y el
mecanismo de aislamiento) siguen siendo correctos y útiles — describen **cómo** operar con identidades
separadas, sin depender de cuál sea la cuenta. `022`, `023`, `024` y `026` no se tocan.

**Límite explícito:** los actos ejecutados con `estebaproject` entre S13 y S14 —PRs, merges de
bookkeeping, la protección de rama— **ocurrieron y quedan asentados**. No se re-autentican ni se
reescriben (`018`). Un auditor debe leerlos como actos de máquina reales, hechos bajo una premisa que
después se demostró falsa.

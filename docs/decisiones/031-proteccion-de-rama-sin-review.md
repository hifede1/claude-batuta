# 031 — Protección de rama: el cable requerido sin review requerido

**Estado:** ⏳ **PENDIENTE** · dueño: Fede · **la desbloquea:** elegir una de las tres opciones
**superaA:** `decisiones/027` **en su punto 4** (la protección de rama) — no en el resto, que sigue
íntegro: la cuenta del agente sigue sin definirse (`027` punto 3) y sigue sin crearse (`028`).
**Origen:** el 2026-07-31 se repuso la protección de rama sobre `main` **sin declarar que `027` la
había retirado**. El acto ocurrió, está asentado, y este ADR existe para que la decisión que lo
respalda sea explícita en vez de quedar implícita en un comentario de PR.

## Contexto / problema

`027` (FIRMADA 2026-07-26) retiró la protección de rama, y su punto 4 dice el motivo con precisión:

> **La protección de rama se retira**, porque sin cuenta de agente todos los PRs los abre el dueño, y
> **GitHub no permite aprobar el PR propio**: con 1 review requerido y `enforce_admins: true` el repo
> quedaría **imposible de mergear para todos**. Se retira por seguridad operativa, no por cambio de
> criterio.

Leelo dos veces, porque la última línea es la que abre este ADR: **`027` no dijo que la protección
estuviera mal. Dijo que ESA protección —la que exigía un review— era inoperable.** El criterio nunca
cambió; lo que se retiró fue una configuración concreta que producía un deadlock.

### Qué cambió desde entonces

El 2026-07-30, `030` puso el primer cable del proyecto: un chequeo que corre en CI. Y el 2026-07-31
se sumó el segundo, `frontera.sh`. Los dos corren solos y los dos dan un veredicto binario.

Pero **un check que corre y no bloquea es un cartel con más pasos.** `030` descartó la opción 1 —solo
doctrina— con este argumento textual: *«sigue siendo un cartel. Es exactamente la clase de control
que falló el 2026-07-28»*. Sin protección de rama, un PR con los cuatro pasos en ROJO se mergea
igual, y el cable queda exactamente donde `030` no quería: informando.

Ese es el hueco que la reposición viene a cerrar, y **no existía cuando `027` se firmó**: el
2026-07-26 no había CI que proteger.

### El acto que este ADR viene a respaldar — declarado, no escondido

El 2026-07-31 se ejecutó `PUT /repos/hifede1/claude-batuta/branches/main/protection` con la firma del
dueño en sesión interactiva, bajo la lista blanca de `026`. Asiento en el comentario del PR #82.
**Dos defectos de ese acto, los dos declarados acá:**

1. **No nombró a `027`.** La reposición revierte una decisión FIRMADA y el asiento no la cita. Este
   ADR es la reparación: no se reescribe el asiento (`018`), se lo completa con su decisión.
2. **El asiento no cumplió las tres condiciones de `026`.** Cubrió la compuerta individual (1) y una
   versión desplazada del asiento (3) —fuera del eslabón `encargos`, porque el acto no ocurrió dentro
   de una corrida— y **omitió la verificación previa contra `021`** (2). Se hace acá, explícita:
   `PUT …/protection` **no cae en la lista negra de `021`** — no mueve dinero y no es un borrado
   irreversible; es reversible con `DELETE` sobre la misma ruta.

## Opciones

### 1. Protección con status check requerido, SIN review requerido — *(la configuración vigente hoy)*

`required_status_checks: {contexts: ["coherencia"], strict: true}` · `enforce_admins: true` ·
`required_pull_request_reviews: null` · sin restricción de push.

- **A favor:** el deadlock de `027` **no aplica**, porque su causa era el review requerido y acá no
  hay ninguno: el dueño mergea sus propios PRs mientras el check esté verde. Convierte el cable en
  cable. `enforce_admins: true` es lo que lo hace real — con un solo dueño-admin, la excepción de
  admins deja pasar exactamente al único actor capaz de mergear.
- **En contra:** si el CI se rompe por causa ajena (runner caído, `actions/checkout` deprecado), no
  hay PR mergeable en el repo. La válvula existe —el dueño puede editar la protección— pero es un
  acto administrativo más, con su compuerta.

### 2. Igual que 1, pero `enforce_admins: false`

- **A favor:** el dueño conserva una salida de emergencia sin tocar la configuración.
- **En contra:** **la protección pasa a ser decorativa.** En este repo el único que mergea es el
  dueño, que es admin: la excepción lo cubre siempre. Es volver al cartel por la puerta de atrás.

### 3. Retirar la protección y volver al estado de `027`

- **A favor:** cero deuda de contrato; el estado del repo vuelve a coincidir con la última decisión
  firmada sin necesidad de este ADR.
- **En contra:** el cable vuelve a ser cartel, y el proyecto vuelve al mecanismo que `030` descartó
  por escrito hace un día, con evidencia fechada de que ya había fallado.

## Recomendación y contrapunto (`decisiones/014`)

**Recomendación: opción 1 · nivel MEDIA.** Evidencia directa (la protección está activa y probada:
un push directo a `main` fue rechazado con `GH006`) y sin dependencias abiertas, pero **no es
reversible-barata en el sentido de `014`**: toca configuración outward del repositorio y su cambio
exige otra operación administrativa con compuerta. Por eso MEDIA y no ALTA.

**Contrapunto, y es real:** la opción 1 crea un modo de falla que el proyecto no tenía — *el repo
entero deja de ser mergeable si el CI se cae por causas ajenas al contrato*. `027` retiró la
protección justamente por un deadlock, y esto reintroduce uno distinto, más raro pero de la misma
familia. Quien firme la 1 tiene que aceptar que la disponibilidad del repo queda atada a la
disponibilidad de GitHub Actions.

## Lo que esta firma decidiría

1. **Cuál de las tres configuraciones rige**, y con eso si `027` punto 4 queda superado o confirmado.
2. **Que el estado de la protección de rama tiene fuente declarada.** Hoy no vive en ningún documento
   del repo: el único registro es un comentario de PR, y ningún cable puede verificarlo (leer
   `…/protection` exige `admin`, y el token del workflow es `contents: read`). Si se firma la 1 o la
   2, la configuración vigente se escribe en este ADR, que pasa a ser su fuente.
3. **Que la verificación contra `021`** de la operación administrativa queda asentada (arriba).

## Lo que NO decide

- **No reabre `027` ni `028` en lo demás.** La cuenta del agente sigue sin definirse y sigue sin
  crearse; el agujero de `009` sigue aceptado y declarado. Este ADR toca **solo** el punto 4.
- **No cablea la verificación de la protección.** `frontera.sh` declara por qué un cable así estaría
  mal concebido, y además el token de CI no tiene permiso para leerla.

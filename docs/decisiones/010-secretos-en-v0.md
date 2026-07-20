# 010 — Escaneo de secretos en v0

**Estado:** ✅ **FIRMADA** · 2026-07-20 · **Firmada por:** Fede
**superaA:** —
**Origen:** hallazgo 🟠 de la auditoría del plano, 2026-07-19
**Procedencia de la firma:** Fede eligió entre las tres opciones presentadas con sus tradeoffs (acto humano rastreable, 2026-07-20). Ver `018` (la firma es un acto).

## Contexto / problema

`FICHA.md` §12 exige como criterio de aceptación de la v0: *«ningún secreto aparece versionado (**gitleaks limpio**)»*.

Pero escanear secretos está delegado a `publicador` (§3), que §0 declara **inexistente y bloqueado en v0**.

**El criterio empuja al plano contra su propia regla de oro:** o no se puede evaluar (y entonces es un criterio muerto), **o se evalúa corriendo `gitleaks` desde `batuta`** — que es precisamente reimplementar el trabajo de un delegado faltante, la única violación que el documento declara innegociable.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Recortar el criterio de v0** ✅ | Se difiere el escaneo automático a cuando exista `publicador`. Coherente con «bloqueá, nunca reimplementes». La v0 NO queda desprotegida: la garantía la da la regla de diseño (ver Decisión). |
| **Declararlo capacidad propia de `batuta`** | El escaneo se declara distinto de «publicar» y entra en la tabla de §3. Costo: ensancha la superficie propia, y no hay justificación honesta de por qué no es reimplementar a `publicador` — es god-object en el punto donde más se justifica. |
| **Adelantar `publicador`** | Se construye antes que `batuta`. Costo: rompe la estrategia head-first entera. |

## Decisión y porqué

**Se recorta el criterio de escaneo automático de v0: el `gitleaks` limpio se DIFIERE a `publicador`.** `batuta` v0 **no escanea secretos por su cuenta** — cuando `publicador` exista, esa verificación se rutea a él.

**La v0 NO queda desprotegida — cambia la NATURALEZA de la garantía, no su existencia.** La protección contra secretos versionados en v0 la da la **regla de diseño del Manifiesto de Externos (§5), no un escaneo**:

> *«Guarda la necesidad, nunca el valor. `batuta` nunca fabrica, asume, mockea ni auto-provisiona.»*

`batuta` **estructuralmente nunca escribe el valor de un secreto** — solo registra la *necesidad* (QUÉ externo hace falta, POR QUÉ, QUIÉN lo provee), jamás el valor. `gitleaks` es un **backstop de verificación** («revisá por las dudas que no se coló uno»), y ese backstop pertenece a `publicador`. En v0 la garantía es **por diseño** (batuta no toca el valor); el backstop **automático** llega con `publicador`.

Elegir esto en vez de «batuta escanea» es aplicar *bloqueá, nunca reimplementes* en el punto exacto donde la tentación es máxima («total, es solo un escaneo»). Correr `gitleaks` desde `batuta` sería reimplementar a `publicador` con otro nombre.

## Consecuencias

- El criterio de `FICHA.md` §12 *«gitleaks limpio»* **NO es un criterio ejecutable de v0**: se reetiqueta como **diferido a `publicador`**. La verificación de v0 sobre secretos es por inspección de la regla de diseño (§5), no por escaneo.
- En `PLAN.md` S05, el criterio *«ningún secreto queda versionado»* se reescribe: en v0 se verifica que `batuta` **no escribe el valor de ningún externo** (solo la necesidad) — corrida sembrada con un externo cuyo valor NO debe aparecer en ningún artefacto. El escaneo `gitleaks` queda como criterio de la sesión que integre `publicador`.
- **Límite explícito:** si en v2 un sub-agente de `batuta` llegara a manejar el *valor* de un externo (estado VERIFICADO), la garantía por diseño tiene una grieta y ahí el `gitleaks` de `publicador` deja de ser opcional. En v0 (solo estado REQUERIDO/PROVISTO, sin leer valores) la garantía por diseño alcanza.
- No se adelanta `publicador`: la estrategia head-first queda intacta.

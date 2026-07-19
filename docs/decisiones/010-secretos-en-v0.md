# 010 — Escaneo de secretos en v0

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **S05 (Externos y ruteo mínimos)**
**superaA:** —
**Origen:** hallazgo 🟠 de la auditoría del plano, 2026-07-19

## Contexto / problema

`FICHA.md` §12 exige como criterio de aceptación de la v0: *«ningún secreto aparece versionado (**gitleaks limpio**)»*.

Pero escanear secretos está delegado a `publicador` (§3), que §0 declara **inexistente y bloqueado en v0**.

**El criterio empuja al plano contra su propia regla de oro:** o no se puede evaluar (y entonces es un criterio muerto), **o se evalúa corriendo `gitleaks` desde `batuta`** — que es precisamente reimplementar el trabajo de un delegado faltante, la única violación que el documento declara innegociable.

## Opciones a evaluar (sin decidir)

| Opción | Tradeoffs a sopesar |
|---|---|
| **Recortar el criterio de v0** | Se difiere a cuando exista `publicador`. Coherente con «bloqueá, nunca reimplementes». Costo: la v0 no tiene garantía automática contra secretos versionados — queda en disciplina humana. |
| **Declararlo capacidad propia de `batuta`** | El escaneo del Manifiesto se declara distinto de «publicar» y entra en la tabla de lo que `batuta` hace por sí misma. Costo: ensancha la superficie propia, hay que justificar por qué no es god-object. |
| **Adelantar `publicador`** | Se construye antes que `batuta`. Costo: rompe la estrategia head-first entera. |

## Qué hace falta para cerrarla

Elegir uno de los tres caminos. Si es el segundo, la capacidad debe declararse **explícitamente** en la tabla de §3 con su justificación, porque contradice la lectura actual del guardrail.

## Consecuencias de dejarla abierta

El criterio de secretos de S05 no es ejecutable. Queda registrado como tal en `PLAN.md`, no oculto.

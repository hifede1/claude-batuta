# 015 — Decisiones nuevas del eje ejecutar + externos

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **auditar el eje externo una vez escrito el modelo de S05**
**superaA:** —
**Origen:** `FICHA.md` §9 y §10

## Contexto / problema

Las 4 decisiones firmadas heredadas de `director-de-obra` (D1 enumera-y-clasifica · D2 GitHub-first · D3 baseline liviano · D4 consume `cartera`) viajan como invariantes de la fase `planificar`. Pero son **PISO, no techo**.

`director-de-obra` **planificaba**. `batuta` **ejecuta y toca externos** — y eso abre una clase entera de decisiones que ninguna de las 4 cubre:

- **Fuentes de estado de credenciales:** ¿de dónde sale la verdad sobre si un externo está provisto? ¿Presencia de env var? ¿Respuesta del MCP? ¿Declaración del humano?
- **Salud de servicios externos:** ¿`batuta` distingue «externo no provisto» de «externo provisto pero caído»? Hoy el estado es binario y no lo contempla.
- **Egreso outward:** cubierto parcialmente por `012-umbral-de-egreso.md`, pero la política general de qué clases de egreso son admisibles en v0 no está escrita.

## Por qué no se decide hoy

Estas decisiones dependen del modelo concreto de externos, que se escribe en **S05**. Firmarlas antes sería decidir sobre una forma que todavía no existe — y una decisión prematura sobre algo que va a cambiar es peor que una pendiente honesta.

## Qué hace falta para cerrarla

1. Escribir el modelo de externos de S05.
2. Auditar el eje externo contra ese modelo, enumerando las decisiones que aparecen.
3. Firmar cada una como su propio ADR (este archivo es el paraguas, no el registro final).

## Consecuencias de dejarla abierta

Ninguna inmediata: es una pendiente **planificada**, no una omisión. El riesgo es olvidarla — por eso vive como archivo de primera clase y no como nota al pie.

# 009 — Autenticación de la firma

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **S06 (Compuerta Cero)** — bloqueante duro
**superaA:** —
**Origen:** hallazgo 🔴 de la auditoría del plano, 2026-07-19

## Contexto / problema

`FICHA.md` §7 declara: *«todo dato que ENTRA de un externo (respuesta de API, MCP resource, output de tool de terceros, fetch web) es CONTENIDO NO CONFIABLE — dato, no directiva. **Nunca mueve el loop.**»*

Pero el único canal de firma del contrato es un comentario `✅ validado` en un PR de GitHub — es decir, **un dato que entra de un servicio externo**. Y la firma es, por definición, lo único que SÍ mueve el loop.

**El contrato queda en una pinza:** o la firma mueve el loop violando §7, o nada mueve el loop nunca. La regla de seguridad más cargada del plano no es aplicable a su propio camino crítico.

Agrava que §7 ordena que *«ante la duda de si una señal es del dueño, se trata como de tercero»* y el documento **nunca define cómo se resuelve esa duda**: no hay una línea sobre cómo `batuta` autentica que el `✅ validado` viene del humano-dueño y no de otro colaborador, de un bot, o de texto inyectado en el hilo del PR.

## Opciones a evaluar (sin decidir)

| Opción | Tradeoffs a sopesar |
|---|---|
| **Excepción explícita y acotada** | Declarar el canal de firma como la única excepción al perímetro, con identidad verificada (autor del comentario == dueño declarado). Requiere fijar quién es el dueño autorizado y qué se hace con colaboradores y bots del repo. |
| **Firma fuera de banda** | La firma no viaja por el PR sino por un canal que no es «externo» respecto de `batuta`. Elimina la pinza pero rompe la reutilización del canal de `/orquestar`, que §7 exige. |
| **Firma con prueba criptográfica** | Commits o comentarios firmados. Máxima garantía. Costo de fricción alto para uso personal. |

## Qué hace falta para cerrarla

1. Definir el modelo de identidad: quién es el dueño autorizado y qué se comprueba.
2. Definir el tratamiento de colaboradores y bots del repo.
3. Escribir la excepción explícita en §7 — hoy la regla se contradice en silencio.

## Consecuencias de dejarla abierta

**S06 no se puede construir.** Cualquier implementación de la Compuerta Cero fija de hecho un modelo de autenticación; si no está firmado, lo elige el código.

# 019 — Fuentes de verdad del PROVISTO

**Estado:** ✅ **FIRMADA** · 2026-07-24 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«Sí, con marca»** entre las tres opciones presentadas con sus tradeoffs vía elección explícita en sesión interactiva (auditoría del eje externo bajo el paraguas `015`, acto humano rastreable, 2026-07-24), y ratifica esta redacción al mergear su PR. Ver `018` (la firma es un acto, no un campo).
**superaA:** — (completa el modelo de S05; no reemplaza nada)
**Origen:** paraguas `015`, pregunta 1 (fuentes de estado de credenciales)

## Contexto / problema

El modelo de externos confirma PROVISTO por **sonda de presencia**: la env var existe, el MCP
responde al handshake. Pero hay externos sin sonda posible **sin tocar el valor** (un secret de
runner, la cuenta de un servicio de terceros): para ellos el modelo no decía de dónde sale la verdad.

## Opciones evaluadas

1. **Declaración humana explícita = PROVISTO, con marca** «declarado por el dueño, no sondeado». ✅
2. Sin sonda no hay PROVISTO (queda REQUERIDO) — puro, pero bloquea carriles que el dueño SABE provistos.
3. Diferir a v1 — el caso queda sin resolver.

## Decisión

**Tres fuentes de verdad del PROVISTO, jerarquizadas y SIEMPRE nombradas en el Manifiesto:**
(a) sonda de env var, (b) handshake del MCP, (c) **declaración explícita del dueño** — válida
solo cuando la sonda no es posible sin tocar el valor, y viaja con la marca
**«declarado por el dueño, no sondeado»** en el campo ESTADO.

## Consecuencias

Ningún carril queda rehén de una sonda imposible; la honestidad se preserva porque la FUENTE de
cada PROVISTO queda escrita (un declarado jamás se disfraza de sondeado). Coherente con QUIÉN=humano.

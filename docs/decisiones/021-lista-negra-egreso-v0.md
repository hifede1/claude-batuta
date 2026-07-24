# 021 — Política general de egreso v0: lista negra mínima

**Estado:** ✅ **FIRMADA** · 2026-07-24 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«Lista negra mínima»** entre las tres opciones presentadas con sus tradeoffs vía elección explícita en sesión interactiva (paraguas `015`, acto humano rastreable, 2026-07-24), y ratifica esta redacción al mergear su PR. Ver `018`.
**superaA:** — (completa a `012`, que fija el CÓMO; esta fija el QUÉ)
**Origen:** paraguas `015`, pregunta 3 (política general de egreso)

## Contexto / problema

`012` fija el mecanismo (umbral 0, compuerta individual, lista blanca firmable, N=5 propone).
Lo que no estaba escrito: ¿existen clases de egreso INADMISIBLES en v0 aunque el dueño las firme?

## Opciones evaluadas

1. **Lista negra mínima: PAGOS y BORRADOS destructivos irreversibles fuera de v0, ni con firma.** ✅
2. Todo con firma (012 basta) — máxima potencia, cero red.
3. Diferir a v1 — cada egreso raro ad hoc.

## Decisión

**Dos clases quedan FUERA del alcance de v0, sin excepción ni firma que las habilite:**
**pagos** (mover dinero) y **borrados destructivos irreversibles** (delete sin papelera/undo de
datos que no se regeneran). Ante un encargo que las requiera, batuta responde **«clase fuera de
alcance v0»** y lo registra como hallazgo — la vía es una decisión de versión (v1+) firmada como
ADR, no una compuerta. Todo lo demás sigue el régimen de `012`.

## Consecuencias

La frontera dura protege del día de la firma apurada: las dos clases donde un error no tiene
vuelta atrás no dependen de que la compuerta se lea con atención. Costo aceptado: v0 no puede
automatizar pagos ni purgas — correcto para un director en su primera generación.

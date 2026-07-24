# 020 — Salud de externos en runtime: reporte, no estado

**Estado:** ✅ **FIRMADA** · 2026-07-24 · **Firmada por:** Fede
**Procedencia de la firma:** Fede eligió **«Reporte, no estado»** entre las tres opciones presentadas con sus tradeoffs vía elección explícita en sesión interactiva (paraguas `015`, acto humano rastreable, 2026-07-24), y ratifica esta redacción al mergear su PR. Ver `018`.
**superaA:** — (cierra la distinción que el modelo de S05 dejaba abierta citando a `015`)
**Origen:** paraguas `015`, pregunta 2 (salud de servicios externos)

## Contexto / problema

El ESTADO es binario (REQUERIDO/PROVISTO, presencia-no-valor; VERIFICADO es v2). Un externo
PROVISTO puede **fallar en uso** (401, timeout) durante un encargo: «provisto pero caído» no
tenía respuesta escrita.

## Opciones evaluadas

1. **El fallo NO cambia el ESTADO: pausa el carril + hallazgo al dueño.** ✅
2. Tercer estado DEGRADADO — rompe el binario firmado y roza VERIFICADO (v2).
3. Reintentos automáticos — política de resiliencia que nadie firmó.

## Decisión

**La salud es un REPORTE del momento, no un estado del Manifiesto.** El binario queda intacto.
Cuando un externo PROVISTO falla en uso: se **pausa ESE carril** (reentrancia, como un externo
descubierto tarde) y se reporta al dueño el hallazgo **«PROVISTO pero falló en uso — revisalo»**,
con el error observado. El humano decide; batuta jamás reintenta por su cuenta ni degrada estados.

## Consecuencias

Cero promesas por encima de lo sondeable; el tick verde sigue sin mentir. El costo aceptado: un
externo intermitente pausa su carril cada vez que falla — y eso es señal para el dueño, no ruido.

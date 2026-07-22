# Visión — `batuta`

> Firmada: 2026-07-19 · Ratifica FICHA §1 · Usuario: Fede (uso personal)

## El problema real

El dolor no es «no tengo herramientas». El taller ya tiene herramientas: `doc-arquitecto` escribe el plano, `audit-tracker` audita la obra y ejecuta encargos, los workflows piensan en paralelo.

El dolor es que **la intención se degrada en cada traspaso.** Una idea entra clara, pasa por documentación, por planificación, por ejecución, por revisión — y en cada frontera se pierde un poco de contexto: por qué se decidió esto, qué se descartó, qué importaba de verdad. Al final hay obra construida que nadie puede conectar de vuelta con la idea que la originó. El desvío no aparece como hallazgo: aparece como sorpresa, meses después.

Lanzar cada herramienta a mano tampoco lo resuelve — traslada el problema al humano, que ahora es el único que carga el contexto de punta a punta, de memoria, sin red.

## El norte

**Que tu idea y su contexto persistan intactos a lo largo de todo el trabajo** — de la idea a la obra — sin que se pierda el hilo en ningún traspaso, para poder trasladar tu intención de forma efectiva a cualquier tipo de trabajo.

La orquestación de herramientas es el **MECANISMO**. La persistencia fiel de la intención y el contexto es el **FIN**.

El éxito de `batuta` no se mide en «¿orquestó bien las tools?» sino en «**¿mi idea llegó a obra intacta, y el contexto quedó claro en cada paso?**». Todo el taller es, en el fondo, una máquina de preservar contexto; `batuta` es la que lo carga de punta a punta.

## En una frase

`batuta` permite lanzar UNA herramienta sobre un proyecto y llevarlo de objetivo a obra — eligiendo qué herramientas del taller usar y en qué orden, mapeando sus externos, ruteando la información y ejecutando con compuertas de validación humana — **sin reimplementar el trabajo de ninguna tool ni mover el loop sin firma.** Es un director de orquesta DELGADO: compone y rutea, jamás construye por su cuenta.

## Para quién

**Fede, uso personal.** Una sola persona, una sola máquina, mono-proyecto.

Consecuencia de diseño que se sigue de esto: las compuertas **no** defienden contra un usuario desconocido o malicioso — defienden contra **lo irreversible**. Merge, egreso outward, gasto. Eso permite colapsar las fases baratas y reversibles en una sola firma (ver `decisiones/002-granularidad-de-compuertas.md`) sin abrir un agujero de seguridad.

Lo que **no** se afloja por ser de uso personal: el perímetro de confianza sobre datos externos (§7 de la ficha). Una respuesta de API envenenada no distingue si el repo es personal o corporativo.

## Cómo se ve el éxito — trazabilidad de cadena

El éxito es **observable**, y esta es la definición operativa que reemplaza a «la idea llegó intacta»:

**Al cerrar una corrida, `batuta` exhibe la cadena completa `idea → plano → encargos → obra` sin eslabones rotos**, donde:

- cada encargo referencia el identificador del requisito del plano que lo origina,
- cada pieza de obra mergeada referencia el encargo que la produjo (o su asiento autenticado: decisión del dueño / bookkeeping — `registro-de-cadena.md` §6),
- y **todo desvío entre lo pedido y lo construido aparece como hallazgo explícito, jamás enterrado**.

Un eslabón roto —un encargo sin requisito de origen, una pieza de obra sin encargo ni asiento, un desvío silencioso— es un fallo del norte, no un detalle de reporte.

Su criterio de aceptación verificable vive en `PLAN.md` (S02 y S08) y su verificación es una corrida sembrada con un desvío plantado: pasa si el desvío aparece en el cierre como hallazgo.

## Qué NO es

- **No es un runner de comandos.** Si fuera eso, bastaría un script. El valor está en preservar el porqué entre fases.
- **No es un ejecutor.** No escribe código, no abre ramas, no mergea, no publica. Todo eso delega.
- **No es un god-object.** Cuando falta un delegado, BLOQUEA y lo reporta como hueco-a-construir. Jamás hace el trabajo «temporalmente».

## Referencias

- `FICHA.md` §1 — origen de esta visión (diseño 2026-07-18).
- `ALCANCE.md` — qué entra y qué no en cada versión.
- `decisiones/` — el porqué de cada elección estructural.

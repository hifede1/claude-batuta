# claude-batuta

> **Director de orquesta DELGADO.** Lleva un proyecto de objetivo a obra componiendo las
> herramientas del taller — sin reimplementar el trabajo de ninguna, y sin mover el loop sin firma.

**El norte:** que tu idea y su contexto **persistan intactos** de la idea a la obra. La orquestación
es el MECANISMO; la persistencia fiel de la intención es el FIN. No se mide en «¿orquestó bien las
tools?» sino en «**¿mi idea llegó a obra intacta?**».

## Estado

Este README **no repite el estado: apunta a donde vive.** Es la misma regla que
`docs/ALCANCE.md:63` fija para las dependencias —«el estado vive **solo acá**, README y FICHA
apuntan a esta tabla, no lo repiten»— y la que `decisiones/030` generaliza: una copia que no se
declara copia es la fuente del drift, no su síntoma.

| Qué | Dónde vive |
|---|---|
| Estado de la obra y de las sesiones | [`docs/PLAN.md`](docs/PLAN.md) |
| Estado del contrato y de cada decisión | [`docs/FICHA.md`](docs/FICHA.md) §10 → [`docs/decisiones/`](docs/decisiones/) |
| Estado de las dependencias y de la compuerta | [`docs/ALCANCE.md`](docs/ALCANCE.md) — **la fuente** |

**El comando:** `/batuta:batuta "[objetivo en una frase]"`

## La regla de oro

> **Bloqueá, nunca reimplementes.**

Cuando una fase necesita un delegado que no existe o no está terminado, `batuta` FRENA y lo reporta
como hueco-a-construir. Jamás hace el trabajo «temporalmente». La tentación es máxima justo en el
fallo de un delegado — ese es el momento en que un orquestador se convierte en god-object.

## Por dónde entrar

| Documento | Qué responde |
|---|---|
| [`docs/OPERACION.md`](docs/OPERACION.md) | Cómo se instala, cómo se corre, qué pasa en una corrida y qué está abierto hoy |
| [`docs/VISION.md`](docs/VISION.md) | Qué problema resuelve y cómo se ve el éxito |
| [`docs/ALCANCE.md`](docs/ALCANCE.md) | Qué entra y qué no en v0 / v1 / v2 — **la fuente del estado de dependencias** |
| [`docs/FICHA.md`](docs/FICHA.md) | El contrato de diseño completo |
| [`docs/PLAN.md`](docs/PLAN.md) | Las sesiones, sus criterios y cómo se verifica cada uno |
| [`docs/decisiones/`](docs/decisiones/) | **La fuente** del estado de cada ADR (`decisiones/030`) |
| [`docs/registro-de-cadena.md`](docs/registro-de-cadena.md) | La estructura `idea → plano → encargos → obra` |

## Verificación

Dos cables, los dos corren en cada PR ([`.github/workflows/coherencia.yml`](.github/workflows/coherencia.yml)):

| Cable | Qué vigila |
|---|---|
| [`coherencia-contrato.sh`](.github/scripts/coherencia-contrato.sh) | Las vistas derivadas contra la fuente — **hacia adentro** |
| [`frontera.sh`](.github/scripts/frontera.sh) | El contrato contra el disco: producto ↔ versión del manifiesto, catálogo ↔ referencias que existen — **hacia afuera** |

Cada uno con su **batería sembrada**, que corre junto a él: el criterio de aceptación no es que el
chequeo pase, sino que **FALLE cuando debe** (`decisiones/030`). Un chequeo que nunca se vio fallar
es una intención con formato de comando.

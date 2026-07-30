# 006 — Sustrato: markdown puro

**Estado:** ✅ **FIRMADA** · 2026-07-19 · **Re-ratificada:** 2026-07-23 · **Firmada por:** Fede
**Procedencia de la firma:** Re-ratificación en bloque en la **mesa de firmas del 2026-07-23**: Fede eligió **«En bloque, las 11»** vía elección explícita en sesión interactiva, tras presentársele la tabla de las 11 decisiones con el contenido de cada una (acto humano rastreable), y ratifica esta redacción al mergear su PR. La decisión original quedó «aceptada» el 2026-07-19 sin procedencia registrada — esta estampa no fabrica aquel acto: registra el de hoy. Ver `018` (la firma es un acto, no un campo).
**superaA:** —

## Contexto / problema

`FICHA.md` §2 declara que `batuta` es «un plugin de Claude Code, comando `/batuta`» pero nunca dice de qué está hecha. La respuesta define todo lo demás: cómo se testea, cómo se verifican los criterios de aceptación, si hay build, si hay dependencias que mantener.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Markdown puro** | Un comando `.md` con instrucciones, igual que `doc-arquitecto` y `audit-tracker`. Cero código, cero build, cero dependencias, cero superficie de mantenimiento. Costo: no hay tests unitarios — la verificación es por corrida sembrada, más lenta y menos granular. |
| **Markdown + scripts de apoyo** | Lo mecánico (leer estado, armar el manifiesto, validar el grafo de ruteo) en Node/Go, testeable con tests reales. Costo: agrega build, dependencias, versionado y una superficie de mantenimiento que hoy el taller no tiene en ninguna otra herramienta. |

## Decisión y porqué

**Markdown puro.**

Por consistencia con el resto del taller y porque la superficie de mantenimiento de un runtime propio no se justifica: `batuta` compone y rutea, no calcula. Lo que parecía candidato a script (validar el grafo, armar el manifiesto) es en realidad trabajo de composición que el modelo hace leyendo el contrato.

## Consecuencias

- **Los criterios de aceptación NO se verifican con tests unitarios: se verifican con corridas sembradas** — repos de prueba preparados a propósito con la condición a probar — más inspección del `.md`.
- No hay gates de CI clásicos (typecheck, lint, suite). La sesión S09 del plan ES la batería de verificación.
- Cualquier propuesta futura de agregar código debe pasar por un ADR que supere a este.

## Alcance precisado por `decisiones/030` (2026-07-30)

**Esta decisión no cambia. Se precisa su alcance**, porque estaba siendo leída más ancho de lo que dice
y esa lectura ancha bloqueaba trabajo legítimo.

**Lo que `006` fija:** el sustrato **del producto**. El comando es `.md`, sin código propio, sin build,
sin dependencias de instalación. Las dos opciones que esta decisión comparó eran **scripts que hacen
trabajo del producto** —«leer estado, armar el manifiesto, validar el grafo de ruteo»—, y ésos siguen
descartados.

**Lo que `006` no fija:** la **infraestructura de verificación del repo**. Un chequeo que compara
documentos entre sí —¿la ficha dice lo mismo que el ADR?— no es trabajo del producto: nadie lo instala,
el comando no lo invoca, y quitarlo no cambia lo que `batuta` hace. Precedente en el propio repo: el
artefacto de estado **ya no es markdown** y nunca se consideró que violara esta decisión.

**Lo que sigue intacto, y conviene subrayarlo:** los **criterios de aceptación de una sesión se
verifican con corridas sembradas**, no con tests unitarios (consecuencia 1, sin cambios). `030` no
abre la puerta a una suite del producto — de hecho su propio criterio de aceptación **es** una corrida
sembrada.

> ⚠️ **Tensión declarada, sin resolver — para firma del dueño.** La consecuencia 3 de arriba dice
> *«cualquier propuesta futura de agregar **código** debe pasar por un ADR que **supere** a este»*, y
> `030` declara `superaA: —`. Las dos lecturas son defendibles: **(a)** un script de CI es código, así
> que `030` debería declararse como que **supera en parte** a `006`; **(b)** `006` legisla el sustrato
> del producto y el chequeo no es producto, así que solo **precisa** su alcance sin superarlo.
>
> Esta sección **no elige**: el `superaA` de un ADR firmado no se reescribe por decisión del agente
> (`018`). Queda como hallazgo de S16 con su evidencia acá, donde un lector futuro lo busca.
> Resolverlo es un acto del dueño — y si elige (a), el camino es una nota en `030`, no borrar esta.

## Aplicada en

`PLAN.md` (cabecera y S09) · `ALCANCE.md` · alcance precisado por `030`, bajado en **S16**

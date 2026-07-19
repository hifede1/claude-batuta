# 001 — Mono-proyecto en v0 y v1

**Estado:** aceptada · 2026-07-18 · **porqué corregido 2026-07-19** (ver «Corrección» al pie)
**superaA:** —

## Contexto / problema

`batuta` puede operar a altitud de UN repositorio o a altitud de PORTAFOLIO (varios proyectos a la vez). La elección es de primer orden porque condiciona el ruteo: en portafolio hay que enumerar la flota, y enumerar la flota es trabajo de `cartera` — una herramienta **a medias**: tiene comandos escritos (`plugins/cartera/commands/cartera.md`, `cartera-roster.md`, verificado 2026-07-19) pero no está terminada, así que no es cimiento firme.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **Mono-proyecto** | Enumeración trivial (= el repo actual). Rompe la dependencia dura de `cartera`, que no está terminada. Costo: no se pueden priorizar inversiones entre proyectos. |
| **Portafolio desde v1** | Altitud correcta para decidir dónde invertir esfuerzo. Costo: depende de `cartera`, que está **a medias** → `batuta` quedaría acoplada a una herramienta sin terminar (su contrato de salida todavía puede cambiar), o tendría que enumerar la flota ella misma, que es god-object. |

## Decisión y porqué

**Mono-proyecto en v0 y v1. Portafolio = v2.**

Por dos razones, en este orden:

1. **`cartera` está a medias, y un cimiento a medias es peor que uno ausente.** Si estuviera ausente, `batuta` bloquearía limpio. Estando a medias, invita a acoplarse a un contrato de salida que todavía puede cambiar — y cuando cambie, el acoplamiento se descubre en la fase de ruteo, con trabajo gastado. La alternativa, enumerar la flota por su cuenta, viola «bloqueá, nunca reimplementes» antes de escribir la primera línea.
2. **La altitud de portafolio no es necesaria para el objetivo de v0.** v0 es head-first: armar la cabeza para bootstrappear el resto del taller. Eso se logra sobre un solo repo; el portafolio agrega superficie sin acercar el objetivo.

## Consecuencias

- El ruteo opera sobre un solo grafo de dependencias.
- `cartera` queda en la lista de delegados que **BLOQUEAN** si se pide enumerar la flota — **estar a medias no la habilita**: el criterio de delegado usable es «terminado», no «existe».
- La altitud de portafolio se difiere a v2, con `cartera` **terminada** como prerrequisito.

## Aplicada en

`FICHA.md` §0 y §4 · `ALCANCE.md`

## Corrección — 2026-07-19

El porqué original afirmaba que `cartera` **no existe**. La verificación de rutas del 2026-07-19 mostró que el repo `claude-cartera` sí tiene comandos escritos; Fede confirmó que **quedó a medias**. La decisión (mono-proyecto) **no cambia**, pero su justificación sí: el argumento ya no es la ausencia de `cartera` sino su estado incompleto, que es un riesgo distinto — acoplamiento a un contrato inestable en vez de bloqueo limpio. Se corrige acá en vez de dejarlo pasar porque **un ADR con un porqué falso es peor que no tener ADR**: alguien lo lee en seis meses y decide con información equivocada.

Se registra como corrección y no como decisión nueva porque el fondo no se movió; si en algún momento se decide adoptar portafolio, esa decisión supera a esta y lo declara en su `superaA`.

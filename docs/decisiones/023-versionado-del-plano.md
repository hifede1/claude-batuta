# 023 — Versionado del plano: sufijo incremental dentro del día

**Estado:** ✅ **FIRMADA** · 2026-07-26 · **Firmada por:** Fede
**Procedencia de la firma:** dos actos humanos, ambos rastreables (`018`). **(1) Elección:** Fede
eligió **«sufijo incremental»** entre cuatro opciones presentadas con sus tradeoffs, en sesión
interactiva del 2026-07-26 — la opción descartada explícitamente más cercana fue «declarar el
límite y no cambiar nada». **(2) Ratificación:** merge del **PR #56** por el dueño —
`merged_by = hifede1`, `2026-07-26T08:55:32Z`— que incorporó este ADR al repo. Este sello **no
fabrica** ninguno de los dos actos: los registra, y se estampa en un PR posterior porque la máquina
LEE el sello y jamás lo escribe por su cuenta.

> ⚠️ **Salvedad sobre la autenticación, dicha acá porque afecta a este mismo sello.** `009` autentica
> por `merged_by` == dueño anclado. En este taller **el agente opera con la credencial de
> `hifede1`**, que ES el dueño anclado — así que un merge del agente es estructuralmente
> indistinguible de uno del humano. El merge del PR #56 lo hizo Fede (el agente no ejecutó
> `gh pr merge`), pero **la prueba de eso es la traza del agente, no el `merged_by`**. La regla de
> `009` no discrimina mientras la credencial se comparta. Detectado el 2026-07-26; queda como deuda
> abierta, no como defecto de este ADR.
**superaA:** — *(complementa `011`: no cambia qué ES la versión, precisa cómo se desambigua)*
**Origen:** colisión detectada y asentada en el eslabón `plano` de la corrida
`2026-07-25-ejecutar-s11`

## Contexto / problema

`decisiones/011` fija que **la fecha de firma del plano ES su versión**, y `registro-de-cadena.md`
§3 que **una corrida usa la versión con la que arrancó**. La consecuencia no fue prevista: **dos
ratificaciones del mismo día son indistinguibles.**

No es hipotético. El **2026-07-25** se mergearon **cuatro** PRs que tocaron el plano:

| PR | Qué cambió |
|---|---|
| `#47` | abre la serie de mantenimiento (S10) + tercer salvo de §6 |
| `#48` | estampa el sello de `022` |
| `#52` | consolida la `Procedencia` de la cabecera + abre S11 |
| `#54` | resuelve la contradicción de `015` en §10 + declara el hueco `017` |

**Los cuatro comparten `plano_version: 2026-07-25` con contenidos distintos.** Y dos corridas
reales —`2026-07-25-ejecutar-s10` y `2026-07-25-ejecutar-s11`— arrancaron con esa **misma**
etiqueta sobre planos distintos: los identificadores `S11/*` **no existían** en el plano que leyó la
primera. Un auditor que resuelva un requisito «contra `plano_version 2026-07-25`» encuentra **dos
planos candidatos**.

### El costo real no es la incomodidad del auditor

`registro-de-cadena.md` §6 declara eslabón roto cuando **«el plano cambió de versión durante la
corrida»**. Con la versión atada a la fecha desnuda, **esa causal es estructuralmente inauditable
dentro del mismo día**: un cambio de plano a mitad de corrida no la dispara porque la etiqueta no se
mueve.

**Un control que no puede fallar tampoco puede detectar nada.** Eso es peor que no tener el control,
porque figura en la lista de causales y da falsa cobertura.

## Opciones evaluadas

1. **Sufijo incremental dentro del día.** ✅ *(elegida por Fede)*
   `Firmado: 2026-07-25 (2) por Fede`. **No inventa notación: reusa** la que el proyecto ya aplica a
   las auditorías múltiples del mismo día (`LAST_AUDIT = '2026-07-25 (2)'`). Sigue siendo legible
   sin herramienta y devuelve capacidad de disparo a la causal 7.
2. **Timestamp con hora.** `2026-07-25T21:04Z`. Colisión imposible sin esfuerzo humano y nada que
   recordar. Descartada porque la firma deja de leerse como fecha y pasa a leerse como dato de
   máquina: hay que comparar horas para saber cuál es más nueva.
3. **Hash del commit del plano.** Inequívoco y verificable contra git. Descartada por violar el
   mismo principio que hizo rechazar UUID para los IDs de requisito (`registro-de-cadena.md` §2:
   «legible sin herramienta»): nadie compara dos hashes a ojo.
4. **Declarar el límite y no cambiar nada.** Honesta y barata. Descartada porque deja la causal 7
   permanentemente inauditable dentro del día — se paga con la señal de una causal, que es
   exactamente el costo que `022` acaba de rechazar por el mismo motivo.

## Decisión

**La versión del plano es la fecha de firma; cuando el plano se ratifica más de una vez el mismo
día, la segunda y siguientes llevan sufijo incremental `(N)`.**

```
> Firmado: 2026-07-26 por Fede          ← primera ratificación del día: sin sufijo
> Firmado: 2026-07-26 (2) por Fede      ← segunda del mismo día
```

Reglas:

1. **La primera ratificación del día no lleva sufijo.** `(1)` no se escribe: una fecha desnuda ES la
   primera. Así el caso común no paga costo y las versiones históricas siguen siendo válidas sin
   reescribirse.
2. **El sufijo se incrementa por ratificación, no por PR.** Un PR que no cambia el plano no lo
   mueve.
3. **La corrida copia la etiqueta literal** en su cabecera `plano_version`, sufijo incluido.
4. **Un cambio de plano sin incremento es una violación del contrato**, no un descuido de estilo:
   deja la causal 7 ciega justamente cuando hacía falta.

## Consecuencias

La causal 7 de §6 vuelve a poder disparar dentro del día, y `plano_version` vuelve a identificar un
plano y no un conjunto de planos.

**Costo aceptado, dicho sin adornos:** el incremento es **manual y sin gate que lo verifique** — el
proyecto no tiene CI (`.github/workflows` no existe) y por `decisiones/006` no admite test que lo
clave. **Un olvido reintroduce la colisión en silencio**, que es el mismo fallo que este ADR viene a
cerrar. Se acepta porque la alternativa que lo automatizaría (opción 2 o 3) se paga con la
legibilidad, y la legibilidad del contrato es la propiedad que hace auditable a `batuta` por una
persona.

**Límite explícito:** este ADR **no** re-versiona la historia. Los cuatro PRs de plano del
2026-07-25 mantienen su etiqueta ambigua; la ambigüedad queda documentada acá y en el eslabón
`plano` de la corrida `2026-07-25-ejecutar-s11`, con su caso concreto. Reescribir firmas pasadas
sería fabricar actos que no ocurrieron así — exactamente lo que `018` prohíbe.

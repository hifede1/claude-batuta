# 032 — El pase adversarial viaja dentro del diff que se firma

**Estado:** ✅ **FIRMADA** · 2026-08-01 · **Firmada por:** Fede
**Procedencia de la firma:** un acto rastreable (`018`), **con la elección y la ratificación en días
distintos** — y por eso el sello lleva la fecha del acto, no la de la elección. `018` fija que la
firma **es el acto**, y el acto es el merge de este PR; `011` fija que esa fecha es la versión. La
elección ocurrió el **2026-07-31** y quedó registrada abajo; la ratificación cae el **2026-08-01**.
Es la primera vez en el proyecto que los dos momentos no comparten día, así que se declara en vez de
elegir uno de los dos en silencio. Por `023`, primera ratificación del día → sin sufijo.
En sesión interactiva del **2026-07-31**,
Fede eligió **«llega a firma con los huecos a la vista»** entre **tres** opciones presentadas con sus
tradeoffs —(a) llega con los huecos visibles, (b) no llega y la corrida queda `bloqueada`, (c) llega
y el cierre lo marca como eslabón roto— y con el dato duro sobre la mesa: **con la opción (b), 9 de
las 12 corridas que llegaron a la fase 2 no habrían llegado a firma**. Antes de la elección corrió un
fan-out de 5 agentes: 1 lente de evidencia sobre los 17 registros de corrida, 3 diseños independientes
y 1 juez que los puntuó contra el contrato. **Ratifica al mergear este PR** — con la salvedad de `028`,
que este ADR hereda: sin cuenta de agente, `merged_by` no discrimina quién actuó; la prueba es débil
y se declara como tal.
**superaA:** — *(no supera a nadie. Completa la Compuerta Cero de `002` y le da consecuencia aguas
abajo al paso 3 de la fase 2, que hasta hoy era un mandato sin efecto observable.)*
**Origen:** medición de los 17 registros de corrida del 2026-07-31. No es un hallazgo de una corrida:
es el patrón que emerge al leer el corpus entero.

## Contexto / problema

**La fase 2 manda correr un pase adversarial y la Compuerta Cero no lo mira.** Son dos mitades que
existen y no están soldadas:

- El paso 3 de la fase 2 es categórico: *«Delegá el pase adversarial a un workflow. **No lo hagas a
  mano** […] un adversario que sos vos mismo no es adversario»*. Sin cláusula de degradación.
- La Compuerta Cero —la única puerta entre planificar y delegar— enumera **tres** requisitos: el diff
  por horizonte, las altitudes de firma, y el canal autenticado. **Ninguno pregunta si el pase
  ocurrió.**

Saltearlo no dejaba rastro en el papel que el dueño firma: el diff salía igual de completo.

### La medición

De **17 corridas** registradas, **12 llegaron a la fase 2**:

| | |
|---|---|
| Corrieron el pase | **3** — y las tres **por pedido explícito del dueño en el turno**, ninguna por iniciativa del prompt |
| Lo saltearon | **9** — 8 declarados como desvío, 1 sin declarar |
| Veces que el pase cambió el plan | **3 de 3. Cero excepciones** |

**El motivo del salteo es el mismo, textual, en 8 de los 9 casos:**

> «Instrucción de sesión: sin subagentes ni workflows salvo pedido explícito»

Eso reencuadra el problema: **no es indisciplina del ejecutor, es que el contrato manda algo que el
ambiente le prohíbe por defecto.** Un mandato categórico que el 75 % de las veces no se puede cumplir
no es un mandato — es una ficción que el registro sale a desmentir corrida por corrida.

### El daño está medido, no es hipotético

En la corrida `2026-07-29d` el issue **#15 tenía la firma autenticada del dueño**
(`hifede1`/OWNER, 16:15:30Z) sobre un plan que el pase demolió acto seguido en **8 puntos
bloqueantes**. Cero encargos delegados. **La Compuerta Cero cumplió sus tres requisitos y dejó pasar
un plan roto**, porque no mide lo único que la fase 2 produce como defensa.

Y el rendimiento del pase, las tres veces que corrió:

- `29b` — encontró un **horizonte entero (H0)** que 15 corridas no vieron, y refutó una clasificación
  de horizontes **que el dueño ya había confirmado en la fase 1**.
- `29c` — tumbó el método de verificación de **2 de los 4 criterios**, con el plan ya publicado a firma.
- `29d` — invalidó un plan **ya firmado**, y volvió a hacerlo con la v2 y la v3. Encontró además que
  `batuta` había replicado en su propio verificador el mismo bug que acababa de cazar en el ajeno.

### El techo real es la COTA, no el motor

Las tres corridas declaran hallazgos que nadie evaluó: `29b` dejó «12 MEDIA/BAJA sin verificar» y
6 ALTAS sin atacar; `29d` dejó **33 sin veredicto** en el primer pase y 17 en el segundo. Leer «cero
confirmados» sobre esa base es un **falso verde producido por `batuta` misma** — y hasta hoy ese
número moría en el reporte, sin llegar al papel que el dueño firma.

## Opciones evaluadas

### 1. El diff de DOS COLUMNAS — ✅ **ELEGIDA**

El pase viaja **dentro del artefacto que la Compuerta Cero ya presenta**. No se agrega un requisito
ni una firma: cambia la **forma** del diff. Un plan sin pase deja de ser «un plan que salteó un paso»
y pasa a ser un **artefacto incompleto, que se ve incompleto de un vistazo**.

- **A favor:** cero actos humanos nuevos y —única de las tres— **cero interrupciones nuevas**: nunca
  frena, nunca escala. Es la aplicación literal del movimiento que `030` firmó: *«no se ataca con un
  parser — se ataca reduciendo a punteros, que es lo que lo vuelve innecesario»*. Trae además el
  **ancla de versión**, que es lo único del paquete que cura la falla más cara del corpus.
- **En contra:** **`SIN MIRAR` es firmable.** Compra visibilidad, no imposibilidad. Un dueño apurado
  firma igual y el resultado neto es el de hoy más una línea.

### 2. Requisito 4 duro — sin pase, no se pide la firma — *descartada*

- **A favor:** es la que más lejos llega en la letra y la única que cambia el estado terminal.
- **En contra, y es decisivo:** su mecanismo de aplicación es **idéntico al que ya falló 9 veces** —
  una regla categórica sin cláusula de degradación. Y el número: **9 de 12 corridas no habrían
  llegado a firma.** Con la causa medida siendo una instrucción de ambiente, eso no es rigor: es
  parálisis.

### 3. Exención graduada por nivel `014` — *descartada entera*

- **En contra:** `020` (FIRMADA) ya rechazó el **tercer estado degradado** y decidió «el humano
  decide; `batuta` jamás degrada estados» — `EXENTO` es ese tercer estado, autoproducido por la
  misma cabeza que el pase existe para refutar. Y su cláusula «el silencio no exime pero queda
  dentro de lo firmado» **contradice** `batuta.md`: *«El silencio jamás es firma»*.

## Lo que esta firma decide

1. **El requisito 1 de la Compuerta Cero incorpora el pase.** Una línea de procedencia con punteros
   (`wf` · lentes · **sobre: vN** · crudos / con veredicto / SIN VEREDICTO) y una celda por requisito
   con **tres valores y ninguno más**: `TUMBADO → qué cambió`, `ATACADO, EN PIE`, `SIN MIRAR`.
2. **`SIN MIRAR` es un hueco declarado, no un verde.** Absorbe también los hallazgos que la cota dejó
   sin veredicto — el techo se firma a la vista, no se entierra en el reporte.
3. **La columna no la escribe `batuta`.** Rellenar una celda con juicio propio **es** simular el pase,
   que el paso 3 ya prohíbe. Sin salida de workflow, la celda dice `SIN MIRAR`.
4. **El pase se ancla a la versión del diff que miró.** Si el diff se republica, las celdas que el
   cambio toca **vuelven a `SIN MIRAR`**. Un pase sobre `v1` no acredita `v2` — sin esto el agujero
   no se cierra, **se mueve**, que es la falla exacta de `29c` y `29d`.
5. **Una instrucción de sesión NO es una exención.** Es configuración de ambiente, no un acto del
   dueño sobre ese horizonte. Si el ambiente apaga el pase, el pase no ocurrió y se escribe así.
6. **Un método de verificación que todavía no se ejerció no es evidencia directa: es inferencia** —
   precisión sobre la primera condición de `014`, con piso MEDIA.
7. **El horizonte sin pase LLEGA a la firma.** El dueño ve los huecos y decide. No hay parálisis.

## Consecuencias declaradas

- **No agrega firmas.** La fórmula medida se mantiene: 2 de cabecera + 2 por horizonte + 1 de cierre
  = 9 con tres horizontes. Lo que sube es el costo de **lectura** de una firma que ya existía, y el
  de **espera** (~20 min de fan-out por horizonte).
- **`002` no queda superada, pero una de sus premisas envejece.** Ese ADR colapsó las fases 1-4 en una
  firma porque son *«baratas y reversibles»*. Con el pase corriendo, la fase 2 sigue siendo reversible
  —que es la mitad que sostiene la firma única— pero **deja de ser barata**. Queda dicho para quien
  relea `002` buscando dónde poner una compuerta.
- **Roza el presupuesto de `016`.** Un pase que devuelve hallazgos y cambia la selección es una
  iteración de re-análisis. Con varios horizontes, el fusible `K=5` queda más cerca del uso normal.
  **Este ADR no toca `016`**: si hace falta recalibrar K, es una firma sobre ese ADR, no una nota acá.

## Lo que NO decide — declarado

- **No suma la causal de eslabón roto** que el juez recomendaba («un horizonte firmado sin asiento de
  pase»). Se evaluó y **el dueño la dejó afuera al elegir la opción (a) sobre la (c)**. Consecuencia
  asumida y escrita: `cerrar` **no** va a marcar el desvío, así que la omisión no tiene costo aguas
  abajo. Se compra visibilidad en el instante de firmar, y nada más. Si mañana se quiere el costo,
  entra por ADR propio.
- **No numera un cuarto requisito.** El pase vive dentro del requisito 1: los de la Compuerta Cero
  siguen siendo **tres**. Numerarlo lo convertiría en la opción 2, que se descartó.
- **No cablea nada.** No hay cómo verificar por CI que un `wf_…` existió: los registros de corrida
  viven fuera del repo (`registro-de-cadena.md` §4). La defensa es que la omisión ahora hay que
  **escribirla** en el papel que se firma, no que sea imposible.

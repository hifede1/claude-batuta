# Registro de cadena — la estructura que preserva la intención

> Definido en **S02** · 2026-07-19 · Norma `VISION.md` «Cómo se ve el éxito»
> Bajo el acto de ratificación de `decisiones/011-ratificacion-del-plano.md`

`VISION.md` define el éxito de `batuta` en términos observables:

> Al cerrar una corrida, `batuta` exhibe la cadena completa `idea → plano → encargos → obra`
> **sin eslabones rotos**, y todo desvío entre lo pedido y lo construido aparece como
> hallazgo explícito, jamás enterrado.

Este documento fija **la estructura de esa cadena**. Es normativo: **toda fase de `batuta`
está obligada a escribir su eslabón.** Una fase que no escribe su eslabón es un bug del
plano, no una omisión de estilo.

## Por qué se define acá y no en `cerrar`

Porque si se difiriera a la fase que exhibe la cadena, se descubriría —tarde— que las fases
intermedias nunca guardaron lo que hacía falta, y habría que volver a tocarlas todas.

**El contexto se preserva desde el principio o no se preserva.**

---

## 1. Los cuatro eslabones

Una corrida de `batuta` tiene exactamente cuatro eslabones, uno por fase activa de v0:

| # | Eslabón | Lo agrega | Qué captura |
|---|---|---|---|
| 1 | `idea` | **analizar** | Lo que el humano pidió, y lo que `batuta` entendió — por separado |
| 2 | `plano` | **planificar** | Qué requisitos del plano firmado cubren esa idea, y la RUTA |
| 3 | `encargos` | **ejecutar-con-compuertas** | Cada encargo delegado, con el requisito que lo origina |
| 4 | `obra` | **cerrar** | Cada pieza mergeada, con el encargo que la produjo |

Cada eslabón declara **qué recibe del anterior** y **qué entrega al siguiente**. Ese es el
contrato interno: ninguna fase inventa contexto, ninguna lo pierde.

---

## 2. El identificador que liga encargo ↔ requisito

Es la pieza que hace la cadena auditable. Sin ella, «este encargo salió de algún lado» no es
verificable.

### Forma

```
<SESIÓN>/<slug-del-criterio>
```

Ejemplos reales del plano de este mismo proyecto:

```
S02/registro-cadena
S05/manifiesto-cinco-campos
S06/cero-doble-firma
```

### Reglas

1. **Único por requisito** dentro de una versión del plano. Dos requisitos jamás comparten ID.
2. **Estable**: el slug se deriva del criterio y **no se renumera**. Si un criterio se
   reformula, conserva su ID; si se elimina, su ID **no se reutiliza**.
3. **Legible sin herramienta**: se puede leer en el cuerpo de un issue y encontrar el
   criterio a mano.
4. **Calificado por versión de plano** cuando sale de la corrida (ver §3).

### Por qué no un UUID

Un identificador opaco cumpliría la unicidad pero rompería el punto 3: el humano que lee el
issue tiene que poder saltar al requisito sin desreferenciar nada. La cadena existe para que
una persona pueda auditarla, no solo una máquina.

---

## 3. La versión del plano en la corrida

`decisiones/011` fija que **la fecha de firma del plano es su versión** y que **una corrida
usa la versión con la que arrancó**.

Consecuencia para el registro: la corrida toma **un snapshot al inicio** y lo escribe una
sola vez en su cabecera:

```yaml
plano_version: 2026-07-19        # fecha de la línea de firma al arrancar
```

Todos los IDs de requisito de esa corrida se leen **contra esa versión**.

Si el plano cambia a mitad de la corrida, `batuta` **no cambia de contrato en el aire**: lo
registra como desvío y sigue con el contrato con que arrancó. Ese desvío aparece en `cerrar`
como hallazgo.

---

## 4. Dónde se persiste

```
${CLAUDE_PLUGIN_DATA}/corridas/<corrida-id>.md
```

- `${CLAUDE_PLUGIN_DATA}` resuelve a `~/.claude/plugins/data/batuta-<marketplace>/`
- `<corrida-id>` = `<fecha-de-inicio>-<slug-del-objetivo>` — p. ej. `2026-07-19-andamio-trazabilidad`

### Por qué ahí y no en el repo del usuario

Tres razones, en orden de peso:

1. **`batuta` no ensucia el repo que orquesta.** Escribir estado propio en el proyecto del
   usuario sería contrato fabricado por la puerta de atrás.
2. **Sobrevive a reinstalaciones del plugin.** El caché de plugins se borra y se regenera;
   `${CLAUDE_PLUGIN_DATA}` no (ver `references/plugins-claude-code.md`).
3. **Es markdown**, coherente con `decisiones/006`: inspeccionable con un editor, sin
   herramienta ni parser.

### Consecuencia asumida

El registro es **local a la máquina**. Una corrida iniciada en una máquina no se puede
continuar en otra. Es aceptable en v0 (`decisiones/001`: mono-proyecto, una persona, una
máquina) y queda anotado como límite conocido, no como olvido.

---

## 5. Estructura del archivo de corrida

```markdown
---
corrida: 2026-07-19-andamio-trazabilidad
plano_version: 2026-07-19
iniciada: 2026-07-19T14:02:00Z
estado: en-curso | cerrada | bloqueada
---

## 1. idea — agregado por `analizar`

**Pedido literal del humano:**
> (transcripción textual, sin interpretar)

**Lectura de `batuta`:**
> (qué entendió y por qué)

**Compuerta de lectura:** confirmada por el humano ✅ 2026-07-19T14:05:00Z

---

## 2. plano — agregado por `planificar`

**Recibe de `idea`:** el objetivo confirmado.

| Requisito | Criterio del plano | Por qué cubre la idea |
|---|---|---|
| `S02/registro-cadena` | «El registro define el identificador…» | … |

**RUTA:** (horizontes, gated-por-EJECUCIÓN vs gated-por-FIRMA)
**Firma de Compuerta Cero:** ⏳ pendiente | ✅ 2026-07-19T15:00:00Z

**Etiquetas de dato externo y hallazgos de inyección** (de las lentes del fan-out): (vacío si no hubo)

---

## 3. encargos — agregado por `ejecutar-con-compuertas`

**Recibe de `plano`:** los requisitos firmados y su orden.

| Encargo | Requisito de origen | Delegado a | Estado |
|---|---|---|---|
| `#6` | `S02/registro-cadena` | `/orquestar` | mergeado |

**Egresos firmados** (el historial contable del que sale el N=5 de `decisiones/012`):

| Egreso (operación · destino) | Firma | Resultado |
|---|---|---|
| (vacío si no hubo) | | |

**Etiquetas de dato externo y hallazgos de inyección:** (vacío si no hubo)

---

## 4. obra — agregado por `cerrar`

**Recibe de `encargos`:** los encargos y su estado.

| Pieza de obra | Encargo | Requisito |
|---|---|---|
| PR `#18` | `#6` | `S02/registro-cadena` |

### Desvíos detectados

| Qué se pidió | Qué se construyó | Dónde |
|---|---|---|
| (vacío si no hubo) | | |
```

---

## 6. Qué cuenta como eslabón ROTO

La cadena está rota —y `cerrar` debe reportarlo como hallazgo— cuando:

- un **encargo** no referencia ningún requisito, o referencia uno inexistente en
  `plano_version`
- una **pieza de obra** mergeada no referencia ningún encargo — salvo el **PR de decisión del
  dueño** (su asiento es la decisión-a-firmar que materializa, y su firma es el merge mismo,
  `decisiones/018`)
- un **requisito** firmado en la RUTA no tiene encargo ni motivo registrado de por qué no lo tiene
- un **egreso-que-escribe** ejecutado que no figura en el eslabón `encargos` con su firma y
  resultado
- un **dato externo** que llegó a un artefacto de la corrida —ficha, decisión-a-firmar, diff de
  horizonte, eslabón— **sin su etiqueta**: el lavado ES eslabón roto
- el **pedido literal** y la **lectura de `batuta`** divergen sin que la compuerta de lectura
  lo haya resuelto
- el plano cambió de versión durante la corrida

> Un eslabón roto **no se repara en silencio**. Se exhibe. Reparar un eslabón sin
> reportarlo es exactamente la falla que `VISION.md` describe: *«el desvío no aparece como
> hallazgo, aparece como sorpresa meses después»*.

---

## 7. Lo que este registro NO es

- **No es un bus.** La cola de trabajo son los GitHub Issues (`FICHA.md` §8: «NO un bus/cola
  propio»). El registro **referencia** issues; no los reemplaza.
- **No es un runtime.** Es un archivo de texto que se lee y se agrega. No mantiene estado vivo.
- **No es la fuente de verdad de la obra.** Esa es git. El registro guarda **el vínculo**
  entre la obra y la intención, que git no guarda.

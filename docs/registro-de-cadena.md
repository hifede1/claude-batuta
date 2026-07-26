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

### El sufijo dentro del día

La fecha sola no alcanza: **un plano puede ratificarse más de una vez el mismo día**, y entonces
dos planos distintos comparten etiqueta. Por `decisiones/023`, la segunda ratificación diaria y las
siguientes llevan **sufijo incremental `(N)`**:

```yaml
plano_version: 2026-07-26        # primera ratificación de ese día — SIN sufijo
plano_version: 2026-07-26 (2)    # segunda del mismo día
plano_version: 2026-07-26 (3)    # tercera, y así
```

- **La primera del día no lleva sufijo.** `(1)` no se escribe: una fecha desnuda **es** la primera.
  Así el caso común no paga costo y las versiones históricas siguen siendo válidas sin reescribirse.
- **El sufijo cuenta ratificaciones, no PRs.** Un PR que no cambia el plano no lo mueve.
- **La corrida copia la etiqueta literal**, sufijo incluido.

`decisiones/023` **decide** la regla; esta sección la **aplica**. Es acá donde las fases la leen.

#### Por qué existe — no es preferencia de formato

Sin el sufijo, **la causal 7 de §6 —«el plano cambió de versión durante la corrida»— es
estructuralmente inauditable dentro del día**: un cambio de plano a mitad de corrida no mueve la
etiqueta, así que la causal no puede disparar.

**Un control que no puede fallar tampoco puede detectar nada**, y es peor que no tenerlo: figura en
la lista de causales y da falsa cobertura. Por eso `023` regla 4 fija que **un cambio de plano sin
incremento es una violación del contrato, no un descuido de estilo** — deja ciega a la causal
justamente cuando hacía falta.

> **Límite conocido:** el incremento es **manual y sin gate**. El proyecto no tiene CI y por
> `decisiones/006` (markdown puro) no hay test que lo clave, así que **un olvido reintroduce la
> colisión en silencio**. Se asumió a conciencia en `023`: automatizarlo exigía renunciar a que la
> versión se lea a ojo, y esa legibilidad es lo que hace auditable el contrato por una persona.

**Precedente que lo motivó:** el **2026-07-25** se mergearon cuatro PRs de plano (`#47`, `#48`,
`#52`, `#54`) bajo la misma etiqueta, y dos corridas reales —`2026-07-25-ejecutar-s10` y
`2026-07-25-ejecutar-s11`— arrancaron con esa misma `plano_version` sobre planos distintos: los
identificadores `S11/*` no existían en el plano que leyó la primera. `023` **no re-versiona esa
historia**; queda como caso documentado.

---

## 4. Dónde se persiste

```
${CLAUDE_PLUGIN_DATA}/corridas/<corrida-id>.md
```

- `<corrida-id>` = `<fecha-de-inicio>-<slug-del-objetivo>` — p. ej. `2026-07-19-andamio-trazabilidad`

### Los DOS modos de resolución de `${CLAUDE_PLUGIN_DATA}`

**La variable no tiene un destino único.** Resuelve a `~/.claude/plugins/data/<id>/`, donde
`<id>` depende del **modo de carga del plugin**:

| Modo de carga | `<id>` | Path resultante del registro |
|---|---|---|
| Instalado desde marketplace | `batuta-<marketplace>` | `~/.claude/plugins/data/batuta-fede-tools/corridas/` |
| Cargado con `--plugin-dir` | `batuta-inline` | `~/.claude/plugins/data/batuta-inline/corridas/` |

No es una particularidad de `batuta`: el sufijo `-inline` lo recibe **todo** plugin cargado así,
y convive con su par de marketplace en el mismo directorio (`audit-tracker-inline`,
`engram-inline`, `vercel-inline`).

`references/plugins-claude-code.md:70` ya declaraba la forma general —
`~/.claude/plugins/data/{id}/`— y `:216` prescribe `--plugin-dir` como el modo de desarrollo de
`batuta`. Este documento había especializado ese `{id}` a un solo modo, perdiendo justamente el
que la referencia hermana recomienda para desarrollar.

> **Una fase que busque el registro en un único path está leyendo medio contrato.** Antes de
> concluir que una corrida «no existe», hay que mirar los dos.

### La evidencia de S09 no migra

Las cuatro corridas de la batería de S09 viven en `~/.claude/plugins/data/batuta-inline/corridas/`
porque se ejecutaron en modo `--plugin-dir`. **No son archivos huérfanos de una migración
fallida: son evidencia fechada**, y cada una declara en su cabecera el repo sembrado que la
originó (los tres de `audits/s09-bateria-2026-07-22.md`):

| Archivo | Repo sembrado |
|---|---|
| `2026-07-22-criterios-s01-a-tests.md` | `prueba-s09-faltante` |
| `2026-07-21-construir-contador.md` | `prueba-s09-caido` |
| `2026-07-21-construir-contador-baseline.md` | `prueba-s09-caido` (baseline — criterio `S08/baseline-persiste`) |
| `2026-07-22-avanzar-segun-plano.md` | `prueba-s09-inyeccion` |

**No se mueven, no se renombran, no se consolidan.** Moverlas rompería el pareo entre la batería
y su evidencia, y una corrida de `batuta` del 2026-07-24 llegó a arrancar con la premisa de
«arreglar el path roto» antes de que la re-auditoría desarmara la premisa. El registro se lee
donde quedó, en el modo en que se escribió.

### Por qué ahí y no en el repo del usuario

Tres razones, en orden de peso:

1. **`batuta` no ensucia el repo que orquesta.** Escribir estado propio en el proyecto del
   usuario sería contrato fabricado por la puerta de atrás.
2. **Sobrevive a reinstalaciones del plugin.** El caché de plugins se borra y se regenera;
   `${CLAUDE_PLUGIN_DATA}` no (ver `references/plugins-claude-code.md`).
3. **Es markdown**, coherente con `decisiones/006`: inspeccionable con un editor, sin
   herramienta ni parser.

### Consecuencias asumidas

**1. El registro es local a la máquina.** Una corrida iniciada en una máquina no se puede
continuar en otra. Es aceptable en v0 (`decisiones/001`: mono-proyecto, una persona, una
máquina) y queda anotado como límite conocido, no como olvido.

**2. El registro es local al MODO DE CARGA.** De la tabla de dos modos se sigue que los dos
paths son **directorios distintos y sin puente**: una corrida iniciada con el plugin instalado
desde marketplace **no se continúa** con el plugin cargado por `--plugin-dir`, ni al revés. Para
la fase que busca su corrida, cambiar de modo a mitad equivale a cambiar de máquina.

Se asume igual que la anterior y por la misma razón: unificar los paths obligaría a `batuta` a
adivinar cuál de los dos es «el bueno», y adivinar sobre el registro es exactamente lo que este
documento existe para impedir. **Límite conocido, no olvido** — con una regla práctica: si una
corrida parece no existir, mirá el otro modo antes de darla por perdida.

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

**Re-auditoría delegada:** invocada AAAA-MM-DDTHH:MM:SSZ · `last_audit` del artefacto: …

| Pieza de obra | Encargo / asiento | Requisito |
|---|---|---|
| PR `#18` | `#6` | `S02/registro-cadena` |
| PR `#29` | decisión `009` (dueño — autenticado: FIRMADA con procedencia + `merged_by` == dueño) | — |
| PR `#30` | bookkeeping del cierre `#28` (`decisiones/005`) | — |

### Desvíos detectados

| Qué se pidió | Qué se construyó | Dónde |
|---|---|---|
| (vacío si no hubo) | | |

**Etiquetas de dato externo que llegaron a la obra:** (vacío si no hubo)
```

---

## 6. Qué cuenta como eslabón ROTO

La cadena está rota —y `cerrar` debe reportarlo como hallazgo— cuando:

- un **encargo** no referencia ningún requisito, o referencia uno inexistente en
  `plano_version`
- una **pieza de obra** mergeada no referencia ningún encargo — con **tres** salvos, cada uno con
  su asiento propio:
  1. el **PR de decisión del dueño** (asiento: la decisión-a-firmar que materializa, autenticada
     — FIRMADA con procedencia `018` y `merged_by` == dueño `009`). ⚠️ **Este salvo autentica SOLO si
     el agente no comparte la credencial del dueño** (`decisiones/025`): si la comparte, un merge de
     la máquina produce el mismo `merged_by` que uno del humano y **el metadato deja de probar
     nada**. La condición es parte del asiento, no una nota al pie — si vuelve a compartirse la
     cuenta, este salvo deja de autenticar aunque la letra siga igual;
  2. el **PR de bookkeeping de CIERRE del tracker** (asiento: el cierre firmado cuya contabilidad
     refleja, `decisiones/005`);
  3. el **PR de bookkeeping de APERTURA del tracker** (asiento: la re-auditoría cuya invocación
     está asentada en el eslabón `obra` de una corrida, `decisiones/022`) — autentica **solo con
     las tres**: toca exclusivamente `docs/audits/`, la invocación figura en un eslabón `obra`
     con fecha y `last_audit`, y el `last_audit` declarado coincide con el del artefacto emitido.

  Un reclamo de salvo que no autentica es la causal, no la excepción

  > **Los actos anteriores a la aplicación de `025` NO se re-autentican.** Durante la serie de
  > mantenimiento (S10–S12, 2026-07-25/26) el agente operaba con la credencial del dueño, así que los
  > registros de corrida y varias `Procedencia` de ADRs invocan «`merged_by` == dueño» en una época en
  > que ese metadato **no podía discriminar**. Los merges fueron reales —los hizo el humano— pero su
  > única prueba era la traza del agente, que es lo que `009` rechaza como fuente de verdad.
  >
  > Quedan **como están**: son actos verdaderos con prueba débil, y reescribir sus procedencias sería
  > fabricar una autenticación que no existió — exactamente lo que `018` prohíbe. Un auditor que lea
  > un asiento de esa ventana debe tratar la autenticación por `merged_by` como **no concluyente**, y
  > eso es todo: no es un eslabón roto retroactivo.
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

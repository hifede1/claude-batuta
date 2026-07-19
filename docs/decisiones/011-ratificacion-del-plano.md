# 011 — Acto de ratificación del plano

**Estado:** ✅ **aceptada** · 2026-07-19 · Dueño: **Fede** · Desbloquea: **S02 (Andamio)**
**superaA:** —
**Origen:** hallazgo 🟠 de la auditoría del plano, 2026-07-19

## Contexto / problema

El plano **nunca definía su propio estado normativo ni cómo cambia**:

- `README.md` lo llama «contrato».
- `FICHA.md` §8 declara un criterio de aceptación «verificable» como si ya obligara.
- Pero `FICHA.md` se autodeclara «⚪ En diseño» y titula sus criterios de aceptación **«(borrador)»**.

No había ninguna cláusula que dijera quién ratifica los criterios, con qué acto pasan de
borrador a firme, ni qué versión del documento rige una corrida.

**Un contrato que no declara cuándo está vigente no obliga a nada:** cualquier
incumplimiento se desestima diciendo «era un borrador».

## La restricción decisiva (no estaba en el planteo original)

`batuta` tiene que poder **evaluar** si el plano está firmado: es la condición que dispara
su comportamiento —*con plano firmado produce la RUTA; sin plano rutea a `/documentar` y
frena*—. Por lo tanto **el acto elegido tiene que ser barato de chequear**, porque ese costo
se paga en cada corrida.

Esta restricción es la que ordena las opciones, y no había sido nombrada.

## Opciones evaluadas

| Opción | Tradeoffs |
|---|---|
| **`/auditar-docs` limpio == plano firmado** | Reusa maquinaria existente y es binario. **Descartada** — ver abajo. |
| **Firma explícita del humano en el repo** ✅ | Una lectura para evaluarla. Universal: sirve en cualquier repo, sin exigir disciplina de git. Ya era la práctica de hecho en `ALCANCE.md`. Costo asumido: se puede olvidar de actualizar. |
| **Tag de git / release** | Versionado real con historia inmutable. Costo: fricción por cada cambio y obliga a disciplina de tags en todo repo que `batuta` toque. Se difiere a v1. |

### Por qué se descarta `/auditar-docs` limpio

No es que sea más cara: **es incompatible con un criterio ya escrito.** S03 exige:

> «Con plano firmado, lee el estado vía `audit-tracker` y **no re-audita** *(verificación:
> la traza no muestra escaneo propio del código)*»

Si la firma fuera «auditoría limpia», `batuta` tendría que **correr una auditoría en cada
corrida** para saber si puede avanzar — exactamente lo que ese criterio prohíbe.

Y además dejaría el estado **efímero**: nada persistido, imposible saber cuándo se firmó ni
qué versión rigió una corrida ya cerrada.

## Decisión

### 1. El acto

El plano está vigente cuando su documento raíz lleva, en la cabecera, una **línea de firma
explícita**:

```markdown
> **Estado: VIGENTE**
> Firmado: AAAA-MM-DD por <quién>
> Ratifica: <los documentos que quedan bajo esta firma>
```

Sin esa línea, el plano es **borrador** y `batuta` lo trata como plano ausente: rutea a
`/documentar` y frena.

**Porqué:** es la única opción que se evalúa con una lectura, funciona en cualquier repo sin
exigir maquinaria previa, y **ya era la práctica de hecho** — `ALCANCE.md` viene firmado así
desde el 2026-07-19. Esta decisión no inventa un mecanismo: **norma el que ya estaba en uso.**

### 2. El versionado

**La fecha de la firma es la versión**, y la historia de git guarda el resto.

**Porqué:** cero maquinaria nueva, coherente con el sustrato markdown puro
(`decisiones/006`). Un esquema semver con tag por firma se evaluó y se **difiere a v1**: en
v0 mono-proyecto, un tag por cada corrección de typo es ruido que nadie va a leer.

### 3. Corridas iniciadas bajo una versión anterior

**Una corrida usa la versión con la que arrancó.** Se toma el snapshot al inicio y ese es su
contrato hasta el final.

Si el plano cambia a mitad de una corrida, `batuta` **lo reporta como hallazgo** y **no
cambia de contrato en el aire**.

**Porqué:** es lo coherente con el norte del producto —*todo desvío entre lo pedido y lo
construido aparece como hallazgo, no enterrado*—. Adoptar la versión nueva al vuelo dejaría
sin justificación el trabajo ya hecho bajo la anterior, y sin que nadie se entere. Abortar la
corrida ante cualquier cambio perdería trabajo en vuelo por un typo.

## Consecuencias

- **Los criterios del plano pasan a ser exigibles** en cuanto se aplique la firma. Es la
  decisión que le da autoridad a todo lo demás.
- `batuta` gana una condición evaluable en una lectura, sin delegar ni re-auditar.
- Se asume el costo declarado: **la firma se puede olvidar de actualizar.** Mitigación
  disponible pero no adoptada en v0: que `/auditar-docs` marque como hallazgo un plano cuya
  firma es anterior al último cambio de sus documentos ratificados.
- **Queda abierta una pregunta que esta decisión hace visible por primera vez:** si un plano
  puede declararse VIGENTE mientras conserva decisiones ⏳ pendientes. Ver más abajo.

## Lo que esta decisión deja planteado

Al volver evaluable el estado del plano, aparece de inmediato una pregunta que antes no se
podía ni formular:

> **¿Un plano con decisiones pendientes puede estar VIGENTE?**

Hoy el plano de `batuta` tiene **6 decisiones ⏳ sin firmar** (`009`, `010`, `012`, `013`,
`014`, `015`) y 7 de 9 sesiones bloqueadas por ellas. Dos lecturas posibles, ninguna
decidida acá:

- **VIGENTE = lo escrito obliga**, y las pendientes son huecos declarados que bloquean sus
  sesiones. El plano rige; simplemente no habilita todo.
- **VIGENTE exige plano completo**, y entonces no se puede firmar hasta cerrar las 6.

Se registra como pendiente explícita, no se resuelve por omisión.

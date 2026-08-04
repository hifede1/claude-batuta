# 035 — `034` no se aplica: el dueño opera con su credencial y el agujero de `009` vuelve a aceptarse

**Estado:** ✅ **FIRMADA** · 2026-08-04 · **Firmada por:** Fede
**Procedencia de la firma:** decisión del dueño en **sesión interactiva del 2026-08-04**, minutos
después de mergear `034` (PR #113, `d765bb6`). Fede dijo *«no puedo crear la cuenta así que vas a
quedar la mía»* y, al repreguntársele si el impedimento era técnico o de costo —porque cambiaba qué
salidas tenían sentido—, respondió ***«utilizá la mía y ya»***. **No se le preguntó una tercera vez.**
Se le habían presentado el hueco de contrato y tres salidas con sus costos. **Ratifica al mergear este
PR** — `merged_by` == dueño anclado (`009`), **con la salvedad que este mismo ADR vuelve a declarar**:
ese metadato no discrimina. Sello en el PR que lo propone (`024`).

**superaA:** `decisiones/034` **completo**. `034` queda **intacta** (`018`: ninguna firma se
reescribe). **Lo que falló no fue su decisión: fue su aplicación.**
**Origen:** `034` decidía que existe una cuenta de agente dedicada; el dueño decidió no crearla.

---

## Contexto / problema

`034` se firmó y se mergeó el **2026-08-04** (`d765bb6`). **Superó a `028` completo** y decidió que el
taller tiene una cuenta de agente dedicada, cerrando el agujero de `009` en vez de aceptarlo.
Su sección *Estado de aplicación* dejó escrito que quedaba **⛓️ pendiente del externo**: la cuenta la
crea el dueño.

**Veinte minutos después, el dueño decidió no crearla.**

Eso deja un hueco que no es operativo sino **de contrato**, y por eso hace falta este ADR:

| ADR | Estado tras `034` | Qué describe |
|---|---|---|
| `028` | **superado** por `034` | el agujero aceptado — dejó de regir |
| `034` | FIRMADA, **inaplicable** | una cuenta que no va a existir |

**Ninguna decisión vigente describía el estado real.** El agente opera con la credencial del dueño y
no había ADR que lo dijera. Es drift doc↔realidad en el documento más sensible del proyecto —la clase
exacta que `030` existe para cazar y que S19 entera vino a corregir en `references/`— y ocurrió **en
el sustrato de todo el modelo de firma**.

**No se arregla en silencio.** `018` prohíbe reescribir o borrar una firma: `034` no se puede editar
como si no hubiera pasado. El camino es un ADR que declare qué supera. Es el patrón de `031`, y el
mismo que `027` usó cuando la premisa de `025` resultó falsa.

## Decisión

**El agente opera con la credencial del dueño (`hifede1`), y el agujero de `009` queda otra vez
ACEPTADO y DECLARADO.**

Es, palabra por palabra, la posición de `028`. **`028` NO se resucita** —sigue superado por `034`, y
`018` no admite deshacer eso— pero **su contenido vuelve a regir por este ADR**, que lo dice con voz
propia en vez de mandar al lector a un ADR superado.

Las consecuencias operativas, sin eufemismos y sin novedad respecto de `028`:

1. **`merged_by` NO prueba quién actuó.** Un merge del agente y uno del humano son estructuralmente
   idénticos. Cuando un registro de este proyecto dice «autenticado por `merged_by` == dueño», dice
   algo **verdadero de hecho y no demostrable por ese metadato**.
2. **El canal de firma es el comentario `✅ validado`**, no el review de PR: sin cuentas separadas
   GitHub no permite aprobar el PR propio.
3. **El primer salvo de `registro-de-cadena.md` §6** —el PR de decisión del dueño— **conserva su forma
   y pierde su valor probatorio**: se trata como declaración, no como prueba.
4. **Sigue vigente `029`**: verificar la identidad al arrancar, FRENAR ante discrepancia, jamás
   restaurar por cuenta propia. Eso nunca dependió de haber cuentas separadas.

### Lo que este ADR NO decide, y se nombra para que no se lea como olvido

**Sin segunda identidad, C2 de S19 no es ejecutable.** La re-medición de la tabla de
`references/perimetro-de-confianza.md` §7:265-269 exige `gh auth switch --user <agente>` y
`GH_TOKEN=$(gh auth token --user <agente>)`: **sin `<agente>` esos comandos no tienen argumento.**

Si S19 debe cerrar declarando su tabla **no medible con su motivo** —cosa que `PLAN.md:744` permite
explícitamente: *«se mide, o se declara no medible con su motivo»*— **eso es un acto propio del plano
y del dueño**, no de este ADR. Un ADR de identidad no cierra criterios de una sesión por arrastre.

Queda igualmente dicho para que la próxima corrida no lo redescubra: **la tabla de §7 sigue
CONFUNDIDA y, con esta decisión, sin camino de medición a la vista.**

## Consecuencias

**Se pierde** lo que `034` compraba: la capacidad de distinguir humano de máquina por metadato
estructural, y con ella la posibilidad de que las firmas del proyecto sean **demostrables**. Vuelve a
ser cierto lo que `028` escribió y que `034` había venido a corregir.

**Se conserva** todo lo demás, exactamente como `028` lo enumeró: el principio de la separación
(`025`, vigente aunque inaplicable), el patrón único de sello (`024`), la regla de §6 que cubre ambos
canales, el mecanismo de identidad de §7 y su disciplina de arranque (`029`). **Se cayó una cuenta que
nunca llegó a existir, no el diseño.**

**Lo que este ADR compra a cambio del agujero** es lo mismo que `028`: una posición **honesta y
legible**. La alternativa peor no era crear la cuenta — era **dejar el contrato diciendo que existe
una que no existe**, que durante veinte minutos fue el estado real de este repo.

**Reversión:** basta crear una cuenta dedicada y volver a aplicar `025`. Este ADR **no cierra esa
puerta; la deja explícitamente abierta y sin fecha** — igual que `028`, y ahora con `034` como
constancia de que la decisión ya se tomó una vez y de qué la frenó.

## Nota de método — por qué hay tres ADRs sobre lo mismo en nueve días

`028` (26-07) aceptó el agujero · `034` (04-08) lo cerró · `035` (04-08) vuelve a aceptarlo.

**No es indecisión: es el registro funcionando.** Cada acto ocurrió, cada uno tuvo su elección real
con opciones y tradeoffs, y ninguno se reescribió. Un proyecto que borrara `034` para que la historia
quedara prolija estaría haciendo exactamente lo que `018` prohíbe — y la próxima vez que alguien
proponga crear la cuenta, `034` es la evidencia de qué se evaluó y qué la detuvo.

**Lo que sí queda como aprendizaje**, y vale más que los tres ADRs juntos: **`034` se firmó con su
externo todavía REQUERIDO.** Su sección *Estado de aplicación* lo declaraba con honestidad, pero
firmar una decisión cuya viabilidad depende de un acto que nadie confirmó todavía **es firmar sobre
una premisa no verificada** — el patrón que `027` documentó como el modo de falla recurrente de este
taller. La disciplina que faltó: **confirmar que el externo es provisible ANTES de firmar la decisión
que depende de él**, no después.

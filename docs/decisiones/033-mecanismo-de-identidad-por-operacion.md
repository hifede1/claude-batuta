# 033 — El mecanismo de identidad es POR OPERACIÓN, y su medición vive en un solo lugar

**Estado:** ⏳ **PENDIENTE** · 2026-08-03 · **Propuesta por:** el agente, en la corrida
`2026-08-03-ejecutar-s19-identidad-del-agente` (horizonte H1, autorizado por `#109`)

**Nace ⏳ PENDIENTE, que es el caso que `024` reserva** para cuando la elección humana todavía no
ocurrió (`024:72-76`): un ADR que se abre para que el dueño lo estudie antes de decidir. Por `018:32`
—«todo ADR nace como PROPUESTA; el estado por defecto es ⏳ PENDIENTE, nunca FIRMADA»— y siguiendo el
patrón de `026`, `030` (PR #77) y `031` (PR #84), que nacieron igual. **Sin campo `Procedencia de la
firma`: no hay firma todavía, y fabricarle una sería exactamente la falsificación que `018` prohíbe.**

**superaA:** — (complementa a `029`, no lo supera)
**Origen:** S19 · veredicto del pase adversarial registrado en `b17`, que declaró **no firmable** al
`033` original y pidió partirlo en dos.

---

## Por qué está partido, y qué mitad es ésta

El `033` original juntaba dos cosas de naturaleza distinta, y su propio pase adversarial lo tumbó por
eso. El plano fijó la partición (`PLAN.md:749-752`):

| Parte | Qué decide | Quién |
|---|---|---|
| **(a) el mecanismo** ← *este ADR* | cómo opera el agente con identidad, como complemento firmable de `029` | **se PROPONE**: es acto del agente |
| **(b) sacar el FRENA** | retirar la regla de `029:67-70` | **elección del dueño**, a firma **sin recomendación del agente** |

> 🚫 **La parte (b) queda FUERA del alcance de este ADR, y se declara para que no se lea como olvido.**
> Sacar el FRENA **supera a `029:67-70`** y es una ampliación del poder del agente sobre el estado del
> entorno del dueño. `PLAN.md:756-758` la reserva explícitamente al dueño y **prohíbe** que el agente
> la recomiende. Este ADR no la toca, no la insinúa y no la prepara.

---

## Contexto / problema

`029` fija **qué hace** el agente ante una discrepancia de identidad al arrancar: **FRENA**, y no
restaura — el estado del entorno es del dueño. Pero `029` no dice **cómo** opera el agente cuando la
identidad SÍ coincide y tiene que escribir. Ese hueco es el mismo que `025` dejó y que S14 tapó mal:
`025` es agnóstica del mecanismo, el agente eligió `gh auth switch`, y **el dueño terminó operando con
la cuenta del agente sin haberlo pedido**.

La consecuencia de dejarlo sin elevar a ADR ya se midió dos veces:

1. **S14** documentó `GH_TOKEN=…` en el plano como «el mecanismo correcto verificado» — declarado tras
   probarlo con **una sola lectura**. `references/perimetro-de-confianza.md` §7:268 mide ese mismo
   mecanismo con **❌ en escritura**.
2. **2026-07-28**: dos comandos completos del taller corrieron con la cuenta de otro proyecto, y **se
   detectó por accidente**, porque un comando devolvió otro login. No hubo chequeo que se disparara.

## Decisión propuesta

**El principio, que es agnóstico de la herramienta:**

> **El cambio de identidad del agente debe ser POR OPERACIÓN, con estado propio. Jamás debe alterar
> estado persistente del entorno del dueño.**

Es el enunciado que `references/perimetro-de-confianza.md` §7 ya sostiene y que `027:78-80` declaró
vigente **«sin depender de cuál sea la cuenta»**. Este ADR lo **eleva a decisión firmable** para que
deje de vivir solo en una referencia, y fija su corolario:

> **La MEDICIÓN de qué mecanismo cumple el principio vive en UN SOLO LUGAR:
> `references/perimetro-de-confianza.md` §7. Ningún otro documento la materializa — la APUNTA.**

**Deliberadamente, este ADR NO copia la tabla de mecanismos de §7.** Copiarla crearía la segunda
fuente que `030` diagnostica y que S19 vino a matar: dos lugares con el mismo dato envejecen por
separado. El ADR fija el **principio**; §7 guarda la **medición**; el chequeo 6 de
`.github/scripts/coherencia-contrato.sh` vigila que nadie más la materialice.

### Lo que este ADR NO afirma — y por qué la omisión es el punto

**No declara ganador a ningún mecanismo concreto.** No puede: §7 declara su propia tabla `:265-269`
**CONFUNDIDA** —las tres filas se midieron mientras otra sesión de Claude Code corría `gh auth switch`
cada ~30 s—, así que **hoy ninguna está medida limpiamente**. Elegir un ganador acá sería repetir el
error de S14 con más ceremonia.

La re-medición bajo aislamiento probado es **C2 de S19** y está **gated por una decisión del dueño**
sobre con qué identidad se mide: la fila 1 (`gh auth switch`) exige cambiar la cuenta activa global
(`029:67-70`), y las filas 2-3 con el criterio literal exigen una segunda identidad, que `027:43-45`
prohíbe tomar de `estebaproject`. **Esa decisión no la toma este ADR ni el agente** — y por `031`, que
fijó el patrón, tendrá que entrar como ADR propio declarando qué punto supera, no como aprobación
verbal.

## Consecuencias

**Se gana** que el principio deje de depender de que alguien lea una referencia: pasa a ser contrato
firmable, invocable por número, y con cable propio (chequeo 6).

**Se paga** que el ADR queda ⏳ PENDIENTE hasta que el dueño lo firme, y que su tabla de respaldo
—§7— sigue CONFUNDIDA mientras C2 no corra. **El ADR es honesto sobre eso en vez de esperar a tener
la medición**: el principio no depende de qué fila gane, y dejarlo sin escribir mientras tanto fue
exactamente lo que permitió que S14 prescribiera un mecanismo roto en el plano firmado.

**Reversión:** basta no firmarlo. Si se firma y después la re-medición de C2 muestra que el principio
necesita matices, el camino es un ADR que declare qué punto de éste supera (`031`).

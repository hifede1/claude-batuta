---
tema: cadenas-que-github-interpreta
triggers: [github, issue, PR, pull request, merge, cerrar issue, omision de CI, checks, commit, mensaje de commit, idioma, automerge, workflow]
fecha: 2026-08-09
fuentes:
  - docs/OPERACION.md §6 «Trampas operativas ya medidas»
  - docs/audits/claude-batuta-estado.json → deuda (los tres incidentes, con fechas y números de PR)
  - https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue
---

# Cadenas que GitHub interpreta — y por qué documentarlas no alcanza

> Destilado el **2026-08-09** a partir de **tres incidentes medidos en este repo**, dos de ellos
> con control experimental. Revalidar ante cambios en el comportamiento de GitHub.

> ## ⚠️ Restricción que esta referencia tiene sobre sí misma
>
> **No contiene las cadenas literales.** No es prolijidad: es la conclusión del segundo incidente.
> Un commit de este repo **citó un marcador de omisión de CI para EXPLICARLO** y GitHub lo leyó
> como **orden** — cero corridas, PR sin checks. **Escribir la cadena la activa, incluso cuando la
> intención es enseñarla.** Por eso acá se **describen** y no se transcriben.
>
> **Interacción con el cable, medida el 2026-08-09:** el chequeo 6 de `coherencia-contrato.sh`
> —que da rojo ante un mecanismo materializado en un fence fuera de `references/`— barre
> `docs/*.md` y `docs/decisiones/*.md`, y **su glob NO incluye `docs/references/`** (`:365`). Una
> referencia acá no puede dispararlo. Verificado, no supuesto.

---

## 1· El cierre de issues solo funciona en INGLÉS

**El incidente, con su control.** Este repo escribe sus PRs en español.

| | PR | Palabra usada | Resultado |
|---|---|---|---|
| **Caso** | `#89` | la palabra española para «cerrar», conjugada | el issue `#88` **quedó ABIERTO** |
| **Control** | `#92` | el verbo **inglés** equivalente a «resolver» | el issue `#91` **se cerró SOLO**, un segundo después del merge |

**Mismo repo, misma semana, mismo flujo. Lo único que cambió fue el idioma.** Y el control se
corrió a propósito, así que no es una anécdota: es una medición con su condición de contraste.

**Qué reconoce GitHub:** solo un conjunto cerrado de verbos **en inglés** —los de las familias
*close*, *fix* y *resolve*, en sus formas base, de tercera persona y de participio— seguidos de una
referencia al issue. **Nada en español, ningún sinónimo, ninguna perífrasis.** «Este PR cierra el
problema tal» es prosa para GitHub, no una instrucción.

**Regla operativa:** el cuerpo del PR puede estar íntegramente en español —y en este proyecto lo
está—, pero **la línea de cierre va en inglés**. Es una cadena de máquina embutida en un texto
humano, y se la trata como tal: no se traduce, igual que no se traduce el nombre de una rama.

**Cómo verificar que funcionó:** no alcanza con mergear y suponer. Después del merge, **consultar
el estado del issue**. En el control, el cierre llegó **un segundo** después del merge — si a los
pocos segundos sigue abierto, la cadena no se reconoció.

---

## 2· Los marcadores de omisión de CI se activan al ser citados

**El incidente, y lo que lo vuelve grave es la repetición.** GitHub reconoce, en el mensaje de un
commit, ciertos marcadores entre corchetes que le indican **no correr los workflows**. Van dentro
del texto del mensaje, y **no importa el contexto en el que aparezcan**.

- **Primera vez:** un commit de bookkeeping que **anotaba esta deuda** citó el marcador **para
  explicarlo**. Resultado: **cero corridas**, PR sin checks.
- **Segunda vez, dos jornadas después:** el agente **lo repitió con la documentación delante**.

**La conclusión que quedó escrita en la deuda del proyecto:**

> **Para las cadenas que GitHub interpreta, DOCUMENTAR NO ALCANZA — porque documentar exige
> escribirlas.**

**Y de ahí sale la única defensa que funciona: no materializar la cadena literal.** Ni en un
commit, ni en un PR, ni en un comentario, ni en un documento del repo. Si hay que hablar de ella,
se la **describe**. Esta referencia es la aplicación de su propia regla.

**Agravante de este repo en particular:** el check `coherencia` es **requerido** por la branch
protection (`decisiones/031`). Un PR sin corrida **no se puede mergear nunca** — no falla, queda
**bloqueado para siempre**, porque el check requerido nunca llega. El remedio existe y está en
`OPERACION.md`: **disparar el workflow a mano** desde el CLI. Es un bloqueo total del loop
resuelto con un comando que nadie adivina.

---

## 3· El patrón común, que es el que vale llevarse

Los dos casos son la misma clase de error, y no es un error de bash ni de GitHub:

> **GitHub lee el texto con SUS reglas, no con las nuestras.** Un mensaje de commit y un cuerpo de
> PR **no son prosa**: son **entradas de una máquina que hace pattern-matching** y actúa. El campo
> parece libre y no lo es.

De ahí las tres reglas prácticas:

1. **Las cadenas de máquina van en su idioma** (inglés), aunque todo el resto esté en español.
2. **Nunca citar literalmente una cadena que dispara comportamiento** — describirla.
3. **Verificar el efecto, no suponerlo.** El estado del issue después del merge; la existencia de
   corridas después del push. **Un efecto que no se verificó no ocurrió**, y estos dos fallan
   *silenciosamente*: el issue simplemente se queda abierto, el PR simplemente no tiene checks.
   **Nada avisa.**

---

## Checklist antes de mergear un PR en este repo

- [ ] La línea de cierre del issue está **en inglés**
- [ ] El mensaje de commit y el cuerpo del PR **no contienen** ningún marcador de omisión de CI,
      **ni citado ni explicado**
- [ ] El check `coherencia` **corrió** (si no hay corrida, disparar el workflow a mano)
- [ ] Después del merge: **el issue quedó cerrado** — verificado, no supuesto

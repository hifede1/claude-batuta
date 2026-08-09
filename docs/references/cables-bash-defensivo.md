---
tema: cables-bash-defensivo
triggers: [cable, chequeo, sembrar, bateria, siembra, escenario sembrado, set -e, exit 2, frenar, bash, BASH_VERSINFO, LC_ALL, falso verde, CI, script, shell, sed, grep, jq]
fecha: 2026-08-09
fuentes:
  - .github/scripts/coherencia-contrato.sh (8 chequeos · 559 líneas)
  - .github/scripts/bateria-sembrada.sh (35 escenarios · 434 líneas)
  - .github/scripts/frontera.sh (2 chequeos · 204 líneas)
  - .github/scripts/bateria-frontera.sh (15 escenarios · 254 líneas)
  - .github/workflows/coherencia.yml
  - docs/decisiones/030-coherencia-del-contrato.md
  - docs/PLAN.md (S16, S17, S19, S20, S21 — los defectos propios de cada cable)
---

# Cables de coherencia en bash — cómo se escribe uno que no dé falso verde

> Destilado el **2026-08-09** leyendo los cuatro scripts del repo y las sesiones que los
> produjeron, no un tutorial de bash. **Revalidar ante cualquier chequeo nuevo** y ante
> cambios de `.github/workflows/coherencia.yml`.

Este repo lleva **seis jornadas** escribiendo cables (S16, S17, la del 01-08, S19, S20, S21) y
**1.451 líneas de bash con ~50 escenarios sembrados**. Hasta el 2026-08-09 todo ese
conocimiento vivió **solo en los comentarios de los propios scripts** — o sea que lo
encontraba el que ya los estaba leyendo, y no el que iba a repetir el error.

**La tesis de `030`, y todo lo demás se deriva de ella:** el enemigo no es el cable que falla.
Es **el cable que pasa cuando no debería**. Un rojo se ve y se arregla; un falso verde
**simula cobertura** y sobrevive semanas.

---

## 1· Las cinco reglas duras

### 1.1 · NO usar `set -e`

Contraintuitivo, y por eso va primero. La cita del propio cable
(`coherencia-contrato.sh:34-35`):

> Jamás silencio, jamás verde. Por eso NO usa `set -e`: **un chequeo que muere a mitad se ve
> igual que uno que pasa**, y ése es el pecado que viene a evitar.

Con `set -e`, un `grep` sin match —que devuelve 1 legítimamente— **mata el script**. Y un
script muerto a mitad de camino sale con el último exit code que alcanzó a producir: puede ser
`0`. **El cable se convierte en lo que vino a cazar.**

**Lo que sí se usa** (`bateria-sembrada.sh:22`):

```bash
set -uo pipefail
```

`-u` caza la variable sin definir —un typo en un nombre no puede evaluar a vacío y pasar—, y
`-o pipefail` evita que el éxito del último eslabón de un pipe tape el fallo de un eslabón
anterior. **`-e` es el único que se deja afuera, y a propósito.**

### 1.2 · `exit 2`: FRENAR ≠ FALLAR

Tres códigos, y el del medio es el que importa:

| Salida | Significa |
|---|---|
| `0` | VERDE — coincide |
| `1` | ROJO — hay drift, con el archivo o el ADR señalado |
| **`2`** | **FRENA.** Falta una precondición y el cable **no pudo evaluar nada** |

Un `exit 2` leído como «pasó» es el falso verde exacto que estos cables existen para evitar.
Por eso **cada `exit 2` imprime su motivo y la frase «Esto NO es un verde»** — el mensaje es
parte del contrato, no decoración.

**Cuándo frena y no falla:** falta el archivo a comparar · la vista no expone filas evaluables
· no se puede parsear la fecha · el intérprete no soporta lo que el script usa.

### 1.3 · Frenar si el intérprete no alcanza

`declare -A` (array asociativo) es **bash 4+**. macOS trae **3.2**. La cita
(`coherencia-contrato.sh:56-59`):

> el bash del sistema en macOS es 3.2 y ahí el array asociativo **muere pero el script
> SIGUE**: los chequeos 1 y 2 imprimían ✓ sobre **una fracción** de los ADRs. Verde sobre
> datos rotos es exactamente el pecado del encabezado, **cometido por el propio cable**.

El freno, con la salida que resuelve el problema en vez de solo nombrarlo:

```bash
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "⛔ FRENA · requiere bash 4+ · éste es ${BASH_VERSION:-desconocido}"
  echo "   Esto NO es un verde: el chequeo no pudo correr."
  echo "   En macOS: /opt/homebrew/bin/bash $0 $*"
  exit 2
fi
```

**La otra estrategia, igual de válida y a veces mejor:** no usar bash 4 en absoluto.
`frontera.sh:29` declara que va **sin arrays asociativos a propósito**, y así corre en
cualquier intérprete. Elegí una de las dos **y declarala**; lo que no se puede es depender de
bash 4 sin frenar.

**Y esto NO se siembra copiando archivos:** hay que **invocar el cable con otro intérprete**.
Si la máquina no tiene un bash viejo, el escenario **se declara no corrido** —
`bateria-sembrada.sh:385-399` lo busca en `/bin/bash` y `/usr/bin/bash` y lo dice si no lo
encuentra. **Un escenario salteado en silencio se lee igual que uno que pasó**, que es la
misma falla otra vez.

### 1.4 · `export LC_ALL=C`

`bateria-sembrada.sh:24-26`:

> El locale decide el orden de `*`: se fija para que el veredicto no dependa del entorno.
> **El mismo repo daba ROJO en `C` y VERDE en `en_US.UTF-8`.**

Un veredicto que depende del locale del runner no es un veredicto.

### 1.5 · Solo `jq`, `sed` y `grep`

`bateria-sembrada.sh:73-75`:

> Solo jq, sed y grep: los sembradores **NO deben necesitar nada instalado**. Un chequeo cuya
> verificación depende de herramientas ausentes en el runner es frágil justo donde tiene que
> ser firme.

La primera versión de la batería usaba `rg` y `sd`. **Cero garantía en un runner de GitHub.**

Y `sed -i` **no es portable**: GNU acepta `sed -i`, BSD/macOS exige un sufijo. El helper del
repo (`bateria-sembrada.sh:76`) resuelve las dos:

```bash
edita() { sed -i.bak "$1" "$2" && rm -f "$2.bak"; }
```

---

## 2· Anclar donde vive la verdad, no donde aparece la palabra

`coherencia-contrato.sh:37-39`:

> **ANCLAR DONDE VIVE LA VERDAD**, no donde aparece la palabra. El sello es la línea
> `^**Estado:**`. Un grep de "PENDIENTE" a lo bruto marca al ADR `026` como pendiente por una
> **MENCIÓN en su prosa** (su línea 120).

De acá salen dos obligaciones concretas:

1. **Anclar en el literal estructural** — inicio de línea, celda de tabla, encabezado. No en
   la palabra suelta.
2. **Un anti-falso-positivo por cada ancla**, sembrado. El chequeo 2 de `frontera.sh` exige
   que la línea sea **fila de tabla** porque su tercer bucle no lo hacía y barría el catálogo
   entero: **una viñeta de prosa que nombrara `audit-tracker.md` entre backticks ponía el CI
   en rojo sobre un repo sano** — en un documento cuyo tema son, justamente, las referencias
   `.md` (`frontera.sh:126-130`).

---

## 3· Los defectos propios: seis cables, seis veces el mismo patrón

**Ninguno rompía nada visible. Todos devolvían un resultado creíble.** Esta tabla es la razón
de ser de la referencia:

| Sesión | El defecto | Por qué no se veía |
|---|---|---|
| **S16** | `set -e` más un `grep` sin match mataba el cable | Un chequeo muerto se ve igual que uno que pasa |
| **S17** | La estampa se leía con el sufijo `(N)` de `023` pegado | Una estampa **legítima** se volvía ilegible → el cable **frenaba por hacer las cosas bien** |
| **01-08** | `frontera.sh` nació con **27 hallazgos en los cables recién escritos** | El cable que venía a cazar drift traía el suyo |
| **S20** | **Tres** supuestos falsos: regex que no toleraba `id: 'b01'` **con espacio** · `^];` que cerraba **el array equivocado** · `grep -c` que **cuenta líneas, no ocurrencias** | *«Los tres devolvían números creíbles»* |
| **S21** | El mensaje decía `ROJO ·  de 8` (contador vacío) · y la huella se calculaba con `printf '%s\n%s\n'`, que **agrega un salto entre secciones** | Un mensaje casi bien y **un hash perfectamente válido**. Dos cálculos igualmente correctos habrían acusado un drift inexistente |
| **08-08** | `s_vistas_misma_fecha` no llamaba a `sync_trk` y **pasaba por coincidencia** | Mientras `LAST_AUDIT` fue igual al reloj de los ADRs, cuadraba sin que nadie sincronizara. **El resultado creíble era un VERDE** |

**La regla que S21 dejó escrita, y es la síntesis de las seis:**

> **Un cable nuevo se verifica contra un valor calculado POR FUERA de él**, nunca contra sí
> mismo.

Y el corolario de la última: **si un escenario pasa, preguntate si pasa por la razón que
declara o por una coincidencia del repo de hoy.** El anti-falso-positivo de S20 pasaba porque
dos fechas coincidían, no porque el cable funcionara.

---

## 4· El escenario sembrado: qué es y qué no

`030`: **«un chequeo que nunca se vio fallar es una intención con formato de comando»**. El
criterio de aceptación no es que el chequeo pase: es que **falle cuando debe**.

Un chequeo nuevo entra con **tres clases** de escenario, y las tres son obligatorias:

1. **ROJO** — se planta el drift que el chequeo promete cazar. Uno **por dimensión**: si el
   chequeo compara cuatro cosas, son cuatro escenarios. S20 vio fallar el chequeo 7 en **las
   cuatro a la vez** antes de corregir nada.
2. **FRENA** (`exit 2`) — se saca la precondición.
3. **ANTI-FALSO-POSITIVO** — se planta algo que **se parece** al drift y es legítimo. Es el
   más difícil de imaginar y el que más veces salvó al cable de ser ruidoso.

**El anti-falso-positivo es lo que separa un cable de un cartel.** La lección de S21: los dos
relojes baratos para la estampa de `ALCANCE` habrían dado rojo **ese mismo día** por cinco
estampas legítimas, y **un cable ruidoso se ignora** — que es peor que no tenerlo, porque
simula cobertura.

**La batería va en CI junto al cable, siempre.** Una garantía verificada una sola vez es
histórica: si alguien rompe la detección, la batería se pone roja **aunque el repo esté sano**.

### El escenario tiene que cumplir su propia premisa

El defecto del 2026-08-08: un escenario llamado «las vistas y el reloj en la MISMA fecha»
sembraba dos de las vistas y **dejaba la tercera sin tocar**. Pasaba por coincidencia. **Si el
escenario declara un estado del mundo, tiene que construirlo COMPLETO** — y cuando se agrega
una vista nueva al chequeo (el tracker HTML entró en S20), hay que revisar **todos** los
escenarios que declaran «las vistas», no solo los que fallan hoy.

---

## 5· El chequeo que NO se escribe

`frontera.sh:180-192` documenta un tercer chequeo **retirado**, y el motivo vale más que el
chequeo:

> Para escribirlo hubo que **copiar al README el estado de la compuerta** — y `ALCANCE.md:63`
> dice literal que ese estado «vive **solo acá**». O sea: el cable **no verificaba una copia
> legítima, CREABA la copia que el contrato prohíbe**, y después la vigilaba.

**Un cable que necesita duplicar el dato para poder compararlo está resolviendo el problema
al revés.** Antes de escribir un chequeo, preguntate si la comparación existe sin él.

Y el segundo motivo del retiro: **castigaba conservar el rastro histórico**, que `018` obliga
a no borrar — una nota que citara la frase vieja ponía el CI en rojo. **Un cable que pelea con
otra regla del proyecto está mal planteado**, no mal escrito.

---

## 6· Frontera del alcance: qué es mecanizable

Tres territorios, y la distinción es de `030` afinada por S17 y por la re-auditoría del
2026-08-08:

| Territorio | Mecanizable | Ejemplo |
|---|---|---|
| **Frescura** | ✅ sí | ¿La fecha de la vista está al día contra su reloj? (chequeos 4, 5) |
| **Completitud** | ✅ sí | ¿Están **todos** los ítems que deberían estar? ¿Los gates declarados son los que hay en disco? (chequeo 9) |
| **Contenido** | ❌ no — es **juicio** | ¿Lo que dice esta nota es cierto? ¿El cambio de §0 era sustantivo? |

**«La frescura es mecanizable; el contenido es juicio»** (S17). La re-auditoría del 2026-08-08
encontró el tercer territorio en el medio: el tracker tenía **los cuatro números al día y el
texto de nueve días antes**, porque «tres chequeos» cuando hay ocho **no es contenido: es un
número que se cuenta de los dos lados**.

**Regla práctica:** si podés contar las dos partes y compararlas, es cableable. Si tenés que
leer y opinar, es de la re-auditoría — **y entonces el límite se escribe en el script**, como
hace el chequeo 7 en `:408-414`. Un límite declarado es honestidad; uno no declarado es un
falso verde esperando.

---

## 7· Lo que ningún cable de este repo puede ver

Los ocho chequeos comparan documentos **DENTRO** del repo, y corren **offline por diseño**.
Queda afuera, declarado:

- **El artifact publicado** del tracker. El 2026-08-08 llevaba **nueve días y 29 cierres** de
  atraso: el paso «Redeploy A LA MISMA URL» es **el único paso del protocolo que ningún cable
  puede verificar**, y se saltearon dos veces seguidas.
- **El estado de los delegados**, que viven fuera del repo (por eso S18 cerró 0 de 5 criterios
  clavados).
- **La frescura de `references/` contra la versión de su fuente** — `audit-tracker.md`
  declaraba `1.11.1` con el plugin real en `1.14.0`, con el CI en verde.

Los tres exigen **red en CI** o credenciales, o sea **perímetro**: son decisión con ADR, no
trabajo de un encargo.

---

## Checklist para el próximo cable

- [ ] `set -uo pipefail`, **sin `-e`**
- [ ] Freno por intérprete (`BASH_VERSINFO`) **o** declaración de que no usa bash 4+
- [ ] `export LC_ALL=C`
- [ ] Solo `jq`, `sed`, `grep` — y `sed -i.bak` para portabilidad
- [ ] `exit 2` con motivo y la frase «Esto NO es un verde» en cada precondición
- [ ] Anclado en el literal estructural, no en la palabra
- [ ] Un escenario **ROJO por dimensión**, visto fallar **antes** de corregir nada
- [ ] Un escenario **FRENA**
- [ ] Un **anti-falso-positivo** por ancla, y verificado que pasa **por su razón y no por
      coincidencia**
- [ ] Revisados los escenarios **viejos** que declaran el mismo estado del mundo
- [ ] El **límite** del chequeo escrito en el script
- [ ] Verificado contra un valor calculado **por fuera** del cable
- [ ] Batería en CI **junto** al cable

#!/usr/bin/env bash
# coherencia-contrato.sh — el cable de `decisiones/030`.
#
# Hace cumplir la jerarquía que `030` decidió:
#   docs/decisiones/ es LA FUENTE del estado de un ADR.
#   FICHA.md §10 y el artefacto de estado son VISTAS DERIVADAS.
#   Si la vista y la fuente no coinciden, la vista miente.
#
# Los tres chequeos del alcance decidido de `030`:
#   1. todo ADR tiene su línea de sello
#   2. ADRs con sello PENDIENTE == `decisiones_pendientes` del artefacto de estado
#   3. cada entrada de FICHA §10 apunta a un ADR que existe, tiene sello y
#      `Procedencia`, y el estado que §10 declara == el sello de la fuente
#
# Más los dos de S17, que cierran el límite que S16 se declaró al cerrar:
#   4. `last_audit` del artefacto no quedó atrás del reloj de la fuente
#   5. la estampa de FICHA.md —o sea `plano_version`— tampoco
#
# LOS 4 Y 5 MIDEN FRESCURA, NO CONTENIDO, y la distinción es deliberada. No
# verifican qué DICE la deuda ni si `bloques` está completo: eso es prosa, y
# medir intención con patrones léxicos es indecidible — este taller lo vio
# caerse tres veces. Se evaluaron y descartaron con evidencia dos candidatos:
# «todo bloque cita su PR» (b01 no lo cita y es legítimo: S01 cerró con un
# install verificado, no con un PR de este repo) y «la deuda no cita ADRs
# firmados» (una entrada que NARRA historia da falso positivo, el mismo grep
# a lo bruto que marcaba al 026 por su línea 120).
#
# Lo mecanizable es la frescura; el contenido lo corrige la re-auditoría. El
# cable no la reemplaza: la OBLIGA.
#
# DOS REGLAS DE DISEÑO, las dos aprendidas fallando (`030`, sección 3):
#
#   FRENAR ≠ FALLAR. Precondición ausente o vista no evaluable → exit 2, dicho.
#   Jamás silencio, jamás verde. Por eso NO usa `set -e`: un chequeo que muere a
#   mitad se ve igual que uno que pasa, y ése es el pecado que viene a evitar.
#
#   ANCLAR DONDE VIVE LA VERDAD, no donde aparece la palabra. El sello es la
#   línea `^**Estado:**`. Un grep de "PENDIENTE" a lo bruto marca al ADR 026
#   como pendiente por una MENCIÓN en su prosa (su línea 120).
#
# Usa grep POSIX a propósito: corre en cualquier runner sin instalar nada.
#
# Uso: coherencia-contrato.sh [ruta-del-repo]     (default: .)

set -uo pipefail

# El locale decide el orden de `*` y el orden decidía QUÉ ARTEFACTO se leía.
# Con dos `*-estado.json` en docs/audits/, `LC_ALL=C` ordena mayúsculas antes
# que minúsculas y `en_US.UTF-8` al revés: el MISMO repo daba ROJO o VERDE
# según el entorno. Un cable cuyo veredicto depende del locale no verifica,
# sortea. Se fija acá y el glob de abajo deja de adivinar.
export LC_ALL=C

# ── FRENO 0: el INTÉRPRETE ──────────────────────────────────────────────
# Va primero porque es la única dependencia que este script no puede
# sustituir. `declare -A` (abajo) es bash 4+; el bash del sistema en macOS
# es 3.2 y ahí el array asociativo muere pero el script SIGUE: los chequeos
# 1 y 2 imprimían ✓ sobre una fracción de los ADRs. Verde sobre datos rotos
# es exactamente el pecado del encabezado, cometido por el propio cable.
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "⛔ FRENA · requiere bash 4+ · éste es ${BASH_VERSION:-desconocido}"
  echo "   Esto NO es un verde: el chequeo no pudo correr."
  echo "   En macOS: /opt/homebrew/bin/bash $0 $*"
  exit 2
fi

REPO="${1:-.}"
DECISIONES="$REPO/docs/decisiones"
FICHA="$REPO/docs/FICHA.md"
fallas=0

echo "═══ Coherencia del contrato (decisiones/030) ═══"
echo

# ── FRENO: sin fuente no hay chequeo posible ────────────────────────────
for req in "$DECISIONES" "$FICHA"; do
  if [ ! -e "$req" ]; then
    echo "⛔ FRENA · no existe: $req"
    echo "   Esto NO es un verde: el chequeo no pudo correr."
    exit 2
  fi
done

# El artefacto se resuelve por glob CONTADO, no por `ls | head -1`. Tomar el
# primero de una lista es elegir por orden alfabético — o sea por locale — cuál
# de dos vistas es LA vista. Si hay más de una, el cable no adivina: FRENA.
set -- "$REPO"/docs/audits/*-estado.json
if [ ! -e "$1" ]; then
  echo "⛔ FRENA · no hay artefacto de estado en $REPO/docs/audits/"
  echo "   Esto NO es un verde: el chequeo 2 no tiene vista contra qué comparar."
  exit 2
fi
if [ "$#" -ne 1 ]; then
  echo "⛔ FRENA · hay $# artefactos de estado, no sé cuál es la vista:"
  for a in "$@"; do echo "     ${a#$REPO/}"; done
  echo "   Esto NO es un verde: elegir el primero sería elegir por locale."
  exit 2
fi
ESTADO="$1"
if ! command -v jq >/dev/null 2>&1; then
  echo "⛔ FRENA · falta jq — no se puede leer la vista derivada"
  exit 2
fi
echo "fuente: ${DECISIONES#$REPO/}   vistas: ${FICHA#$REPO/} · ${ESTADO#$REPO/}"
echo

# ── LA FUENTE ───────────────────────────────────────────────────────────
# Tres sellos válidos. CERRADA existe: `015` es un paraguas que se cerró
# delegando en 019/020/021 — no es FIRMADA ni PENDIENTE, y es legítimo.
adrs=0; pend_fuente=""; sin_sello=""
declare -A sello_de

# EL RELOJ DE LA FUENTE (chequeos 4 y 5): la fecha de sello más reciente de
# todo `decisiones/`. Sale de la MISMA pasada que construye `sello_de` — un
# solo recorrido alimenta las dos vistas.
#
# Se toma la fecha MÁXIMA de la línea, no la primera, y el motivo no es
# prolijidad: `001` lleva «FIRMADA · 2026-07-18 · … · Re-ratificada: 2026-07-23»
# y una re-ratificación ES un cambio de la fuente. Anclar en la primera fecha
# dejaría envejecer la vista sin que el cable lo note — el pecado exacto que
# estos dos chequeos vienen a cerrar, cometido por el propio cable.
#
# Las fechas ISO se comparan como texto: `\>` de `test` es orden lexicográfico
# y en `YYYY-MM-DD` eso es orden cronológico. Sin `date`, que no parsea igual
# en GNU y en BSD y volvería el veredicto dependiente del runner.
reloj=""; adr_reloj=""

for f in "$DECISIONES"/*.md; do
  case "$(basename "$f")" in [0-9][0-9][0-9]-*) ;; *) continue ;; esac
  adrs=$((adrs + 1))
  num=$(basename "$f" | cut -c1-3)
  linea=$(grep -m1 '^\*\*Estado:\*\*' "$f" 2>/dev/null)
  if [ -z "$linea" ]; then sin_sello="$sin_sello $num"; continue; fi
  case "$linea" in
    *PENDIENTE*) sello_de[$num]=PENDIENTE; pend_fuente="$pend_fuente $num" ;;
    *FIRMADA*)   sello_de[$num]=FIRMADA ;;
    *CERRADA*)   sello_de[$num]=CERRADA ;;
    *)           sello_de[$num]=ILEGIBLE ;;
  esac
  f_max=$(printf '%s' "$linea" | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | sort | tail -1)
  if [ -n "$f_max" ] && { [ -z "$reloj" ] || [ "$f_max" \> "$reloj" ]; }; then
    reloj="$f_max"; adr_reloj="$num"
  fi
done

# ── CHEQUEO 1 ───────────────────────────────────────────────────────────
printf '1· sello presente y legible ......... '
malos=""
for n in "${!sello_de[@]}"; do
  [ "${sello_de[$n]}" = ILEGIBLE ] && malos="$malos $n"
done
if [ -n "$sin_sello$malos" ]; then
  echo "✗ FALLA"
  for n in $sin_sello; do echo "     ADR $n · sin línea ^**Estado:**"; done
  for n in $malos;     do echo "     ADR $n · sello ilegible (ni FIRMADA, ni PENDIENTE, ni CERRADA)"; done
  fallas=$((fallas + 1))
else
  echo "✓ ($adrs ADRs)"
fi

# ── CHEQUEO 2 ───────────────────────────────────────────────────────────
printf '2· PENDIENTE: fuente == artefacto ... '
# El ID del ADR es el PRIMER número de tres dígitos de la entrada, no cualquier
# número que aparezca en su texto libre. Con `grep -oE '[0-9]{3}'` a secas, una
# entrada legítima como «031 — … (supera 027 punto 4)» declaraba DOS pendientes
# y el cable acusaba a `027` de estar pendiente cuando está FIRMADA. Lo encontró
# el propio cable al usarlo para asentar `031`: anclar en el número que aparece
# en vez de en el que identifica es la misma falla de siempre, en la vista.
pend_vista=$(jq -r '.decisiones_pendientes[]? | tostring' "$ESTADO" 2>/dev/null \
             | while IFS= read -r entrada; do
                 printf '%s' "$entrada" | grep -oE '[0-9]{3}' | head -1
               done | sort -u | tr '\n' ' ')
norm() { echo "$1" | tr ' ' '\n' | sort -u | tr -d '\n '; }

if [ "$(norm "$pend_fuente")" != "$(norm "$pend_vista")" ]; then
  echo "✗ FALLA"
  for n in $pend_vista; do
    case " $pend_fuente " in *" $n "*) ;;
      *) echo "     el artefacto lista $n como PENDIENTE · su ADR dice ${sello_de[$n]:-ausente}" ;;
    esac
  done
  for n in $pend_fuente; do
    case " $pend_vista " in *" $n "*) ;;
      *) echo "     el ADR $n está PENDIENTE · el artefacto no lo lista" ;;
    esac
  done
  fallas=$((fallas + 1))
else
  echo "✓ (${pend_fuente:-ninguno pendiente})"
fi

# ── CHEQUEO 3 ───────────────────────────────────────────────────────────
# Se parsea POR LÍNEA: cada fila de la tabla de §10 lleva su link al ADR y su
# estado en la misma línea. Por línea es robusto al número de columnas.
printf '3· FICHA §10 == la fuente ........... '
prob=""; entradas=0; vistos=""

while IFS= read -r linea; do
  num=$(printf '%s' "$linea" | grep -oE 'decisiones/[0-9]{3}-' | head -1 | grep -oE '[0-9]{3}')
  [ -z "$num" ] && continue
  declarado=""
  case "$linea" in
    *PENDIENTE*) declarado=PENDIENTE ;;
    *FIRMADA*)   declarado=FIRMADA ;;
    *CERRADA*)   declarado=CERRADA ;;
  esac
  [ -z "$declarado" ] && continue
  entradas=$((entradas + 1))
  vistos="$vistos $num"

  real="${sello_de[$num]:-}"
  if [ -z "$real" ]; then
    prob="$prob\n     §10 cita el ADR $num · no existe en docs/decisiones/ o no tiene sello"
    continue
  fi
  if [ "$declarado" != "$real" ]; then
    prob="$prob\n     §10 declara $num como $declarado · su ADR dice $real"
  fi
  # La Procedencia se le exige a lo FIRMADO, no a lo pendiente. Un ADR que
  # nace ⏳ PENDIENTE —el caso que `024` reserva para cuando la elección humana
  # todavía no ocurrió— no tiene firma, así que no puede tener procedencia de
  # una firma. Exigírsela ponía el CI en rojo por abrir un ADR correctamente, y
  # el único modo de apagarlo era escribir la procedencia de un acto que no
  # ocurrió: el cable empujaba a la falsificación que `018` existe para prohibir.
  if [ "$real" != PENDIENTE ] && \
     ! grep -q '^\*\*Procedencia de la firma' "$DECISIONES"/"$num"-*.md 2>/dev/null; then
    prob="$prob\n     el ADR $num tiene sello $real y no declara 'Procedencia de la firma' (018)"
  fi
done < <(awk '/^## 10\./{f=1;next} /^## /{f=0} f' "$FICHA" | grep '^|')

# Y al revés: ningún ADR de la fuente queda sin FILA EVALUABLE en §10.
#
# Se compara contra `vistos` —los ADRs que el parseo de arriba reconoció como
# fila— y ese parseo lee SOLO §10, recortada con awk, y solo sus líneas de
# tabla. Las dos mitades importan:
#
#   Sin el recorte, el ancla era el archivo ENTERO y el chequeo inverso medía
#   otra cosa que el directo: a un ADR le bastaba aparecer citado en cualquier
#   párrafo para quedar inmune. Se le sacaba la fila a `007` (citado en :91) y
#   el cable contestaba «✓ ninguna huérfana». El primer intento de arreglo puso
#   este comentario y NO movió el ancla — zafaba porque esa prosa dice
#   «firmada» en minúscula. Una mayúscula lo rompía: la garantía valía un
#   carácter.
#
#   Y el mismo agujero abría por el otro lado: una nota en §12 que escribiera
#   FIRMADA o PENDIENTE cerca de un link a `decisiones/NNN-` entraba como fila
#   fantasma y ponía el cable en ROJO acusando a §10 de algo que §10 no dice.
#
# Falso negativo y falso positivo, la misma causa: anclar donde aparece la
# palabra en vez de donde vive la verdad (`030` §3).
for n in "${!sello_de[@]}"; do
  case " $vistos " in
    *" $n "*) ;;
    *) prob="$prob\n     el ADR $n existe en la fuente · §10 no lo lista como fila" ;;
  esac
done

if [ "$entradas" -eq 0 ]; then
  echo "⛔ FRENA"
  echo "     §10 no expone entradas evaluables (link al ADR + estado en la misma línea)."
  echo "     Esto NO es un verde: el chequeo no pudo evaluar nada."
  exit 2
elif [ -n "$prob" ]; then
  echo "✗ FALLA"
  printf '%b\n' "$prob"
  fallas=$((fallas + 1))
else
  echo "✓ ($entradas entradas, ninguna huérfana)"
fi

# ── CHEQUEOS 4 y 5 · LA FRESCURA DE LAS VISTAS (S17) ────────────────────
# Una vista puede coincidir con la fuente en todo lo que declara y estar
# igual atrasada: le falta lo que la fuente ganó DESPUÉS. Los chequeos 1-3
# comparan lo que la vista dice; éstos comparan hasta CUÁNDO lo dice.

# FRENO: sin reloj no hay contra qué comparar. Pasa si ningún ADR tiene fecha
# en su sello — repo vacío o formato de sello cambiado. NO es un verde.
if [ -z "$reloj" ]; then
  echo
  echo "⛔ FRENA · ningún ADR declara fecha en su línea ^**Estado:**"
  echo "   Esto NO es un verde: los chequeos 4 y 5 no tienen reloj contra qué medir."
  exit 2
fi

# `fresca <n> <etiqueta> <fecha-de-la-vista> <de-dónde-salió>`
# FRENA si la fecha falta o no es YYYY-MM-DD; suma falla si quedó atrás.
fresca() {
  local n="$1" etiq="$2" fecha="$3" origen="$4"
  printf '%s· %s ' "$n" "$etiq"
  if [ -z "$fecha" ]; then
    echo "⛔ FRENA"
    echo "     $origen no declara fecha."
    echo "     Esto NO es un verde: el chequeo $n no pudo comparar nada."
    exit 2
  fi
  case "$fecha" in
    20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;;
    *) echo "⛔ FRENA"
       echo "     $origen declara «$fecha», que no es YYYY-MM-DD."
       echo "     Esto NO es un verde: el chequeo $n no pudo comparar nada."
       exit 2 ;;
  esac
  if [ "$fecha" \< "$reloj" ]; then
    echo "✗ FALLA"
    echo "     la vista dice $fecha · la fuente llegó a $reloj (ADR $adr_reloj)"
    echo "     $origen quedó atrás: hay firma posterior a lo que declara."
    fallas=$((fallas + 1))
    return
  fi
  echo "✓ ($fecha ≥ $reloj)"
}

# El artefacto: `last_audit` es un campo estructurado, se lee con jq y punto.
# `// empty` para que un null llegue vacío y caiga en el freno, no en el case.
fresca 4 "artefacto fresco vs la fuente ...." \
       "$(jq -r '.last_audit // empty' "$ESTADO" 2>/dev/null)" \
       "${ESTADO#$REPO/} · last_audit"

# La estampa: es `plano_version`, lo que `batuta` LEE al arrancar cada corrida
# (`registro-de-cadena.md` §3). Ancla en `^> Firmado:`, que aparece una sola vez
# en FICHA.md — verificado antes de escribir esto, porque el modo de falla de
# este proyecto es anclar donde aparece la palabra y no donde vive la verdad.
#
# `head -1` sobre las fechas y NO `sort | tail -1`: la estampa lleva UNA fecha
# y puede llevar sufijo `(N)` de `023` («2026-07-30 (2) por Fede»). El sufijo no
# es fecha, así que no compite; pero si algún día la línea sumara una segunda,
# la que estampa es la primera.
fresca 5 "estampa de FICHA vs la fuente ...." \
       "$(grep -m1 '^> Firmado:' "$FICHA" 2>/dev/null | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | head -1)" \
       "${FICHA#$REPO/} · la estampa del plano"

# ── CHEQUEO 6 · EL MECANISMO DE IDENTIDAD VIVE EN UN SOLO LUGAR (S19) ───
# `references/perimetro-de-confianza.md` §7 es LA FUENTE de cómo se opera con
# identidad. Cuando otro documento MATERIALIZA el mecanismo en un bloque de
# código, deja de citarlo y pasa a prescribirlo: nace la segunda fuente, y las
# dos envejecen por separado. Es el diagnóstico de `030` aplicado a un
# territorio que su alcance no cubría — `030` mira los sellos de ADR y FICHA
# §10; `references/` no lo miraba nadie.
#
# NO es hipotético: `PLAN.md:417-421` —plano FIRMADO— presentaba
# `GH_TOKEN=…` como «el mecanismo correcto verificado», y §7:268 mide ESE
# MISMO mecanismo con ❌ en escritura. El plano le decía al próximo
# implementador que usara lo que la referencia hermana había medido roto.
#
# ANCLA: el BLOQUE DE CÓDIGO, no la palabra. Este repo NOMBRA los tres
# mecanismos todo el tiempo en prosa —narrando la historia de `025`/`027`/`028`,
# citando qué falló y por qué— y eso es legítimo: hablar de un mecanismo no es
# prescribirlo. Un grep a lo bruto marcaría 20 líneas de narrativa correcta.
# Lo que distingue prescripción de mención es que el comando esté MATERIALIZADO
# para copiar y pegar, y eso sí es mecánico: vive dentro de un fence ```.
#
# LÍMITE DECLARADO, y se declara porque un límite callado es el cartel de
# siempre: el chequeo NO caza prescripciones INLINE en prosa o en celda de
# tabla (p. ej. una fila que diga «la solución es `GH_TOKEN=…`»). Distinguir
# ahí prescripción de narración es JUICIO, no mecánica, y este taller ya vio
# caerse tres veces la medición de intención con patrones léxicos. Ese flanco
# lo cubre la re-auditoría, igual que el contenido de la deuda en los 4 y 5.
#
# ALCANCE: `docs/*.md` y `docs/decisiones/*.md`. Quedan fuera `references/`
# (es la fuente, ahí el bloque DEBE estar) y `audits/` (son registros de
# hechos fechados, no contrato vigente: un informe que transcribe el comando
# que se corrió ese día no prescribe nada).
printf '6· mecanismo de identidad solo en references/ '
mec_probs=""
for f in "$REPO"/docs/*.md "$REPO"/docs/decisiones/*.md; do
  [ -e "$f" ] || continue
  hits=$(awk '
    /^[[:space:]]*```/ { dentro = !dentro; next }
    dentro && /GH_TOKEN=|gh auth switch|GH_CONFIG_DIR=/ {
      sub(/^[[:space:]]+/, "")
      print "     " FILENAME ":" FNR " · " $0
    }
  ' "$f" 2>/dev/null)
  [ -n "$hits" ] && mec_probs="$mec_probs\n$hits"
done
if [ -n "$mec_probs" ]; then
  echo "✗ FALLA"
  echo "     un documento fuera de references/ MATERIALIZA el mecanismo en un bloque de código:"
  printf '%b\n' "${mec_probs#\\n}" | sed "s|$REPO/||"
  echo "     La fuente es references/perimetro-de-confianza.md §7. Acá va un PUNTERO, no el comando."
  fallas=$((fallas + 1))
else
  echo "✓ (ningún bloque de código lo materializa fuera de la fuente)"
fi

# ── CHEQUEO 7 · EL TRACKER HTML, LA VISTA QUE NADIE MIRABA (S20) ────────
# `batuta-tracker.html` es una vista derivada del artefacto, igual que
# FICHA §10 — pero ningún chequeo la miraba. Los 4 y 5 cerraron la frescura
# de las OTRAS dos vistas y declararon este hueco; el HTML quedó afuera.
#
# NO es hipotético, y la prueba es que ya pasó DOS VECES:
#   2026-08-02 · HTML en LAST_AUDIT 2026-07-30 / CLOSED_COUNT 68 contra un
#                artefacto en 2026-08-02 / 80. Se saldó A MANO, y la deuda
#                escribió: «sigue sin cable, puede volver a atrasarse en
#                silencio mañana».
#   2026-08-04 · se atrasó de nuevo: 2026-08-02/80 contra 2026-08-04/88,
#                más 4 bloques y 3 ADRs faltantes. La deuda predijo su
#                propia repetición y acertó.
# Corregir la vista a mano no arregla la ausencia del control que la vigila.
#
# ANCLA: los LITERALES JS, no la palabra. `const LAST_AUDIT = '…'` y
# `const CLOSED_COUNT = …` son declaraciones únicas y parseables. Un grep de
# «LAST_AUDIT» a lo bruto engancha además las 3 menciones del comentario de
# cabecera del propio archivo, que explican el protocolo de actualización.
# Es el mismo modo de falla que `030` §3 documenta y que este taller ya se
# cobró tres veces.
#
# LÍMITE DECLARADO, y se declara porque un límite callado es el cartel de
# siempre: el chequeo 7 mide **frescura y cardinalidad**, NO CONTENIDO. Que
# los textos del tracker digan la verdad —que el resumen de un bloque
# describa lo que pasó— no es mecanizable, exactamente igual que en los
# chequeos 4 y 5. Un HTML con los cuatro números al día y un texto que
# miente pasa este chequeo. Ese flanco lo cubre la re-auditoría; el cable no
# la reemplaza, la OBLIGA.
printf '7· tracker HTML vs la fuente ........ '
TRACKER="$REPO/docs/audits/batuta-tracker.html"
if [ ! -f "$TRACKER" ]; then
  echo "⛔ FRENA"
  echo "     no existe ${TRACKER#$REPO/}"
  echo "     Esto NO es un verde: el chequeo 7 no tuvo vista que comparar."
  exit 2
fi
# Los cuatro valores de la vista. `-m1` porque cada constante se declara una
# sola vez; el ancla `^const ` deja fuera las menciones del comentario.
t_audit=$(grep -m1 "^const LAST_AUDIT" "$TRACKER" | sed "s/.*'\([^']*\)'.*/\1/")
t_closed=$(grep -m1 '^const CLOSED_COUNT' "$TRACKER" | grep -oE '[0-9]+' | head -1)
# `id:[[:space:]]*'` y NO `id:'`: el HTML declara `id: 'b01'` con espacio y
# `id:'b19'` sin él, y las dos formas son legítimas. La primera versión de
# este chequeo contaba 18 bloques donde había 19 —se comía `b01`— y el
# error era invisible: daba un número plausible, sólo que uno menos. Es el
# modo de falla que `030` §3 nombra, cometido por el cable escrito para
# cazarlo: anclar en un patrón que no cubre las variantes reales del dato.
# Y se cuentan OCURRENCIAS (`grep -o | wc -l`), no LÍNEAS (`grep -c`).
# `grep -c` cuenta líneas que matchean: dos entradas en una misma línea
# —JS perfectamente válido— cuentan como una sola, y el cable ve un ADR
# menos del que hay. Lo destapó la propia batería al sembrar una entrada
# pegada a otra: el conteo no se movió y el escenario quedó rojo sin que
# el número dijera por qué. Es el tercer supuesto falso de este mismo
# chequeo, y los tres de la misma clase: contar una cosa creyendo que se
# cuenta otra.
t_bloques=$(grep -oE "id:[[:space:]]*'b[0-9]+'" "$TRACKER" | wc -l | tr -d ' ')
t_adrs=$(grep -oE "id:[[:space:]]*'d[0-9]{3}'" "$TRACKER" | wc -l | tr -d ' ')
# Los cuatro de la fuente.
f_audit=$(jq -r '.last_audit // empty' "$ESTADO" 2>/dev/null)
f_closed=$(jq -r '.closed_count // empty' "$ESTADO" 2>/dev/null)
f_bloques=$(jq -r '.bloques | length' "$ESTADO" 2>/dev/null)
f_adrs=$(ls "$DECISIONES"/[0-9][0-9][0-9]-*.md 2>/dev/null | wc -l | tr -d ' ')

if [ -z "$t_audit" ] || [ -z "$t_closed" ]; then
  echo "⛔ FRENA"
  echo "     no pude leer LAST_AUDIT o CLOSED_COUNT del tracker."
  echo "     Esto NO es un verde: el chequeo 7 no pudo comparar nada."
  exit 2
fi

t_probs=""
[ "$t_audit" != "$f_audit" ] && \
  t_probs="$t_probs\n     LAST_AUDIT   · tracker $t_audit · fuente $f_audit"
[ "$t_closed" != "$f_closed" ] && \
  t_probs="$t_probs\n     CLOSED_COUNT · tracker $t_closed · fuente $f_closed"
[ "$t_bloques" != "$f_bloques" ] && \
  t_probs="$t_probs\n     bloques      · tracker $t_bloques · fuente $f_bloques"
[ "$t_adrs" != "$f_adrs" ] && \
  t_probs="$t_probs\n     ADRs         · tracker $t_adrs · docs/decisiones/ $f_adrs"

if [ -n "$t_probs" ]; then
  echo "✗ FALLA"
  echo "     el tracker HTML quedó atrás de la fuente:"
  printf '%b\n' "${t_probs#\\n}"
  echo "     Corregirlo a mano no cierra esto: el cable existe para que no vuelva a envejecer solo."
  fallas=$((fallas + 1))
else
  echo "✓ ($t_audit · $t_closed cierres · $t_bloques bloques · $t_adrs ADRs)"
fi

echo
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · las vistas coinciden con la fuente y están al día"
  exit 0
fi
echo "ROJO · $fallas de 7 chequeos en falla"
exit 1

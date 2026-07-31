#!/usr/bin/env bash
# coherencia-contrato.sh — el cable de `decisiones/030`.
#
# Hace cumplir la jerarquía que `030` decidió:
#   docs/decisiones/ es LA FUENTE del estado de un ADR.
#   FICHA.md §10 y el artefacto de estado son VISTAS DERIVADAS.
#   Si la vista y la fuente no coinciden, la vista miente.
#
# Los tres chequeos del alcance decidido de `030` — ni uno más:
#   1. todo ADR tiene su línea de sello
#   2. ADRs con sello PENDIENTE == `decisiones_pendientes` del artefacto de estado
#   3. cada entrada de FICHA §10 apunta a un ADR que existe, tiene sello y
#      `Procedencia`, y el estado que §10 declara == el sello de la fuente
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
pend_vista=$(jq -r '.decisiones_pendientes[]? | tostring' "$ESTADO" 2>/dev/null \
             | grep -oE '[0-9]{3}' | sort -u | tr '\n' ' ')
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

echo
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · las vistas coinciden con la fuente"
  exit 0
fi
echo "ROJO · $fallas de 3 chequeos en falla"
exit 1

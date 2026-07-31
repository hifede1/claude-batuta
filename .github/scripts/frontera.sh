#!/usr/bin/env bash
# frontera.sh — el cable que mira HACIA AFUERA.
#
# `coherencia-contrato.sh` verifica que las vistas derivadas coincidan con la
# fuente: `docs/decisiones/` contra `FICHA.md` §10 y el artefacto de estado.
# Todo lo que mira vive DENTRO del contrato.
#
# Este mira la otra costura: la que une el contrato con el mundo — el artefacto
# que se instala, el catálogo de referencias, la puerta de entrada del repo.
# Ninguna de las tres estaba bajo cable, y las tres derivaron:
#
#   · el comando cambió dos veces sin que `plugin.json` se moviera
#   · el catálogo declaró 🔴 FALTANTES dos referencias que existían hace 10 días
#   · el README siguió diciendo «NO construir» doce días después de v0 COMPLETA
#
# Ninguna es un descuido aislado: es la misma estructura que `030` diagnosticó
# —una copia que no se declara copia y no apunta a su fuente— aplicada a la
# frontera en vez de al contrato. La regla de `030` sube un nivel: el disco
# decide, la declaración orienta.
#
# MISMAS DOS REGLAS DE DISEÑO que su hermano, por el mismo motivo:
#
#   FRENAR ≠ FALLAR. Precondición ausente → exit 2, dicho. Jamás silencio,
#   jamás verde. Por eso NO usa `set -e`.
#
#   ANCLAR DONDE VIVE LA VERDAD. Acá la verdad es el DISCO: qué archivo existe
#   y qué commit tocó qué. No la palabra que un documento usa para describirlo.
#
# Sin arrays asociativos a propósito: corre en el bash 3.2 de macOS igual que
# en el runner. Un cable que solo anda en un intérprete ya mintió una vez.
#
# Uso: frontera.sh [ruta-del-repo]     (default: .)

set -uo pipefail

REPO="${1:-.}"
REFS="$REPO/docs/references"
CATALOGO="$REFS/README.md"
READMEP="$REPO/README.md"
ALCANCE="$REPO/docs/ALCANCE.md"
COMANDO="plugins/batuta/commands"
MANIFIESTO="plugins/batuta/.claude-plugin/plugin.json"
fallas=0

echo "═══ Frontera — el contrato contra el mundo ═══"
echo

# ── FRENO: sin las piezas no hay chequeo posible ────────────────────────
for req in "$CATALOGO" "$READMEP" "$ALCANCE" "$REPO/$MANIFIESTO"; do
  if [ ! -e "$req" ]; then
    echo "⛔ FRENA · no existe: $req"
    echo "   Esto NO es un verde: el chequeo no pudo correr."
    exit 2
  fi
done
echo "la verdad es el disco · vistas: ${CATALOGO#$REPO/} · README.md · ${MANIFIESTO}"
echo

# ── CHEQUEO 1 · el producto no puede cambiar sin mover su versión ───────
# El manifiesto es lo único que le dice a una instalación que hay algo nuevo.
# Si el comando se movió después del último bump, toda copia instalada quedó
# vieja SIN SEÑAL — que es como S15 (la precondición de identidad) estuvo nueve
# días mergeada y ausente de la única copia que se ejecuta.
printf '1· el producto no adelanta al manifiesto '
if ! git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1; then
  echo "⛔ FRENA"
  echo "     no es un repo git · sin historia no se puede comparar"
  exit 2
fi
if [ "$(git -C "$REPO" rev-parse --is-shallow-repository 2>/dev/null)" = "true" ]; then
  echo "⛔ FRENA"
  echo "     clon shallow · el log por archivo no es confiable"
  echo "     en CI: actions/checkout con fetch-depth: 0"
  exit 2
fi

t_cmd=$(git -C "$REPO" log -1 --format=%ct -- "$COMANDO" 2>/dev/null)
t_man=$(git -C "$REPO" log -1 --format=%ct -- "$MANIFIESTO" 2>/dev/null)

# El manifiesto tocado y sin commitear cuenta como movido: quien lo está
# editando ya está bumpeando, y el veredicto se decide sobre lo que va a
# quedar en la rama. En CI el árbol está limpio, así que esto no aplica y
# el chequeo es puro-commits — que es la verdad para una instalación.
if [ -n "$(git -C "$REPO" status --porcelain -- "$MANIFIESTO" 2>/dev/null)" ]; then
  t_man=$(date +%s)
  man_sucio=" · manifiesto modificado sin commitear"
else
  man_sucio=""
fi

if [ -z "$t_cmd" ] || [ -z "$t_man" ]; then
  echo "⛔ FRENA"
  echo "     sin commits para $COMANDO o $MANIFIESTO"
  exit 2
elif [ "$t_cmd" -gt "$t_man" ]; then
  echo "✗ FALLA"
  echo "     el comando cambió DESPUÉS del último bump de versión:"
  echo "       comando    $(git -C "$REPO" log -1 --format='%ad %h %s' --date=short -- "$COMANDO")"
  echo "       manifiesto $(git -C "$REPO" log -1 --format='%ad %h %s' --date=short -- "$MANIFIESTO")"
  echo "     una copia instalada no tiene forma de saber que hay algo nuevo."
  fallas=$((fallas + 1))
else
  echo "✓ (v$(grep -o '"version"[^,]*' "$REPO/$MANIFIESTO" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')$man_sucio)"
fi

# ── CHEQUEO 2 · el catálogo de referencias contra el disco ──────────────
# 🔴 se define en el propio catálogo como «faltante (hay que generarla ANTES
# del encargo que la necesita)». Una 🔴 que existe manda a generar algo que
# está a un `ls` de distancia; una 🟢 que no existe promete lo contrario.
printf '2· catálogo de referencias == disco ... '
prob=""; filas=0
while IFS= read -r linea; do
  path=$(printf '%s' "$linea" | grep -oE 'docs/references/[a-z0-9-]+\.md' | head -1)
  [ -z "$path" ] && continue
  case "$linea" in *'|'*) ;; *) continue ;; esac
  filas=$((filas + 1))
  base=$(basename "$path")
  existe=no; [ -f "$REPO/$path" ] && existe=si
  case "$linea" in
    *🔴*) [ "$existe" = si ] && prob="$prob\n     $base · el catálogo la declara 🔴 FALTANTE · el archivo existe" ;;
    *🟢*|*🟠*) [ "$existe" = no ] && prob="$prob\n     $base · el catálogo la declara fresca · el archivo NO existe" ;;
    *) prob="$prob\n     $base · fila sin marca de frescura legible" ;;
  esac
done < "$CATALOGO"

# Y al revés: ninguna referencia del disco sin fila en el catálogo.
for f in "$REFS"/*.md; do
  b=$(basename "$f")
  [ "$b" = "README.md" ] && continue
  grep -q "docs/references/$b" "$CATALOGO" || \
    prob="$prob\n     $b · existe en el disco · el catálogo no la lista"
done

# La tabla «Faltantes con su encargo»: una fila SIN tachar cuyo archivo existe
# es la misma mentira, en el segundo lugar donde vive.
while IFS= read -r linea; do
  case "$linea" in *'~~'*) continue ;; esac
  b=$(printf '%s' "$linea" | grep -oE '`[a-z0-9-]+\.md`' | head -1 | tr -d '`')
  [ -z "$b" ] && continue
  [ -f "$REFS/$b" ] && prob="$prob\n     $b · listada como faltante-con-encargo · el archivo existe"
done < "$CATALOGO"

if [ "$filas" -eq 0 ]; then
  echo "⛔ FRENA"
  echo "     el catálogo no expone filas evaluables (path + frescura en la misma línea)."
  echo "     Esto NO es un verde: el chequeo no pudo evaluar nada."
  exit 2
elif [ -n "$prob" ]; then
  echo "✗ FALLA"
  printf '%b\n' "$prob"
  fallas=$((fallas + 1))
else
  echo "✓ ($filas referencias, ninguna en falso)"
fi

# ── CHEQUEO 3 · la puerta de entrada contra la compuerta ────────────────
# El README es el archivo con mayor probabilidad de lectura del repo y el único
# que nunca recibió mantenimiento. `ALCANCE.md` es la fuente del estado de la
# compuerta —lo declara él mismo: «El estado de dependencias vive SOLO acá».
printf '3· README == estado de la compuerta .. '
if grep -q 'COMPUERTA ABIERTA' "$ALCANCE"; then
  if grep -q 'NO construir' "$READMEP"; then
    echo "✗ FALLA"
    echo "     ALCANCE.md declara la compuerta ABIERTA · README.md dice «NO construir»"
    echo "     $(grep -n 'NO construir' "$READMEP" | head -1)"
    fallas=$((fallas + 1))
  else
    echo "✓ (abierta en las dos)"
  fi
else
  if grep -q 'NO construir' "$READMEP"; then
    echo "✓ (cerrada en las dos)"
  else
    echo "✗ FALLA"
    echo "     ALCANCE.md NO declara la compuerta abierta · README.md tampoco la frena"
    fallas=$((fallas + 1))
  fi
fi

echo
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · la frontera coincide con el disco"
  exit 0
fi
echo "ROJO · $fallas de 3 chequeos en falla"
exit 1

#!/usr/bin/env bash
# frontera.sh — el cable que mira HACIA AFUERA.
#
# `coherencia-contrato.sh` verifica que las vistas derivadas coincidan con la
# fuente: `docs/decisiones/` contra `FICHA.md` §10 y el artefacto de estado.
# Todo lo que mira vive DENTRO del contrato.
#
# Este mira la otra costura: la que une el contrato con el mundo — el artefacto
# que se instala y el catálogo de referencias. Ninguno estaba bajo cable, y los
# dos derivaron:
#
#   · el comando cambió dos veces sin que `plugin.json` se moviera
#   · el catálogo declaró 🔴 FALTANTES dos referencias que existían hace 10 días
#
# Es la misma estructura que `030` diagnosticó —una copia que no se declara
# copia y no apunta a su fuente— aplicada a la frontera en vez de al contrato.
# La regla de `030` sube un nivel: **el disco decide, la declaración orienta.**
#
# MISMAS DOS REGLAS DE DISEÑO que su hermano, por el mismo motivo:
#
#   FRENAR ≠ FALLAR. Precondición ausente → exit 2, dicho. Jamás silencio,
#   jamás verde. Por eso NO usa `set -e`.
#
#   ANCLAR DONDE VIVE LA VERDAD. Acá la verdad es el DISCO: qué archivo existe
#   y qué VALOR tiene la versión. No la fecha en que algo se tocó, ni la palabra
#   que un documento usa para describirlo. Las dos primeras versiones de este
#   cable fallaron justo ahí y están anotadas en cada chequeo.
#
# Sin arrays asociativos a propósito: corre en el bash 3.2 de macOS igual que
# en el runner. Un cable que solo anda en un intérprete ya mintió una vez.
#
# Uso: frontera.sh [ruta-del-repo]     (default: .)

set -uo pipefail

# El locale decide el orden de `*`, y con eso QUÉ archivo se lee cuando hay
# más de uno. El mismo repo daba veredictos opuestos en `C` y en `en_US.UTF-8`.
export LC_ALL=C

REPO="${1:-.}"
REFS="$REPO/docs/references"
CATALOGO="$REFS/README.md"
MANIFIESTO="plugins/batuta/.claude-plugin/plugin.json"
# El producto es TODO lo que se instala, menos el manifiesto que lo versiona.
# Antes era la lista blanca `plugins/batuta/commands`: hoy no producía ningún
# falso verde —el plugin solo tiene ese comando— pero un plugin de Claude Code
# se instala con cuatro superficies (commands, skills, agents, hooks), y una
# lista blanca hardcodeada envejece HACIA el falso verde: el día que se agregue
# un skill, cambiaría el producto sin que el cable lo viera.
PRODUCTO="plugins/ :(exclude)$MANIFIESTO"
fallas=0

echo "═══ Frontera — el contrato contra el disco ═══"
echo

# ── FRENO: sin las piezas no hay chequeo posible ────────────────────────
for req in "$CATALOGO" "$REPO/$MANIFIESTO"; do
  if [ ! -e "$req" ]; then
    echo "⛔ FRENA · no existe: $req"
    echo "   Esto NO es un verde: el chequeo no pudo correr."
    exit 2
  fi
done
echo "la verdad es el disco · vistas: ${CATALOGO#$REPO/} · ${MANIFIESTO}"
echo

# ── CHEQUEO 1 · el producto no cambia sin que la VERSIÓN se mueva ───────
# El manifiesto es lo único que le dice a una instalación que hay algo nuevo.
#
# La primera versión de este chequeo comparaba FECHAS de commit —«¿el comando
# se tocó después del manifiesto?»— y era falsa por los dos lados:
#   · falso negativo: un commit que tocaba el comando Y el manifiesto sin mover
#     el número daba VERDE. Peor, la propia batería definía «repo sano» así:
#     tenía el bug metido en su noción de sanidad.
#   · falso positivo: un revert que dejaba el árbol byte-idéntico al release
#     daba ROJO, porque la fecha se había movido aunque el contenido no.
# Por eso ahora ancla en el VALOR: desde el último commit que movió la versión,
# el producto no puede haber cambiado.
printf '1· el producto no cambia sin mover la versión '
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

ver_de() { printf '%s' "$1" | grep -o '"version"[^,]*' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1; }

# -G'"version"' = el último commit donde la LÍNEA de la versión cambió.
V_ANCLA=$(git -C "$REPO" log -1 --format=%H -G'"version"' -- "$MANIFIESTO" 2>/dev/null)
v_ahora=$(ver_de "$(cat "$REPO/$MANIFIESTO" 2>/dev/null)")

if [ -z "$V_ANCLA" ] || [ -z "$v_ahora" ]; then
  echo "⛔ FRENA"
  echo "     no puedo resolver la versión (ancla='$V_ANCLA' árbol='$v_ahora')"
  echo "     Esto NO es un verde: el chequeo no pudo evaluar nada."
  exit 2
fi
v_ancla=$(ver_de "$(git -C "$REPO" show "$V_ANCLA:$MANIFIESTO" 2>/dev/null)")

if [ "$v_ahora" != "$v_ancla" ]; then
  # El árbol lleva una versión más nueva que el último commit que la movió:
  # hay bump sin commitear. Es la única escotilla, y exige que el NÚMERO haya
  # cambiado — la versión anterior la daba cualquier byte tocado en el archivo.
  echo "✓ (v$v_ahora · bump sin commitear: $v_ancla → $v_ahora)"
elif git -C "$REPO" diff --quiet "$V_ANCLA" -- $PRODUCTO 2>/dev/null; then
  echo "✓ (v$v_ahora)"
else
  echo "✗ FALLA"
  echo "     el producto cambió y la versión NO se movió (sigue en v$v_ahora):"
  git -C "$REPO" diff --name-only "$V_ANCLA" -- $PRODUCTO 2>/dev/null | sed 's/^/       /'
  echo "     una copia instalada no tiene forma de saber que hay algo nuevo."
  fallas=$((fallas + 1))
fi

# ── CHEQUEO 2 · el catálogo de referencias contra el disco ──────────────
# 🔴 se define en el propio catálogo como «faltante (hay que generarla ANTES
# del encargo que la necesita)». Una 🔴 que existe manda a generar algo que
# está a un `ls` de distancia; una 🟢 que no existe promete lo contrario.
#
# Los TRES bucles exigen que la línea sea FILA DE TABLA. El tercero no lo hacía
# y barría el catálogo entero: una viñeta de prosa que nombrara `audit-tracker.md`
# entre backticks ponía el CI en rojo sobre un repo sano — en un documento cuyo
# tema son, justamente, las referencias `.md`. Es el pecado que este mismo cable
# arregla en su hermano, cometido doce líneas más abajo.
printf '2· catálogo de referencias == disco ..... '
prob=""; filas=0
while IFS= read -r linea; do
  case "$linea" in '|'*) ;; *) continue ;; esac
  path=$(printf '%s' "$linea" | grep -oE 'docs/references/[a-z0-9-]+\.md' | head -1)
  [ -z "$path" ] && continue
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
# es la misma mentira, en el segundo lugar donde vive. Se exige `|` al inicio
# Y que el nombre esté en la PRIMERA celda — donde vive el dato — para que una
# mención en prosa no dispare.
while IFS= read -r linea; do
  case "$linea" in '|'*) ;; *) continue ;; esac
  case "$linea" in *'~~'*) continue ;; esac
  b=$(printf '%s' "$linea" | cut -d'|' -f2 | grep -oE '`[a-z0-9-]+\.md`' | head -1 | tr -d '`')
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

# ── El chequeo 3 que NO está ────────────────────────────────────────────
# Hubo un tercer chequeo: «el README no puede decir NO construir si ALCANCE
# declara la compuerta ABIERTA». Se retiró, y el motivo importa más que el
# chequeo.
#
# Para escribirlo hubo que copiar al README el estado de la compuerta — y
# `ALCANCE.md:63` dice literal que ese estado «vive **solo acá** (README y
# FICHA apuntan a esta tabla, no lo repiten)». O sea: el cable no verificaba
# una copia legítima, CREABA la copia que el contrato prohíbe, y después la
# vigilaba. Encima castigaba conservar el rastro histórico, que `018` obliga a
# no borrar: una nota que citara la frase vieja ponía el CI en rojo.
#
# `030` ya había resuelto este caso exacto para §10: «no se ataca con un parser
# — se ataca reduciendo a punteros, que es lo que lo vuelve innecesario». El
# README quedó como puntero a `ALCANCE.md`, y con eso no hay nada que cablear.
#
# Se deja escrito porque un cable retirado sin motivo se vuelve a poner.

echo
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · la frontera coincide con el disco"
  exit 0
fi
echo "ROJO · $fallas de 2 chequeos en falla"
exit 1

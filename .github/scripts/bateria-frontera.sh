#!/usr/bin/env bash
# bateria-frontera.sh — verifica que el CABLE DE FRONTERA DETECTA.
#
# Hermana de `bateria-sembrada.sh`, mismo método y mismo motivo: `decisiones/030`
# fija que el criterio de aceptación NO es «el chequeo pasa» sino **que FALLE
# cuando debe**.
#
#   «Un cable mal puesto es peor que el cartel, porque el cartel no promete
#    nada. Un chequeo que nunca se vio fallar es una intención con formato
#    de comando.»
#
# Diferencia con su hermana: la caja es un REPO GIT DE VERDAD. El chequeo 1
# compara el VALOR de la versión entre commits, así que una caja de archivos
# sueltos no lo ejercita — lo haría FRENAR, y un escenario que frena no prueba
# que detecta.
#
# Dos clases de escenario, y las dos hacen falta:
#
#   Los drifts que OCURRIERON en este repo entre el 2026-07-21 y el 2026-07-31
#   — el catálogo mintiendo, el producto cambiando sin bump. No son casos de
#   laboratorio: son el motivo por el que existe el cable.
#
#   Los FALSOS POSITIVOS que la primera versión del cable producía — el revert
#   al árbol publicado, el basename entre backticks en prosa. Un cable que
#   grita sin motivo se desactiva solo, y ahí deja de ser cable.
#
# Cada escenario nombra en su comentario cuál de las dos cosas prueba.
#
# Códigos que se exigen:  0 = VERDE · 1 = ROJO (detectó) · 2 = FRENA (no evaluó)
#
# Uso: bateria-frontera.sh [ruta-del-repo]     (default: .)

set -uo pipefail

# El locale decide el orden de `*`: se fija para que el veredicto no dependa
# del entorno.
export LC_ALL=C

REPO="${1:-.}"
CABLE="$REPO/.github/scripts/frontera.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fallas=0; corridos=0

if [ ! -x "$CABLE" ]; then
  echo "⛔ FRENA · no encuentro el cable ejecutable en $CABLE"
  exit 2
fi
if ! command -v git >/dev/null 2>&1; then
  echo "⛔ FRENA · falta git — las cajas de esta batería son repos"
  exit 2
fi

# ── la caja: un repo git con UN commit ──────────────────────────────────
#
# La primera versión de esta función hacía un segundo commit con
# `printf '\n' >> plugin.json` y lo llamaba «el bump». **Tenía el bug del
# cable metido en su propia definición de repo sano**: un manifiesto tocado
# sin mover el número contaba como versión movida, que es exactamente el
# falso negativo que el cable dejaba pasar. La batería no podía cazar un
# defecto que usaba como referencia de sanidad.
#
# Ahora la caja es un solo commit y el bump se siembra donde corresponde:
# en el escenario que lo prueba.
caja_sana() {
  local caja="$1"
  mkdir -p "$caja/.github/scripts"
  cp -R "$REPO/docs" "$caja/docs"
  cp -R "$REPO/plugins" "$caja/plugins"
  cp "$REPO/README.md" "$caja/README.md"
  cp "$CABLE" "$caja/.github/scripts/"

  git -C "$caja" init -q 2>/dev/null
  git -C "$caja" config user.email cable@local
  git -C "$caja" config user.name cable
  git -C "$caja" config commit.gpgsign false
  git -C "$caja" add -A
  GIT_AUTHOR_DATE='2026-01-01T00:00:00Z' GIT_COMMITTER_DATE='2026-01-01T00:00:00Z' \
    git -C "$caja" commit -qm c1
}

# escenario <nombre> <exit-esperado> <qué-debe-decir> -- sembrador
escenario() {
  local nombre="$1" esperado="$2" pista="$3"; shift 3
  corridos=$((corridos + 1))
  local caja="$TMP/caja-$corridos"
  rm -rf "$caja"; mkdir -p "$caja"
  caja_sana "$caja"

  SEMBRAR_EN="$caja" "$@"          # el sembrador planta el defecto

  local salida rc
  salida=$("$CABLE" "$caja" 2>&1); rc=$?

  printf '  %-46s ' "$nombre"
  if [ "$rc" -ne "$esperado" ]; then
    echo "✗ esperaba exit $esperado, dio $rc"
    printf '%s\n' "$salida" | sed 's/^/        /'
    fallas=$((fallas + 1))
    return
  fi
  if ! printf '%s' "$salida" | grep -q "$pista"; then
    echo "✗ exit $rc correcto, pero no dijo por qué"
    echo "        esperaba encontrar: $pista"
    printf '%s\n' "$salida" | sed 's/^/        /'
    fallas=$((fallas + 1))
    return
  fi
  echo "✓ exit $rc"
}

# ── sembradores ─────────────────────────────────────────────────────────
# Solo git, sed y grep. Un chequeo cuya verificación depende de herramientas
# ausentes en el runner es frágil justo donde tiene que ser firme.
edita() { sed -i.bak "$1" "$2" && rm -f "$2.bak"; }

commit_en() {   # commit_en <caja> <fecha> — sella lo sembrado con fecha propia
  git -C "$1" add -A
  GIT_AUTHOR_DATE="$2" GIT_COMMITTER_DATE="$2" git -C "$1" commit -qm sembrado
}

s_sano()         { :; }
bump()  { sed -i.bak "s/\"version\": \"[0-9.]*\"/\"version\": \"$2\"/" \
            "$1/plugins/batuta/.claude-plugin/plugin.json" && \
          rm -f "$1/plugins/batuta/.claude-plugin/plugin.json.bak"; }

# 1 · el drift del 2026-07-28→30: S15 y S16 tocaron el comando, la versión no se movió
s_producto_adelanta() {
  printf '\n<!-- cambio de producto -->\n' >> "$SEMBRAR_EN/plugins/batuta/commands/batuta.md"
  commit_en "$SEMBRAR_EN" '2026-12-01T00:00:00Z'; }

# 1c · una superficie del plugin que NO es commands/. Un plugin de Claude Code
# se instala con cuatro (commands, skills, agents, hooks); la primera versión
# del cable solo miraba commands/, así que esto era un falso verde esperando
# a que el plugin creciera.
s_skill_nuevo() {
  mkdir -p "$SEMBRAR_EN/plugins/batuta/skills/compuerta"
  printf -- '---\nname: compuerta\n---\n# skill nuevo\n' \
    > "$SEMBRAR_EN/plugins/batuta/skills/compuerta/SKILL.md"
  commit_en "$SEMBRAR_EN" '2026-12-01T00:00:00Z'; }

# 1b · el MISMO commit toca comando y manifiesto, sin mover el número.
# Éste es el que la versión por-fechas dejaba pasar en VERDE, y es la forma
# más común de todas: tocás el comando y de paso una `keyword` del manifiesto.
s_producto_y_manifiesto() {
  printf '\n<!-- cambio de producto -->\n' >> "$SEMBRAR_EN/plugins/batuta/commands/batuta.md"
  sed -i.bak 's/"displayName": "batuta"/"displayName": "batuta "/' \
    "$SEMBRAR_EN/plugins/batuta/.claude-plugin/plugin.json"
  rm -f "$SEMBRAR_EN/plugins/batuta/.claude-plugin/plugin.json.bak"
  commit_en "$SEMBRAR_EN" '2026-12-01T00:00:00Z'; }

# 2 · el drift del catálogo: 🔴 FALTANTE sobre un archivo que existe hace 10 días
s_roja_que_existe() {
  edita '\#docs/references/audit-tracker.md#s/| 🟢 |/| 🔴 |/' "$SEMBRAR_EN/docs/references/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# 3 · el inverso: el catálogo promete fresca una referencia que no está en el disco
s_verde_que_falta() {
  rm -f "$SEMBRAR_EN/docs/references/audit-tracker.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# 4 · una referencia entra al disco y nadie la agrega al catálogo
s_ref_huerfana() {
  printf -- '---\nfecha: 2026-07-31\n---\n# ref nueva\n' > "$SEMBRAR_EN/docs/references/ref-nueva.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# 5 · la fila de «Faltantes con su encargo» que quedó sin tachar diez días
s_faltante_sin_tachar() {
  printf '\n| `audit-tracker.md` | S03 | Pendiente |\n' >> "$SEMBRAR_EN/docs/references/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# FRENAS
s_sin_git()      { rm -rf "$SEMBRAR_EN/.git"; }
s_sin_catalogo() { rm -f "$SEMBRAR_EN/docs/references/README.md"
                   commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }
# el catálogo existe pero sin una sola fila evaluable: no hay nada que comparar
s_catalogo_sin_filas() {
  grep -v '^|' "$SEMBRAR_EN/docs/references/README.md" > "$SEMBRAR_EN/c.tmp"
  mv "$SEMBRAR_EN/c.tmp" "$SEMBRAR_EN/docs/references/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# ── ANTI-FALSO-POSITIVO ─────────────────────────────────────────────────
# Un cable que grita sin motivo se desactiva solo: la gente aprende a
# ignorarlo, y entonces deja de ser cable.

# El path COMPLETO citado en prosa. Este escenario existía y NO probaba nada:
# la clase `[a-z0-9-]+` no matchea la barra de `docs/references/`, así que
# esquivaba la rama que decía cubrir. Se conserva y se le suma el de abajo,
# que es el que de verdad rompía.
s_path_en_prosa() {
  printf '\nVer `docs/references/no-existe-todavia.md` cuando se escriba.\n' \
    >> "$SEMBRAR_EN/docs/references/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# El BASENAME pelado entre backticks — la forma natural de nombrar una
# referencia en un documento cuyo tema son las referencias. Ponía el CI en
# rojo sobre un repo sano.
s_backtick_en_prosa() {
  printf '\n> Recordatorio: `audit-tracker.md` se revalida cada 3 meses.\n' \
    >> "$SEMBRAR_EN/docs/references/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# El bump BIEN hecho: el mismo commit mueve el comando y el número.
s_bump_correcto() {
  printf '\n<!-- cambio de producto -->\n' >> "$SEMBRAR_EN/plugins/batuta/commands/batuta.md"
  bump "$SEMBRAR_EN" 9.9.9
  commit_en "$SEMBRAR_EN" '2026-12-01T00:00:00Z'; }

# El revert que devuelve el árbol al estado del release. La versión por fechas
# daba ROJO acá: la fecha se había movido dos veces aunque el contenido no.
s_revert() {
  printf '\n<!-- typo -->\n' >> "$SEMBRAR_EN/plugins/batuta/commands/batuta.md"
  commit_en "$SEMBRAR_EN" '2026-12-01T00:00:00Z'
  git -C "$SEMBRAR_EN" revert --no-edit -n HEAD >/dev/null 2>&1
  commit_en "$SEMBRAR_EN" '2026-12-02T00:00:00Z'; }

echo "═══ Batería de frontera — ¿el cable DETECTA? ═══"
echo
echo "control (el repo sano tiene que pasar):"
escenario "repo sin sembrar" 0 "VERDE" s_sano

echo
echo "el cable tiene que ponerse ROJO (exit 1):"
escenario "el comando cambia y la versión no se mueve"  1 "la versión NO se movió"       s_producto_adelanta
escenario "mismo commit toca comando y manifiesto"      1 "la versión NO se movió"       s_producto_y_manifiesto
escenario "un skill nuevo (no commands/) sin bump"      1 "la versión NO se movió"       s_skill_nuevo
escenario "catálogo declara 🔴 una referencia que existe" 1 "declara 🔴 FALTANTE"          s_roja_que_existe
escenario "catálogo declara fresca una que no está"     1 "el archivo NO existe"          s_verde_que_falta
escenario "referencia en disco sin fila en el catálogo" 1 "el catálogo no la lista"       s_ref_huerfana
escenario "faltante-con-encargo ya generada, sin tachar" 1 "listada como faltante"        s_faltante_sin_tachar

echo
echo "el cable tiene que FRENAR, no dar verde (exit 2):"
escenario "no es un repo git"              2 "FRENA" s_sin_git
escenario "no hay catálogo de referencias" 2 "FRENA" s_sin_catalogo
escenario "catálogo sin filas evaluables"  2 "FRENA" s_catalogo_sin_filas

echo
echo "y NO tiene que dar falso positivo:"
escenario "path completo citado en prosa"     0 "VERDE" s_path_en_prosa
escenario "basename entre backticks en prosa" 0 "VERDE" s_backtick_en_prosa
escenario "bump correcto: comando + versión"  0 "VERDE" s_bump_correcto
escenario "revert que vuelve al árbol publicado" 0 "VERDE" s_revert

echo
echo "───────────────────────────────────────────────"
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · $corridos/$corridos escenarios · el cable detecta lo que promete"
  exit 0
fi
echo "ROJO · $fallas de $corridos escenarios fallaron"
echo "El cable NO detecta lo que promete. Eso es peor que no tenerlo (030)."
exit 1

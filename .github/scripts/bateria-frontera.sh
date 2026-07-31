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
# Diferencia con su hermana: la caja es un REPO GIT DE VERDAD, con fechas de
# commit controladas. El chequeo 1 compara qué commit tocó qué, así que una
# caja de archivos sueltos no lo ejercita — lo haría FRENAR, y un escenario
# que frena no prueba que detecta.
#
# Los cinco drifts que se siembran son los CINCO QUE OCURRIERON DE VERDAD en
# este repo entre el 2026-07-21 y el 2026-07-31. No son casos de laboratorio:
# son el motivo por el que existe el cable.
#
# Códigos que se exigen:  0 = VERDE · 1 = ROJO (detectó) · 2 = FRENA (no evaluó)
#
# Uso: bateria-frontera.sh [ruta-del-repo]     (default: .)

set -uo pipefail

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

# ── la caja: un repo git con DOS commits fechados ───────────────────────
# c1 (viejo) = todo el repo · c2 (nuevo) = solo el manifiesto.
# Así el árbol sano tiene el manifiesto más nuevo que el comando, que es
# exactamente la invariante que el chequeo 1 exige.
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
  git -C "$caja" add -A
  GIT_AUTHOR_DATE='2026-01-01T00:00:00Z' GIT_COMMITTER_DATE='2026-01-01T00:00:00Z' \
    git -C "$caja" commit -qm c1
  # c2: mueve el manifiesto, más tarde
  printf '\n' >> "$caja/plugins/batuta/.claude-plugin/plugin.json"
  git -C "$caja" add -A
  GIT_AUTHOR_DATE='2026-06-01T00:00:00Z' GIT_COMMITTER_DATE='2026-06-01T00:00:00Z' \
    git -C "$caja" commit -qm c2
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

# 1 · el drift del 2026-07-28→30: S15 y S16 tocaron el comando, la versión no se movió
s_producto_adelanta() {
  printf '\n<!-- cambio de producto -->\n' >> "$SEMBRAR_EN/plugins/batuta/commands/batuta.md"
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

# 6 · el drift del README: la compuerta abrió el 19-07 y la puerta siguió cerrada
s_readme_stale() {
  printf '\n> ⛔ COMPUERTA: NO construir hasta que el segundo cimiento esté sólido.\n' \
    >> "$SEMBRAR_EN/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# FRENAS
s_sin_git()      { rm -rf "$SEMBRAR_EN/.git"; }
s_sin_catalogo() { rm -f "$SEMBRAR_EN/docs/references/README.md"
                   commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

# ANTI-FALSO-POSITIVO: el path citado en PROSA no es una fila del catálogo.
# Es el mismo pecado que el `grep PENDIENTE` a lo bruto de la batería hermana:
# anclar en la palabra en vez de en la estructura.
s_path_en_prosa() {
  printf '\nVer `docs/references/no-existe-todavia.md` cuando se escriba.\n' \
    >> "$SEMBRAR_EN/docs/references/README.md"
  commit_en "$SEMBRAR_EN" '2026-06-02T00:00:00Z'; }

echo "═══ Batería de frontera — ¿el cable DETECTA? ═══"
echo
echo "control (el repo sano tiene que pasar):"
escenario "repo sin sembrar" 0 "VERDE" s_sano

echo
echo "el cable tiene que ponerse ROJO (exit 1):"
escenario "el comando cambia y la versión no se mueve"  1 "DESPUÉS del último bump"      s_producto_adelanta
escenario "catálogo declara 🔴 una referencia que existe" 1 "declara 🔴 FALTANTE"          s_roja_que_existe
escenario "catálogo declara fresca una que no está"     1 "el archivo NO existe"          s_verde_que_falta
escenario "referencia en disco sin fila en el catálogo" 1 "el catálogo no la lista"       s_ref_huerfana
escenario "faltante-con-encargo ya generada, sin tachar" 1 "listada como faltante"        s_faltante_sin_tachar
escenario "README frena una compuerta que ya está abierta" 1 "dice «NO construir»"        s_readme_stale

echo
echo "el cable tiene que FRENAR, no dar verde (exit 2):"
escenario "no es un repo git"          2 "FRENA" s_sin_git
escenario "no hay catálogo de referencias" 2 "FRENA" s_sin_catalogo

echo
echo "y NO tiene que dar falso positivo:"
escenario "path citado en prosa, no en fila" 0 "VERDE" s_path_en_prosa

echo
echo "───────────────────────────────────────────────"
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · $corridos/$corridos escenarios · el cable detecta lo que promete"
  exit 0
fi
echo "ROJO · $fallas de $corridos escenarios fallaron"
echo "El cable NO detecta lo que promete. Eso es peor que no tenerlo (030)."
exit 1

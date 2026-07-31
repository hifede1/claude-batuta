#!/usr/bin/env bash
# bateria-sembrada.sh — verifica que el CABLE DETECTA.
#
# `decisiones/030` fija que el criterio de aceptación NO es «el chequeo pasa»
# sino **que FALLE cuando debe**:
#
#   «Un cable mal puesto es peor que el cartel, porque el cartel no promete
#    nada. Un chequeo que nunca se vio fallar es una intención con formato
#    de comando.»
#
# Esta batería siembra el defecto y exige el veredicto correcto. Corre en cada
# PR junto al chequeo, así la garantía no es histórica sino vigente: si alguien
# rompe la detección, esto se pone rojo aunque el repo esté sano.
#
# Método: **corrida sembrada**, el que `decisiones/006` fija para este proyecto
# (markdown puro → sin tests unitarios → se verifica corriendo).
#
# Códigos que se exigen:  0 = VERDE · 1 = ROJO (detectó) · 2 = FRENA (no evaluó)
#
# Uso: bateria-sembrada.sh [ruta-del-repo]     (default: .)

set -uo pipefail

REPO="${1:-.}"
CABLE="$REPO/.github/scripts/coherencia-contrato.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fallas=0; corridos=0

if [ ! -x "$CABLE" ]; then
  echo "⛔ FRENA · no encuentro el cable ejecutable en $CABLE"
  exit 2
fi

# escenario <nombre> <exit-esperado> <qué-debe-decir> -- sembrador
escenario() {
  local nombre="$1" esperado="$2" pista="$3"; shift 3
  corridos=$((corridos + 1))
  local caja="$TMP/caja-$corridos"
  rm -rf "$caja"; mkdir -p "$caja"
  cp -R "$REPO/docs" "$caja/docs"
  mkdir -p "$caja/.github/scripts"
  cp "$CABLE" "$caja/.github/scripts/"

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
# Solo jq, sed y grep: los sembradores NO deben necesitar nada instalado.
# Un chequeo cuya verificación depende de herramientas ausentes en el runner
# es frágil justo donde tiene que ser firme.
edita() { sed -i.bak "$1" "$2" && rm -f "$2.bak"; }
saca()  { grep -v "$1" "$2" > "$2.tmp" && mv "$2.tmp" "$2"; }

s_sano()        { :; }
s_drift_json()  { j=$(ls "$SEMBRAR_EN"/docs/audits/*-estado.json | head -1)
                  jq '.decisiones_pendientes = ["026 — operaciones administrativas"]' "$j" > "$j.x" && mv "$j.x" "$j"; }
s_pend_oculto() { edita 's/^\*\*Estado:\*\* ✅ \*\*FIRMADA\*\*/**Estado:** ⏳ **PENDIENTE**/' \
                    "$SEMBRAR_EN/docs/decisiones/028-sin-cuenta-de-agente.md"; }
s_sin_sello()   { edita 's/^\*\*Estado:\*\*/**Situación:**/' \
                    "$SEMBRAR_EN/docs/decisiones/001-mono-proyecto.md"; }
s_ficha_miente(){ edita '\#decisiones/023-#s/✅ FIRMADA/⏳ PENDIENTE/' \
                    "$SEMBRAR_EN/docs/FICHA.md"; }
s_huerfano()    { saca 'decisiones/022-asiento' "$SEMBRAR_EN/docs/FICHA.md"; }
# El huérfano de arriba se detectaba POR CASUALIDAD: el chequeo inverso hacía
# grep sobre el archivo entero, y `022` solo aparece en §10. `007` en cambio
# está citado en prosa (FICHA.md:91), así que le bastaba esa mención para
# quedar inmune: se le sacaba la fila y el cable contestaba «✓ ninguna
# huérfana». Este escenario ancla la detección donde vive la entrada.
s_huerfano_citado() { saca '^|.*decisiones/007-' "$SEMBRAR_EN/docs/FICHA.md"; }
s_sin_json()    { rm -f "$SEMBRAR_EN"/docs/audits/*-estado.json; }
s_ficha_prosa() { saca '^| \[' "$SEMBRAR_EN/docs/FICHA.md"; }
s_mencion()     { printf '\n> nota: mientras esto siga ⏳ PENDIENTE rige la opción 1.\n' \
                    >> "$SEMBRAR_EN/docs/decisiones/001-mono-proyecto.md"; }

echo "═══ Batería sembrada — ¿el cable DETECTA? ═══"
echo
echo "control (el repo sano tiene que pasar):"
escenario "repo sin sembrar" 0 "VERDE" s_sano

echo
echo "el cable tiene que ponerse ROJO (exit 1):"
escenario "artefacto lista un ADR firmado como PENDIENTE" 1 "el artefacto lista 026" s_drift_json
escenario "ADR pasa a PENDIENTE y el artefacto no lo sabe" 1 "el ADR 028 está PENDIENTE" s_pend_oculto
escenario "un ADR pierde su línea de sello"               1 "sin línea"                 s_sin_sello
escenario "§10 declara un estado distinto al del ADR"     1 "§10 declara 023"           s_ficha_miente
escenario "un ADR de la fuente sin fila en §10"           1 "§10 no lo lista"           s_huerfano
escenario "huérfano de un ADR citado en la prosa"        1 "§10 no lo lista como fila" s_huerfano_citado

echo
echo "el cable tiene que FRENAR, no dar verde (exit 2):"
escenario "no hay artefacto de estado"        2 "FRENA" s_sin_json
escenario "§10 sin filas evaluables (prosa)"  2 "FRENA" s_ficha_prosa

echo
echo "y NO tiene que dar falso positivo:"
escenario "PENDIENTE mencionado en la prosa de un ADR" 0 "VERDE" s_mencion

echo
echo "y NO tiene que dar verde bajo un intérprete que no soporta:"
# El cable usa `declare -A` (bash 4+). Bajo el bash 3.2 de macOS el array
# asociativo moría y el script SEGUÍA: los chequeos 1 y 2 imprimían ✓ sobre
# una fracción de los ADRs («✓ 8 ADRs» cuando eran 28). Verde sobre datos
# rotos, el pecado exacto del encabezado, cometido por el propio cable.
#
# No se puede sembrar copiando archivos: hay que INVOCARLO con otro bash. Si
# la máquina no tiene uno viejo, se DECLARA que no se corrió — un escenario
# salteado en silencio se lee igual que uno que pasó, que es la misma falla.
viejo=""
for cand in /bin/bash /usr/bin/bash; do
  [ -x "$cand" ] || continue
  v=$("$cand" -c 'echo ${BASH_VERSINFO[0]}' 2>/dev/null)
  case "$v" in ''|*[!0-9]*) continue ;; esac
  [ "$v" -lt 4 ] && { viejo="$cand"; break; }
done
printf '  %-46s ' "cable corrido con bash < 4"
if [ -z "$viejo" ]; then
  echo "— NO CORRIDO · esta máquina no tiene un bash < 4"
else
  corridos=$((corridos + 1))
  salida=$("$viejo" "$CABLE" "$REPO" 2>&1); rc=$?
  if [ "$rc" -eq 2 ] && printf '%s' "$salida" | grep -q "requiere bash 4"; then
    echo "✓ exit 2 ($("$viejo" -c 'echo $BASH_VERSION'))"
  else
    echo "✗ esperaba exit 2 con «requiere bash 4», dio $rc"
    printf '%s\n' "$salida" | sed 's/^/        /'
    fallas=$((fallas + 1))
  fi
fi

echo
echo "───────────────────────────────────────────────"
if [ "$fallas" -eq 0 ]; then
  echo "VERDE · $corridos/$corridos escenarios · el cable detecta lo que promete"
  exit 0
fi
echo "ROJO · $fallas de $corridos escenarios fallaron"
echo "El cable NO detecta lo que promete. Eso es peor que no tenerlo (030)."
exit 1

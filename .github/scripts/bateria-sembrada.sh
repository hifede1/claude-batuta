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

# El locale decide el orden de `*`: se fija para que el veredicto no dependa
# del entorno. El mismo repo daba ROJO en `C` y VERDE en `en_US.UTF-8`.
export LC_ALL=C

REPO="${1:-.}"
CABLE="$REPO/.github/scripts/coherencia-contrato.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fallas=0; corridos=0; no_corridos=0

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
#
# La siembra hace DOS cosas, y la segunda es la que prueba algo: saca la fila
# Y pasa a MAYÚSCULA la palabra «firmada» de la prosa que cita al ADR. Sin eso
# el escenario pasaba **por casualidad** —la prosa de :91 dice «firmada» en
# minúscula, así que no matcheaba el `case` de estados— y certificaba un
# arreglo que no estaba hecho. La garantía valía un carácter.
s_huerfano_citado() {
  saca '^|.*decisiones/007-' "$SEMBRAR_EN/docs/FICHA.md"
  edita 's/(firmada 2026-07-19/(FIRMADA 2026-07-19/' "$SEMBRAR_EN/docs/FICHA.md"; }

# El espejo del anterior: prosa FUERA de §10 que nombra un ADR y escribe un
# estado en mayúscula. Entraba como fila fantasma y ponía el cable en ROJO
# acusando a §10 de decir algo que §10 no dice. Falso negativo y falso
# positivo, la misma causa.
s_prosa_fuera_de_10() {
  printf '\n- Nota: ver [`030`](decisiones/030-coherencia-del-contrato.md), quedó FIRMADA el 30-07.\n' \
    >> "$SEMBRAR_EN/docs/FICHA.md"; }
s_sin_json()    { rm -f "$SEMBRAR_EN"/docs/audits/*-estado.json; }

# Un ADR FIRMADA sin su Procedencia: sello sin acto, que es lo que `018` llama
# falsificación. Tiene que dar ROJO.
s_firmada_sin_proc() {
  saca '^\*\*Procedencia de la firma' "$SEMBRAR_EN/docs/decisiones/030-coherencia-del-contrato.md"; }

# Y su espejo: abrir un ADR ⏳ PENDIENTE, el caso que `024` reserva para cuando
# la elección humana todavía no ocurrió. No tiene firma, así que NO puede tener
# procedencia de una firma — y tiene que dar VERDE. El cable lo ponía en rojo, y
# el único modo de apagarlo era inventar la procedencia de un acto que no pasó.
#
# ⚠️ EL NÚMERO SEMBRADO ES `999` Y NO EL SIGUIENTE LIBRE. La primera versión
# sembraba `031` —el que venía— y funcionó hasta que `031` **existió de verdad**
# el 2026-07-31: dos archivos con el mismo prefijo, el sello leído era el de la
# siembra, y la batería se puso roja acusando al cable de un drift que había
# creado ella. Un número fijo bajo envejece HACIA la colisión; `999` está fuera
# del rango que el proyecto va a usar.
#
# ⚠️ Y EL SEMBRADO ES `+=`, NO `=` — la MISMA clase de defecto, descubierta un
# renglón más abajo el 2026-08-03. La asignación REEMPLAZABA
# `decisiones_pendientes` entera, y eso funcionó mientras el repo no tuvo
# ningún ADR ⏳ PENDIENTE real: la lista estaba vacía y pisarla no borraba nada.
# El día que `033` nació PENDIENTE (S19/H1), el escenario lo sacó de la vista
# mientras su archivo seguía en la fuente, y el chequeo 2 falló **con razón** —
# la batería volvió a acusar al cable de un drift que había creado ella, por
# segunda vez y por el mismo motivo de fondo: **el escenario asumía un estado
# del repo en vez de agregarse a él.** Arreglar el número y dejar la asignación
# era curar el síntoma. Con `+=` el escenario prueba lo suyo sin depender de
# cuántos pendientes reales haya.
s_adr_pendiente_nuevo() {
  printf -- '# 999 — prueba\n\n**Estado:** ⏳ **PENDIENTE** · dueño: Fede\n\n## Contexto\n\nSin elegir todavía.\n' \
    > "$SEMBRAR_EN/docs/decisiones/999-prueba.md"
  edita 's#^| \[`030`\].*#&\n| [`999`](decisiones/999-prueba.md) | Prueba | ⏳ PENDIENTE | — | — |#' \
    "$SEMBRAR_EN/docs/FICHA.md"
  j=$(ls "$SEMBRAR_EN"/docs/audits/*-estado.json | head -1)
  jq '.decisiones_pendientes += ["999 — prueba"]' "$j" > "$j.x" && mv "$j.x" "$j"
  sync_trk; }
# Una entrada de `decisiones_pendientes` que CITA otro ADR en su texto libre.
# El ID es el primer número de la entrada; los demás son prosa. Sin esto, una
# entrada legítima como «031 — … (supera 027 punto 4)» declaraba dos pendientes
# y el cable acusaba a un ADR FIRMADO de estar pendiente.
s_pend_cita_otro() {
  j=$(ls "$SEMBRAR_EN"/docs/audits/*-estado.json | head -1)
  jq '.decisiones_pendientes += ["999 — prueba (supera 027 punto 4)"]' "$j" > "$j.x" && mv "$j.x" "$j"
  printf -- '# 999 — prueba\n\n**Estado:** \xe2\x8f\xb3 **PENDIENTE** \xc2\xb7 due\xc3\xb1o: Fede\n' \
    > "$SEMBRAR_EN/docs/decisiones/999-prueba.md"
  edita 's#^| \[`030`\].*#&\n| [`999`](decisiones/999-prueba.md) | Prueba | \xe2\x8f\xb3 PENDIENTE | \xe2\x80\x94 | \xe2\x80\x94 |#' \
    "$SEMBRAR_EN/docs/FICHA.md"
  sync_trk; }
# ── SIEMBRA DEL CHEQUEO 6 (S20 · deuda que dejó S19/H1) ────────────────
# El chequeo 6 se vio fallar A MANO contra el repo real y nunca quedó
# sembrado. Un cable que sólo se probó una vez a mano tiene su garantía en
# el pasado; ésta la pone en cada PR. Es la deuda que S19/H1 declaró y que
# S20 cierra porque toca esta misma batería.
#
# El defecto: un documento fuera de `references/` MATERIALIZA un mecanismo
# de identidad dentro de un fence. Se siembra en `ALCANCE.md` —no en
# `PLAN.md`, que ya fue el caso real— para que el escenario no dependa de
# qué archivo tuvo el problema aquella vez.
s_mecanismo_fuera_de_refs() {
  printf '\n```\nGH_TOKEN=$(gh auth token --user agente) gh pr create\n```\n' \
    >> "$SEMBRAR_EN/docs/ALCANCE.md"; }

# Y su espejo, que es el que protege de un cable demasiado goloso: el mismo
# mecanismo NOMBRADO EN PROSA con backticks tiene que dar VERDE. Este repo
# narra la historia de `025`/`027`/`028` todo el tiempo y hablar de un
# mecanismo no es prescribirlo. Sin este escenario, un futuro «endurecimiento»
# del chequeo 6 a grep de palabra suelta pasaría sin que nadie lo note.
s_mecanismo_en_prosa() {
  printf '\n> Nota: el agente lo implementó con `gh auth switch`, y eso fue el error.\n' \
    >> "$SEMBRAR_EN/docs/ALCANCE.md"; }

# ── SIEMBRA DEL CHEQUEO 7 · el tracker HTML (S20) ──────────────────────
# Una dimensión por escenario: si uno solo cubriera las cuatro, el día que
# tres dejaran de compararse el escenario seguiría en rojo por la cuarta y
# nadie se enteraría. Cada uno rompe UNA cosa.
TRK='docs/audits/batuta-tracker.html'

# `sync_trk` — deja el tracker COHERENTE con lo que el escenario sembró.
#
# Por qué hace falta, y es la lección de esta siembra: el chequeo 7 acopla el
# HTML a tres cosas que otros escenarios ya movían —`last_audit`,
# `closed_count` y la cantidad de ADRs—. Sin esto, un escenario que adelanta
# el reloj para probar los chequeos 4 y 5 se ponía rojo **por el 7**, y
# fallaba por una dimensión que no venía a probar. El escenario dejaba de
# medir lo suyo.
#
# La regla que fija: **un escenario deja el repo sembrado coherente en todo
# MENOS en la dimensión que prueba.** Si rompe dos cosas a la vez, su
# veredicto no dice cuál de las dos detectó el cable.
#
# LÍMITE: no sincroniza la cantidad de BLOQUES. Ningún escenario los mueve
# hoy —el único que lo hace es `s_trk_bloque`, y ése BUSCA el rojo—. Se
# declara en vez de escribir código muerto que nadie ejercita.
sync_trk() {
  local t="$SEMBRAR_EN/$TRK" j
  [ -f "$t" ] || return 0
  j=$(ls "$SEMBRAR_EN"/docs/audits/*-estado.json 2>/dev/null | head -1)
  [ -f "$j" ] || return 0
  edita "s/^const LAST_AUDIT = '[^']*';/const LAST_AUDIT = '$(jq -r '.last_audit // empty' "$j")';/" "$t"
  edita "s/^const CLOSED_COUNT = [0-9]*;/const CLOSED_COUNT = $(jq -r '.closed_count // empty' "$j");/" "$t"
  # Una entrada dummy por cada ADR que la fuente tenga de más.
  local want have
  want=$(ls "$SEMBRAR_EN"/docs/decisiones/[0-9][0-9][0-9]-*.md 2>/dev/null | wc -l | tr -d ' ')
  have=$(grep -cE "id:[[:space:]]*'d[0-9]{3}'" "$t")
  # Se ancla en la ÚLTIMA línea que ya declara un ADR y se le pega la entrada
  # nueva en la MISMA línea (`},{id:…},` es JS válido dentro del array).
  #
  # El primer intento anclaba en `^];` — y ese patrón engancha el cierre del
  # PRIMER array del archivo, que es `DATA`, no `DECISIONS`. La entrada
  # aterrizaba en la estructura equivocada y el conteo no se movía: el
  # escenario seguía rojo y la causa era invisible. Anclar en «el cierre de un
  # array» cuando hay ocho arrays es la misma clase de error que anclar en la
  # palabra en vez del dato (`030` §3).
  # Y el ancla exige `},$` EN EL PATRÓN DE BÚSQUEDA, no sólo en la
  # sustitución. Segundo supuesto falso del mismo helper: la última línea con
  # `id:'dNNN'` **no es la última entrada del array** —los ADRs no están en
  # orden en el archivo— y esa línea termina en `'}` **sin coma**, así que la
  # sustitución no matcheaba nada y el conteo no se movía. Silencioso, como el
  # anterior. Se busca una línea que YA termine en `},`: ésa admite el pegado.
  local ln
  while [ "$have" -lt "$want" ]; do
    ln=$(grep -nE "id:[[:space:]]*'d[0-9]{3}'.*\},\$" "$t" | tail -1 | cut -d: -f1)
    [ -n "$ln" ] || break
    edita "${ln}s|},\$|},{id:'d9$have', n:'9$have', t:'sembrado', estado:'aceptada', fecha:'2020-01-01', ctx:'x', dec:'x', cons:'x', link:'x'},|" "$t"
    have=$((have + 1))
  done
}
s_trk_fecha()   { edita "s/^const LAST_AUDIT = '[^']*';/const LAST_AUDIT = '2020-01-01';/" \
                    "$SEMBRAR_EN/$TRK"; }
s_trk_contador(){ edita 's/^const CLOSED_COUNT = [0-9]*;/const CLOSED_COUNT = 1;/' \
                    "$SEMBRAR_EN/$TRK"; }
s_trk_bloque()  { j=$(ls "$SEMBRAR_EN"/docs/audits/*-estado.json | head -1)
                  jq '.bloques += [{"id":"b99","nombre":"sembrado","zona":"x","estado":"hecho","pendientes":[]}]' \
                    "$j" > "$j.x" && mv "$j.x" "$j"; }
s_trk_adr()     { printf -- '# 998 — prueba\n\n**Estado:** ✅ **FIRMADA** · 2020-01-01 · **Firmada por:** Fede\n**Procedencia de la firma:** sembrado.\n' \
                    > "$SEMBRAR_EN/docs/decisiones/998-prueba.md"
                  edita 's#^| \[`030`\].*#&\n| [`998`](decisiones/998-prueba.md) | Prueba | ✅ FIRMADA | 2020-01-01 | — |#' \
                    "$SEMBRAR_EN/docs/FICHA.md"; }
s_trk_ausente() { rm -f "$SEMBRAR_EN/$TRK"; }

s_ficha_prosa() { saca '^| \[' "$SEMBRAR_EN/docs/FICHA.md"; }
s_mencion()     { printf '\n> nota: mientras esto siga ⏳ PENDIENTE rige la opción 1.\n' \
                    >> "$SEMBRAR_EN/docs/decisiones/001-mono-proyecto.md"; }

# ── chequeos 4 y 5: LA FRESCURA DE LAS VISTAS (S17) ─────────────────────
#
# Las dos vistas que envejecen solas —`last_audit` del artefacto y la estampa
# de FICHA.md— se comparan contra UN reloj: la fecha de sello más reciente de
# `docs/decisiones/`. Los sembradores NO dependen del estado del repo base:
# plantan fechas absolutas, así que siguen probando lo mismo dentro de un año.
# Un escenario que solo funciona mientras el repo esté en cierto estado prueba
# el repo, no el cable.
VIEJA=2020-01-01     # anterior a todo sello que este proyecto vaya a tener
NUEVA=2099-01-01     # posterior a todo sello, sin depender de calcular el reloj

j_de() { ls "$1"/docs/audits/*-estado.json | head -1; }
estampa() { edita "4s#^> Firmado:.*#> Firmado: $1#" "$2/docs/FICHA.md"; }

# ROJO — la vista quedó atrás del reloj de la fuente.
s_artefacto_atrasado() { j=$(j_de "$SEMBRAR_EN")
                         jq --arg d "$VIEJA" '.last_audit = $d' "$j" > "$j.x" && mv "$j.x" "$j"; }
s_estampa_atrasada()   { estampa "$VIEJA por Fede" "$SEMBRAR_EN"; }

# FRENA — sin campo no hay comparación posible, y eso NO es un verde.
s_sin_last_audit()     { j=$(j_de "$SEMBRAR_EN")
                         jq 'del(.last_audit)' "$j" > "$j.x" && mv "$j.x" "$j"; }
s_last_audit_ilegible(){ j=$(j_de "$SEMBRAR_EN")
                         jq '.last_audit = "hace unos dias"' "$j" > "$j.x" && mv "$j.x" "$j"; }
s_sin_estampa()        { saca '^> Firmado:' "$SEMBRAR_EN/docs/FICHA.md"; }
s_estampa_ilegible()   { estampa "el lunes pasado por Fede" "$SEMBRAR_EN"; }

# VERDE — las dos vistas al día. Se siembran juntas porque el control del repo
# sano no sirve para esto: mientras el repo real esté atrasado daría rojo por
# el motivo correcto, y entonces el escenario no distinguiría un cable que
# funciona de uno que dice rojo siempre.
s_vistas_al_dia() { j=$(j_de "$SEMBRAR_EN")
                         jq --arg d "$NUEVA" '.last_audit = $d' "$j" > "$j.x" && mv "$j.x" "$j"
                         estampa "$NUEVA por Fede" "$SEMBRAR_EN"
  sync_trk; }
# VERDE — el borde que se paga caro si se lo trata como error: el día que se
# firma un ADR **y** se audita, las tres fechas son la MISMA. Igual es al día.
s_vistas_misma_fecha() { reloj=$(grep -h -m1 '^\*\*Estado:\*\*' "$SEMBRAR_EN"/docs/decisiones/[0-9][0-9][0-9]-*.md \
                                 | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | sort | tail -1)
                         j=$(j_de "$SEMBRAR_EN")
                         jq --arg d "$reloj" '.last_audit = $d' "$j" > "$j.x" && mv "$j.x" "$j"
                         estampa "$reloj por Fede" "$SEMBRAR_EN"; }

# VERDE — y el sufijo `(N)` de `023` NO puede romper el parseo de la estampa.
# La segunda ratificación del día lleva `(2)`; si el cable lee la fecha con el
# sufijo pegado, una estampa legítima se vuelve ilegible y el cable FRENA por
# hacer las cosas bien. Ese fue el modo de falla de `:658` en `batuta.md`.
s_estampa_con_sufijo() { j=$(j_de "$SEMBRAR_EN")
                         jq --arg d "$NUEVA" '.last_audit = $d' "$j" > "$j.x" && mv "$j.x" "$j"
                         estampa "$NUEVA (3) por Fede" "$SEMBRAR_EN"
  sync_trk; }
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
escenario "un ADR FIRMADA sin su Procedencia (018)"      1 "no declara .Procedencia"   s_firmada_sin_proc
escenario "el artefacto quedó atrás del reloj"          1 "last_audit"                s_artefacto_atrasado
escenario "la estampa de FICHA quedó atrás del reloj"   1 "estampa"                   s_estampa_atrasada
escenario "mecanismo materializado fuera de references/" 1 "MATERIALIZA el mecanismo"  s_mecanismo_fuera_de_refs
escenario "tracker: LAST_AUDIT atrasado"                 1 "LAST_AUDIT"                s_trk_fecha
escenario "tracker: CLOSED_COUNT atrasado"               1 "CLOSED_COUNT"              s_trk_contador
escenario "tracker: le falta un bloque de la fuente"     1 "bloques"                   s_trk_bloque
escenario "tracker: le falta un ADR de la fuente"        1 "ADRs"                      s_trk_adr

echo
echo "el cable tiene que FRENAR, no dar verde (exit 2):"
escenario "no hay artefacto de estado"        2 "FRENA" s_sin_json
escenario "§10 sin filas evaluables (prosa)"  2 "FRENA" s_ficha_prosa
escenario "el artefacto no declara last_audit"       2 "FRENA" s_sin_last_audit
escenario "last_audit con formato ilegible"          2 "FRENA" s_last_audit_ilegible
escenario "FICHA sin su línea de estampa"            2 "FRENA" s_sin_estampa
escenario "la estampa sin fecha parseable"           2 "FRENA" s_estampa_ilegible
escenario "no existe el tracker HTML"                2 "FRENA" s_trk_ausente

echo
echo "y NO tiene que dar falso positivo:"
escenario "PENDIENTE mencionado en la prosa de un ADR" 0 "VERDE" s_mencion
escenario "prosa con FIRMADA + link, fuera de §10"     0 "VERDE" s_prosa_fuera_de_10
escenario "abrir un ADR ⏳ PENDIENTE (024), sin firma"  0 "VERDE" s_adr_pendiente_nuevo
escenario "entrada pendiente que cita otro ADR"         0 "VERDE" s_pend_cita_otro
escenario "las dos vistas por delante del reloj"        0 "VERDE" s_vistas_al_dia
escenario "vistas y reloj en la MISMA fecha"            0 "VERDE" s_vistas_misma_fecha
escenario "estampa al día con sufijo (N) de 023"        0 "VERDE" s_estampa_con_sufijo
escenario "mecanismo NOMBRADO en prosa, no materializado" 0 "VERDE" s_mecanismo_en_prosa

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
  no_corridos=$((no_corridos + 1))
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
  # Un escenario que no corrió NO se promete como cubierto. En el runner el
  # de `bash < 4` nunca corre —ubuntu-latest trae 5.x en los dos paths— y el
  # resumen igual decía «el cable detecta lo que promete». Un escenario
  # salteado en silencio se lee igual que uno que pasó: la misma falla que
  # esta batería existe para evitar, un nivel más arriba.
  if [ "$no_corridos" -gt 0 ]; then
    echo "VERDE · $corridos/$corridos corridos · ⚠️ $no_corridos NO CORRIDO en este entorno"
    echo "El cable detecta lo que promete EN LO QUE SE CORRIÓ. Lo no corrido no está probado acá."
    exit 0
  fi
  echo "VERDE · $corridos/$corridos escenarios · el cable detecta lo que promete"
  exit 0
fi
echo "ROJO · $fallas de $corridos escenarios fallaron"
echo "El cable NO detecta lo que promete. Eso es peor que no tenerlo (030)."
exit 1

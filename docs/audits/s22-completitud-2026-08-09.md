# S22 — El chequeo 9: la completitud del tracker

> Corrida del **2026-08-09** · encargo `#127` · rama `s22-chequeo9-completitud`
> Cable: `.github/scripts/coherencia-contrato.sh` chequeo 9 · siembra: `bateria-sembrada.sh`

## Qué se verificó, y contra qué

El criterio de `030` es que el chequeo **se vea FALLAR antes de darlo por bueno**. Acá se hizo de
la forma más fuerte disponible, y no con un escenario inventado: **se corrió el cable nuevo contra
`f1dfd85`**, el commit real donde el defecto existía, reconstruido con `git archive`.

Eso cumple además la regla que S21 dejó escrita — *«un cable nuevo se verifica contra un valor
calculado POR FUERA de él»*: el valor de referencia no lo produjo el cable, lo produjo la historia
del repo.

### El estado real de `f1dfd85`

| Dato | Valor |
|---|---|
| `LAST_AUDIT` | `2026-08-04` |
| `CLOSED_COUNT` | `101` |
| Gates declarados en `TESTS.gates` | **3** (de 4 que corrían en CI) |
| Primera entrada del `CHANGELOG` | `2026-08-02` |

### El veredicto: `ROJO · 1 de 9`

**Y el «1 de 9» es la prueba central de que el chequeo 9 cubre territorio propio:** en ese mismo
árbol **los otros ocho chequeos pasaban**. El chequeo 7 daba **verde** con `2026-08-04 · 101
cierres`, porque compara el tracker contra el artefacto y **el error había entrado por la fuente**
— las dos vistas coincidían *en el error*. El 9 lo agarró en **las tres dimensiones a la vez**.

## Los tres defectos propios que la ejecución destapó

Ninguno rompía nada visible. **Los tres devolvían un resultado creíble**, que es la firma del
patrón que este taller ya midió seis veces.

### 1 · El escenario del sub-chequeo (a) nacía INERTE

La caja de `escenario()` copiaba **solo `docs/` y el cable**. Con un único `.sh` en
`.github/scripts/`, el sub-chequeo (a) —«todo `.sh` que corre está declarado»— **pasaba sin
ejercitar nada**: el cable sí está declarado. Un escenario que no reproduce el estado del mundo que
su chequeo mide es un **sembrado en falso**, el mismo defecto que `s_vistas_misma_fecha` tuvo hasta
el 2026-08-08. **La caja ahora copia todos los `.sh`.**

### 2 · `sync_trk` dejaba el tracker a medio sincronizar

Al entrar (b), tres escenarios anti-falso-positivo se pusieron **ROJOS**:
`s_vistas_al_dia`, `s_vistas_misma_fecha` y `s_estampa_con_sufijo`. **El rojo era correcto:** los
tres mueven `LAST_AUDIT` y `sync_trk` —cuyo propósito declarado es *«dejar el tracker COHERENTE con
lo que el escenario sembró»*— **no sincronizaba el `CHANGELOG`**. Desde S22, estar al día lo
incluye. **Se extendió `sync_trk`**, sustituyendo solo la fecha para que el sufijo `(N)` de `023`
sobreviva — que es justo lo que uno de esos escenarios prueba.

### 3 · El sub-chequeo (b) anclaba donde APARECE la fecha, no donde VIVE

**Este lo cazó la siembra, y es el hallazgo más limpio de la sesión.** El escenario
`s_changelog_ilegible` esperaba `exit 2` (FRENA) y dio `exit 1` (ROJO).

La causa: (b) extraía «la primera fecha de la línea». Al romper la fecha del campo `f`, el `grep`
se comió **una fecha del TEXTO de la entrada** — la narración del 2026-08-08 menciona el
`2026-07-30` — y el chequeo creyó tener un dato cuando no lo tenía.

Es **exactamente** el pecado que `030` §3 nombra y que el propio cable documenta en su cabecera:
**anclar donde aparece la palabra en vez de donde vive la verdad**. El mismo que marcó al ADR `026`
como pendiente por una mención en su prosa. **Séptima vez que este taller lo mide — y la primera
que lo caza un escenario sembrado en vez de un humano leyendo el diff.**

Corregido anclando en el campo: `\{f:[[:space:]]*'[^']*'` primero, la fecha después.

## Estado final

```
coherencia-contrato.sh   VERDE  9/9   (2026-08-08 · 97 cierres · 25 bloques · 34 ADRs
                                       · 4 gates · CHANGELOG en 2026-08-08 · 21 sesiones)
bateria-sembrada.sh      VERDE  44/44 (eran 35: +3 ROJO, +3 FRENA, +3 anti-falso-positivo)
frontera.sh              VERDE  2/2   (6 referencias, ninguna en falso)
bateria-frontera.sh      VERDE  15/15
```

## Salida cruda

### Corrida 1 — el chequeo 9 contra f1dfd85 (el estado REAL del 2026-08-05)
```
═══ Coherencia del contrato (decisiones/030) ═══

fuente: docs/decisiones   vistas: docs/FICHA.md · docs/audits/claude-batuta-estado.json

1· sello presente y legible ......... ✓ (34 ADRs)
2· PENDIENTE: fuente == artefacto ... ✓ ( 033)
3· FICHA §10 == la fuente ........... ✓ (34 entradas, ninguna huérfana)
4· artefacto fresco vs la fuente .... ✓ (2026-08-04 ≥ 2026-08-04)
5· estampa de FICHA vs la fuente .... ✓ (2026-08-04 ≥ 2026-08-04)
6· mecanismo de identidad solo en references/ ✓ (ningún bloque de código lo materializa fuera de la fuente)
7· tracker HTML vs la fuente ........ ✓ (2026-08-04 · 101 cierres · 24 bloques · 34 ADRs)
8· ALCANCE ratifica lo que hay hoy .. ✓ (adcc79359491d2c2…)
9· completitud del tracker .......... ✗ FALLA
     el tracker está incompleto — los números pueden estar al día y el texto no:
     (a) bateria-frontera.sh · corre en CI · el tracker NO lo declara en TESTS.gates
     (a) frontera.sh · corre en CI · el tracker NO lo declara en TESTS.gates
     (b) CHANGELOG · última entrada 2026-08-02 · LAST_AUDIT 2026-08-04 — la auditoría no dejó asiento
     (c) S19 · está en PLAN.md · falta en const PLAN del tracker
     (c) S19 · está en PLAN.md · falta en el campo plan del artefacto
     (c) S20 · está en PLAN.md · falta en const PLAN del tracker
     (c) S20 · está en PLAN.md · falta en el campo plan del artefacto
     (c) S21 · está en PLAN.md · falta en const PLAN del tracker
     (c) S21 · está en PLAN.md · falta en el campo plan del artefacto
     Corregirlo a mano no cierra esto: el cable existe para que la vista no
     se actualice solo hasta donde otro cable la obliga a cuadrar.

ROJO · 1 de 9 chequeos en falla
```

### Corrida 2 — la batería completa sobre la rama de S22
```
═══ Batería sembrada — ¿el cable DETECTA? ═══

control (el repo sano tiene que pasar):
  repo sin sembrar                               ✓ exit 0

el cable tiene que ponerse ROJO (exit 1):
  artefacto lista un ADR firmado como PENDIENTE  ✓ exit 1
  ADR pasa a PENDIENTE y el artefacto no lo sabe ✓ exit 1
  un ADR pierde su línea de sello               ✓ exit 1
  §10 declara un estado distinto al del ADR     ✓ exit 1
  un ADR de la fuente sin fila en §10           ✓ exit 1
  huérfano de un ADR citado en la prosa         ✓ exit 1
  un ADR FIRMADA sin su Procedencia (018)        ✓ exit 1
  el artefacto quedó atrás del reloj           ✓ exit 1
  la estampa de FICHA quedó atrás del reloj    ✓ exit 1
  mecanismo materializado fuera de references/   ✓ exit 1
  tracker: LAST_AUDIT atrasado                   ✓ exit 1
  tracker: CLOSED_COUNT atrasado                 ✓ exit 1
  tracker: le falta un bloque de la fuente       ✓ exit 1
  tracker: le falta un ADR de la fuente          ✓ exit 1
  FICHA §0 cambia y ALCANCE no re-ratifica      ✓ exit 1
  FICHA §11 cambia y ALCANCE no re-ratifica     ✓ exit 1
  tracker: un gate de CI que la vista no declara ✓ exit 1
  tracker: LAST_AUDIT avanza sin asiento en CHANGELOG ✓ exit 1
  tracker: el plano define una sesión que las vistas no tienen ✓ exit 1

el cable tiene que FRENAR, no dar verde (exit 2):
  no hay artefacto de estado                     ✓ exit 2
  §10 sin filas evaluables (prosa)              ✓ exit 2
  el artefacto no declara last_audit             ✓ exit 2
  last_audit con formato ilegible                ✓ exit 2
  FICHA sin su línea de estampa                 ✓ exit 2
  la estampa sin fecha parseable                 ✓ exit 2
  no existe el tracker HTML                      ✓ exit 2
  ALCANCE sin su línea de huella                ✓ exit 2
  no existe el plano (PLAN.md)                   ✓ exit 2
  el plano sin encabezados de sesión            ✓ exit 2
  CHANGELOG con fecha ilegible                   ✓ exit 2

y NO tiene que dar falso positivo:
  PENDIENTE mencionado en la prosa de un ADR     ✓ exit 0
  prosa con FIRMADA + link, fuera de §10        ✓ exit 0
  abrir un ADR ⏳ PENDIENTE (024), sin firma    ✓ exit 0
  entrada pendiente que cita otro ADR            ✓ exit 0
  las dos vistas por delante del reloj           ✓ exit 0
  vistas y reloj en la MISMA fecha               ✓ exit 0
  estampa al día con sufijo (N) de 023          ✓ exit 0
  mecanismo NOMBRADO en prosa, no materializado  ✓ exit 0
  cambia una sección de FICHA que ALCANCE NO ratifica ✓ exit 0
  un gate na legítimo, sin .sh en disco         ✓ exit 0
  asiento de CHANGELOG con sufijo (N) de 023     ✓ exit 0
  sesión en las vistas que el plano no define   ✓ exit 0

y NO tiene que dar verde bajo un intérprete que no soporta:
  cable corrido con bash < 4                     ✓ exit 2 (3.2.57(1)-release)

───────────────────────────────────────────────
VERDE · 44/44 escenarios · el cable detecta lo que promete
```

# S08 — Verificación adversarial de la fase `cerrar`

**Fecha:** 2026-07-22 · **Issue:** #12 · **Rama:** `s08-fase-cerrar` · **Tratamiento:** DIRECTO (talle M)
**Método:** inspección del contrato + verificación adversarial (patrón `/orquestar` §5, precedente
S06/S07). Verificadores de **contexto limpio** con consigna **REFUTAR**, workflow multi-agente.
Obra en markdown puro (`006`): corridas sembradas → **deuda explícita S09**.

## Las rondas

| Ronda | Agentes | Alcance | Resultado |
|---|---|---|---|
| R1 | 6 (5 criterios de la ficha + 1 lente de coherencia) | Fase 4 expandida + 013 aplicada | 5/6 PASA · **1 MAYOR** + 18 menores |
| R2 | 2 (MAYOR reparado + lente de regresión) | acotado | **PASA ×2** · 4 menores, cerrados en el mismo ciclo |

Total: **8 verificadores**, ~0.8M tokens de subagentes.

## El MAYOR y su cierre

**El carve-out del PR de decisión del dueño (§6, de S07) no tenía regla de composición al
escribir el eslabón `obra`**: una pieza sin encargo no se podía asentar sin mentir, y el reclamo
«es del dueño» no exigía autenticación — el lavado de la causal a través de su propia excepción.
Cierre: **regla de composición del asiento** en la Fase 4 — PR de decisión del dueño (asiento: la
decisión que materializa, autenticada con FIRMADA+procedencia `018` **y** `merged_by`==dueño
`009`), PR de bookkeeping (asiento: el cierre firmado que refleja, autenticado: el listado
declarado toca SOLO la contabilidad), cualquier otra = eslabón roto que se exhibe. Reflejado en
registro §5 (columna Encargo/asiento + fila de re-auditoría) y §6 (dos salvos, fail-closed: «un
reclamo de salvo que no autentica es la causal»).

## Cierres de menores destacables

- **Delegado caído en el cierre**: la corrida queda `bloqueada`, jamás `cerrada` — un cierre sin
  re-auditoría no existe.
- **Invocación de la re-auditoría contable por inspección**: fecha + `last_audit` asentados en
  eslabón `obra` y baseline (patrón banda-angosta).
- **Tabla de desvíos con cuatro fuentes** (requisito del plano firmado vs PR; excedente
  silencioso vía listado de archivos; re-auditoría; §6 completo con salvos) y frontera explícita
  con «no re-verificás por adentro»: cruzar artefactos sí, re-correr criterios contra código no.
- **Baseline con identidad y contrato**: `<corrida-id>-baseline.md`, la fuente contable de `012`
  es el eslabón + canal (el baseline resume), su lector es la fase 1 siguiente (cableado en la
  Fase 1: cache de arranque — orienta, no decide).
- **El reporte de cierre viaja por el canal** (GitHub), desvíos y eslabones rotos incluidos.
- **Sync 013 completa**: FICHA §3/§10/§11, ALCANCE.md, references/README.md, tabla de delegados
  del comando, y la letra de VISION/PLAN actualizada a los salvos de §6.

## Estado final por criterio de la ficha (#12)

| Criterio | Estado | Evidencia |
|---|---|---|
| Re-auditoría se delega, no se hace | ✅ por inspección (R1 PASA) | Fase 4 paso 1: invocación asentada, cero escaneo, delegado caído → `bloqueada` |
| Cadena completa sin eslabones rotos | ✅ por inspección (R2 PASA) · corrida completa → **deuda S09** | Fase 4 pasos 2-3 + regla de asiento + registro §5/§6 |
| Desvío sembrado aparece como hallazgo | ✅ por inspección (R1 PASA) · corrida sembrada → **deuda S09** | tabla de 4 fuentes + reporte al canal |
| Estado de `retrospectiva` resuelto | ✅ — 013 FIRMADA 2026-07-22 con procedencia `018`, sin tercer estado | `decisiones/013` + FICHA §3/§10/§11 + ALCANCE + references/README |
| Baseline liviano persiste | ✅ por inspección (R1 PASA) · existencia tras corrida → **deuda S09** | Fase 4 paso 4: nombre, contenido, lector |

## Deuda y hallazgos para la re-auditoría

- **Deuda de verificación → S09**: corrida completa exhibiendo cadena sin rotos; corrida con
  desvío sembrado (un encargo construye otra cosa); existencia del baseline tras corrida.
- **El tracker HTML** sigue mostrando la 013 pendiente y a retro «estado sin definir» — lo
  reconcilia la re-auditoría (bookkeeping), no esta rama.
- **Deuda menor declarada**: el registro local no tiene evidencia anti-manipulación
  (retro-editable sin rastro) — mitigado por «se agrega, no se edita» y por la exhibición
  obligatoria; endurecerlo (hashes, firmas) sería sobre-ingeniería para v0 markdown.
- Límite v0 preexistente (documentado en `009`): `merged_by`==dueño no distingue al humano de un
  agente con sus credenciales — el dial criptográfico de `009` queda disponible.

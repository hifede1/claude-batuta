# S07 — Verificación adversarial de la fase `ejecutar-con-compuertas`

**Fecha:** 2026-07-21/22 · **Issue:** #11 · **Rama:** `s07-ejecutar-con-compuertas`
**Método:** inspección del contrato + verificación adversarial multi-ronda (patrón `/orquestar`
§5 y precedente S06). Verificadores de **contexto limpio** con consigna **REFUTAR**, lanzados
como workflow multi-agente. Obra en markdown puro (`006`): las corridas sembradas quedan como
**deuda de verificación explícita → S09**, igual que S04/S05/S06.

## Las rondas

| Ronda | Agentes | Alcance | Resultado |
|---|---|---|---|
| R1 | 8 (6 criterios de la ficha + 2 lentes: coherencia-con-plano, delgadez) | expansión inicial de la Fase 3 | 6/8 REFUTADO · **7 MAYORES** + 18 menores |
| R2 | 8 (mismas consignas, contrato reparado, verificadores frescos) | todo | 5/8 PASA · **3 MAYORES nuevos** (ninguno reincidente en su causa) |
| R3 | 3 (uno por MAYOR de R2) | acotado | 2 PASA · 1 REFUTADO (vía «encargo materializador» de la lista blanca) |
| R4 | 1 (punto único: materialización de la lista blanca, 2ª reparación) | acotado | **PASA** · 2 menores cerrados en el mismo ciclo |

Total: **20 verificadores**, ~2.1M tokens de subagentes. Ningún criterio fue tumbado 3 veces por
la misma causa (freno anti-loop no disparado).

## Qué cazaron y cómo se cerró (los 10 MAYORES)

1. **Firma de horizonte «por PR» obligaba a `batuta` a abrir rama/mergear** → el artefacto
   portador es un **issue** de decisión-a-firmar; review-de-PR solo si OTRO actor aporta el PR.
2. **La Compuerta 2 hacía firmable el deploy que la tabla ⛔ frena** → «**la compuerta AUTORIZA;
   no ejecuta**» + tres cercas (cambio de repo = encargo; delegado ⛔ frena aunque haya firma; v0
   sin egreso-que-escribe arbitrario, FICHA §11) + fila *egresor* ⛔ + verbo en el test de delgadez.
3. **Universal falso sobre el bookkeeping automergeable** → excepción heredada de `005` declarada
   honestamente en comando, PLAN §S07 y FICHA §12 («única excepción **por default**»).
4. **Tipado sin regla para la zona gris** → «el tipado es por EFECTO, los verbos son ejemplos;
   ante la duda, egreso-que-escribe; toda zona gris se firma» + exfiltración vía «GET» tipada
   como escritura.
5. **Camino de lavado de etiqueta hacia decisión-a-firmar/diff/eslabones** → la etiqueta viaja a
   TODO artefacto compuesto; fallback «si no vino marcada, la marcás vos»; «integrar» definido
   (solo una firma del dueño con la marca a la vista suelta la marca).
6. **Lista blanca lavable por PR de encargo** → cambio SOLO como decisión-a-firmar (tercera
   altitud); edición colada INVÁLIDA aunque el PR esté firmado.
7. **Drift 012 (FICHA §10 y `perimetro-de-confianza.md` decían PENDIENTE)** → sincronizados:
   FICHA §7 write-back + §10 a Firmadas; referencia actualizada (3 lugares); registro §5 con
   tabla de egresos firmados y etiquetas, §6 con dos causales nuevas de eslabón roto.
8. **Criterio «cero excepciones» del PLAN contradecía la `005` firmada** → criterio reconciliado
   con el carve-out que `005` conserva (R3: PASA).
9. **Frontera canal-vs-egreso sin trazar** (despachar issues es «POST») → «el CANAL no es
   egreso»: el bus del taller es ADENTRO; la exención es estructural pero el tipado sigue por
   EFECTO (webhook que deploya o dato sensible a repo público = egreso igual) (R3/R4: PASA).
10. **La materialización de la lista blanca no tenía camino válido** (y la vía «encargo
    materializador» de la 1ª reparación rompía la disciplina de eslabones) → la materialización
    es **del dueño**: PR de decisión cuyo merge ES la ratificación (`018`), exógeno para
    `batuta`; procedencia verificada por referencia + firma `018` + **acto autenticado por el
    camino `009`** (`merged_by` == dueño anclado); carve-out en registro §6 (R4: **PASA**).

## Estado final por criterio de la ficha (#11)

| Criterio | Estado | Evidencia |
|---|---|---|
| TODO cambio de código pasa por `/orquestar` | ✅ por inspección (R2/R4 PASA) | `batuta.md` Fase 3, mecánica punto 1 + Compuerta Cero |
| Cero merge sin firma | ✅ por inspección (R3 PASA) | mecánica punto 1 + tabla de motores + PLAN/FICHA reconciliados con `005` |
| Egreso tipado en ambos sentidos | ✅ por inspección (R2 PASA) · corrida sembrada GET+POST → **deuda S09** | Compuerta 2 |
| Umbral con número, `012` aceptada | ✅ (R2 PASA) — FIRMADA 2026-07-21 con procedencia `018`; ratificación final = merge de este PR | `decisiones/012` |
| Inyección sembrada: etiqueta, reporta, no obedece (ambos niveles) | ✅ por inspección (R2 PASA) · corrida sembrada → **deuda S09** | sección Inyección (4 ingresos) |
| Sub-agente que toca externo propaga etiqueta | ✅ por inspección (R2 PASA) · corrida con workflow de research → **deuda S09** | Inyección + Compuerta 3 + registro §6 (lavado = eslabón roto) |

## Deuda y hallazgos para la re-auditoría

- **Deuda de verificación → S09**: corridas sembradas de (a) GET+POST con lista blanca, (b)
  inyección en respuesta de API a nivel encargo y fase, (c) workflow de research con propagación
  de etiqueta, (d) delegado caído a mitad. Todas clavables con el harness de repos de prueba de S09.
- **Hallazgo preexistente (no de esta rama)**: `decisiones/002` y `005` dicen `aceptada` sin
  campo `Procedencia de la firma` — la retroactividad prometida en `018` (vía `011`) para los ADR
  001-008 nunca se materializó en los archivos. FICHA §10 los lista FIRMADA. Trabajo de la mesa
  de firmas, no de un encargo.
- **Menores aceptados como deuda menor** (documentados en las rondas, sin riesgo material): la
  fila «la firma humana autoriza cada escritura» del ruteo no menciona el batcheo por lista
  (tensión cosmética); «las tres compuertas que batuta abre por su cuenta» vs la compuerta
  individual que PIDE (lectura); FICHA §12/PLAN criterio 1 no repiten la disyunción «o acto
  directo del dueño» (su verificación ya está acotada a ramas/merges de `batuta`).

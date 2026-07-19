# 011 — Acto de ratificación del plano

**Estado:** ⏳ **PENDIENTE** · Dueño: **Fede** · Desbloquea: **S02 (Andamio)**
**superaA:** —
**Origen:** hallazgo 🟠 de la auditoría del plano, 2026-07-19

## Contexto / problema

El plano **nunca define su propio estado normativo ni cómo cambia**:

- `README.md` lo llama «contrato».
- `FICHA.md` §8 declara un criterio de aceptación «verificable» como si ya obligara.
- Pero `FICHA.md` se autodeclara «⚪ En diseño» y titula sus criterios de aceptación **«(borrador)»**.

No hay ninguna cláusula que diga quién ratifica los criterios, con qué acto pasan de borrador a firme, ni qué versión del documento rige una corrida.

**Un contrato que no declara cuándo está vigente no obliga a nada:** cualquier incumplimiento se desestima diciendo «era un borrador». Y esto no es abstracto — `batuta` misma tiene un criterio («Con plano firmado: produce la RUTA…») que se dispara según un estado que hoy nadie puede evaluar.

## Opciones a evaluar (sin decidir)

| Opción | Tradeoffs a sopesar |
|---|---|
| **`/auditar-docs` limpio == plano firmado** | Reusa maquinaria existente y es binario. Costo: un plano puede estar formalmente limpio y sustantivamente equivocado. |
| **Firma explícita del humano en el repo** | Un campo `Estado: VIGENTE desde AAAA-MM-DD` firmado a mano. Máxima claridad de intención. Costo: se olvida de actualizar. |
| **Tag de git / release** | Versionado real del contrato, con historia. Costo: fricción por cada cambio de plano. |

## Qué hace falta para cerrarla

1. Definir el acto que marca el plano como vigente.
2. Definir cómo se versiona.
3. Definir qué pasa con corridas iniciadas bajo una versión anterior.

## Consecuencias de dejarla abierta

Ni los criterios de `batuta` ni los del propio plano son exigibles. Es la decisión que le da autoridad a todo lo demás.

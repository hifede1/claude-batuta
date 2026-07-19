# Evidencia de instalación limpia — `doc-arquitecto`

> Encargo: **S01** (issue #5) · Fecha: **2026-07-19** · Ejecutor: `hifede1`
> CLI: **Claude Code 2.1.215** · macOS (darwin 25.5.0)

Este archivo existe porque el criterio 3 de S01 pedía justamente esto: *«queda evidencia
persistida de la corrida — hoy este es el hueco»*. Sin artefacto, la marca 🟢 de la tabla
de cimientos no sería auditable por nadie más que quien la escribió.

---

## Método: perfil aislado, no la máquina de trabajo

El criterio pide **máquina limpia**. Desinstalar y reinstalar sobre el perfil real de Fede
habría sido destructivo y, encima, no habría probado el camino desde cero (quedan cachés).

Se usó `CLAUDE_CONFIG_DIR` para levantar un perfil virgen en un directorio temporal:

```bash
P=/tmp/.../perfil-limpio
mkdir -p "$P"
CLAUDE_CONFIG_DIR="$P" claude plugin marketplace list
# → "No marketplaces configured"    ← perfil confirmado virgen
```

Ese `No marketplaces configured` es la prueba de que el escenario arrancó de cero.

---

## Corrida

### Paso 1 — añadir el marketplace

```
$ CLAUDE_CONFIG_DIR="$P" claude plugin marketplace add hifede1/claude-audit-tracker

Adding marketplace…SSH not configured, cloning via HTTPS: https://github.com/hifede1/claude-audit-tracker.git
Refreshing marketplace cache (timeout: 120s)…
Cloning repository (timeout: 120s): https://github.com/hifede1/claude-audit-tracker.git
Clone complete, validating marketplace…
Cleaning up old marketplace cache…
✔ Successfully added marketplace: fede-tools (declared in user settings)
```

> **Dato relevante:** `SSH not configured, cloning via HTTPS`. El `marketplace add` hace
> fallback a HTTPS por sí solo. Esto es coherente con el gotcha documentado en
> `references/plugins-claude-code.md`: el que **no** hace fallback es el clone del
> `git-subdir`, y por eso la entrada de `doc-arquitecto` en `marketplace.json` declara la
> URL HTTPS completa en vez del shorthand `owner/repo`. Si usara el shorthand, este install
> habría fallado exactamente acá, en una máquina sin SSH.

### Paso 2 — instalar el plugin

```
$ CLAUDE_CONFIG_DIR="$P" claude plugin install doc-arquitecto@fede-tools

Installing plugin "doc-arquitecto@fede-tools"...✔ Successfully installed plugin: doc-arquitecto@fede-tools (scope: user)
EXIT=0
```

### Paso 3 — verificar que quedó utilizable

```
$ CLAUDE_CONFIG_DIR="$P" claude plugin list

Installed plugins:
  ❯ doc-arquitecto@fede-tools
    Version: 1.0.0
    Scope: user
    Status: ✔ enabled
```

```
$ CLAUDE_CONFIG_DIR="$P" claude plugin details doc-arquitecto

doc-arquitecto 1.0.0
Component inventory
  Skills (2)  auditar-docs, documentar
  Agents (0) · Hooks (0) · MCP servers (0) · LSP servers (0)

Projected token cost
  Always-on: ~42 tok
  documentar     ~20 always-on / ~3.3k on-invoke
  auditar-docs   ~20 always-on / ~1.5k on-invoke
```

Archivos efectivamente materializados en el caché del perfil limpio:

```
$P/plugins/cache/fede-tools/doc-arquitecto/1.0.0/commands/documentar.md
$P/plugins/cache/fede-tools/doc-arquitecto/1.0.0/commands/auditar-docs.md
```

---

## Veredicto

| Criterio de S01 | Estado | Evidencia |
|---|---|---|
| El install corre sin error en perfil limpio | ✅ **VERIFICADO** | Exit 0; los tres pasos de arriba |
| `/documentar` y `/auditar-docs` responden de punta a punta | ⛔ **NO VERIFICADO** | Ver bloqueo abajo |
| Queda evidencia persistida de la corrida | ✅ **VERIFICADO** | Este archivo |
| La tabla de cimientos marca 🟢 con fecha fresca | ⛔ **NO APLICABLE TODAVÍA** | Depende del criterio 2 |

---

## El bloqueo: por qué el criterio 2 no se pudo cerrar

Se intentó correr `/doc-arquitecto:auditar-docs` en modo headless sobre un repo de prueba
vacío, dentro del perfil aislado:

```
$ cd /tmp/.../repo-prueba && CLAUDE_CONFIG_DIR="$P" claude -p "/doc-arquitecto:auditar-docs"

Not logged in · Please run /login
```

**El perfil aislado no tiene credenciales**, y ese es justamente el precio de haberlo
aislado bien. Dos caminos quedaron descartados a propósito:

1. **Copiar las credenciales al perfil temporal.** Descartado: mover material de
   autenticación a un directorio temporal no es una decisión que corresponda tomar sin
   pedirlo, y el beneficio (cerrar un criterio) no justifica el riesgo.

2. **Correr los comandos en el perfil real de Fede.** Descartado por dos motivos
   independientes:
   - `doc-arquitecto` **no está instalado** en el perfil real (ver hallazgo abajo), así que
     habría que instalarlo — modificar su entorno de trabajo sin pedirlo.
   - Aunque estuviera, no probaría lo que el criterio pide: *máquina limpia*.

Además, hay una razón de contrato que ningún truco de shell resuelve: **`/documentar` en
modo nuevo es interactivo por diseño.** Su propio comando declara *«JAMÁS avances sin
respuesta»* y conduce una entrevista de 4 etapas con `AskUserQuestion`. Una corrida headless
no puede completarla: se detendría en la primera pregunta, que es exactamente el
comportamiento correcto.

**Conclusión: el criterio 2 requiere que Fede corra los dos comandos en una sesión
interactiva.** No es una limitación que se pueda saltear con más intentos.

---

## Hallazgos laterales

### 1. La ficha de S01 tiene la sintaxis de `uninstall` incompleta

La ficha (y `ALCANCE.md`) proponen:

```
/plugin uninstall doc-arquitecto
```

Según la documentación oficial, `uninstall` lleva el sufijo del marketplace:

```
/plugin uninstall doc-arquitecto@fede-tools
```

Sin el sufijo, el comando puede no resolver el plugin. Corregir en la ficha antes de que
alguien lo corra a ciegas.

### 2. El perfil real no tiene `doc-arquitecto` instalado, solo cacheado

```
installed_plugins.json → audit-tracker@fede-tools   ✓
                       → doc-arquitecto             ✗ ausente
cache/                 → fede-tools/doc-arquitecto/  presente
                       → fede-test/doc-arquitecto/   presente ← marketplace inexistente
```

Dos consecuencias:

- La premisa registrada en la auditoría del 2026-07-19 —*«la máquina de Fede ya tenía
  doc-arquitecto instalado del marketplace viejo»*— es **imprecisa**: está *cacheado*, no
  instalado. El resultado práctico es el mismo (el camino de install desde cero nunca se
  había ejercitado), pero el motivo era otro.
- Existe un caché huérfano de un marketplace **`fede-test`** que ya no está declarado en
  ningún lado. Candidato a limpieza; no bloquea nada.

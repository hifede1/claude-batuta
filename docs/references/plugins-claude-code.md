---
tema: plugins-claude-code
triggers: [plugin, marketplace, comando, skill, install, manifiesto, slash command, plugin.json, marketplace.json, git-subdir]
fecha: 2026-07-19
fuentes:
  - https://code.claude.com/docs/en/plugins-reference.md
  - https://code.claude.com/docs/en/plugins.md
  - https://code.claude.com/docs/en/plugin-marketplaces.md
  - https://code.claude.com/docs/en/discover-plugins.md
  - ../../../claude-doc-arquitecto/docs/references/marketplaces-plugins-claude-code.md
---

# Plugins de Claude Code — el CÓMO

> Destilado el 2026-07-19 de la documentación oficial de Anthropic.
> **Territorio volátil**: el formato de plugin cambia con las versiones de Claude Code.
> Revalidar cada **3 meses** o ante cualquier cambio de versión del CLI.

Esta referencia existe porque `batuta` **es** un plugin de Claude Code. Todo lo que se
construya en S02 y adelante vive dentro de esta estructura.

---

## 1. La regla que más se equivoca

**Solo `plugin.json` va dentro de `.claude-plugin/`.** Todo lo demás —`commands/`,
`skills/`, `agents/`, `hooks/`— va en la **raíz del plugin**.

```
mi-plugin/
├── .claude-plugin/
│   └── plugin.json          ← lo ÚNICO que va acá adentro
├── commands/                ← raíz, no dentro de .claude-plugin/
│   └── mi-comando.md
├── skills/
│   └── mi-skill/
│       └── SKILL.md
└── README.md
```

Fuente: [plugins-reference — Plugin directory structure](https://code.claude.com/docs/en/plugins-reference.md)

---

## 2. El manifiesto `plugin.json`

**Obligatorio**: solo `name` (kebab-case).

Los que importan para este taller:

| Campo | Por qué importa |
|---|---|
| `name` | Identificador. Si la entry del marketplace declara otro nombre, **gana el del marketplace**. |
| `version` | Semver. **Si se omite, se usa el SHA del commit** → cada commit es una versión nueva. |
| `description`, `author`, `repository`, `license`, `keywords` | Metadatos de catálogo. |
| `commands` / `agents` / `outputStyles` | **Reemplazan** el directorio por defecto. |
| `skills` | **Se suma** al default: `skills/` se escanea igual. |
| `defaultEnabled` | Si es `false`, instala deshabilitado. |

⚠️ **Tradeoff de `version` que hay que decidir a conciencia:** omitirla evita mantenerla,
pero convierte cada commit en release. Declararla obliga a **bumpearla en cada release** o
los usuarios nunca reciben la actualización. Para un plugin de uso personal con releases
espaciados, declararla es lo correcto — es lo que hace `doc-arquitecto` (`1.0.0`).

### Variables de entorno disponibles

| Variable | Resuelve a |
|---|---|
| `${CLAUDE_PLUGIN_ROOT}` | Ruta absoluta de instalación del plugin |
| `${CLAUDE_PLUGIN_DATA}` | `~/.claude/plugins/data/{id}/` — estado persistente |
| `${CLAUDE_PROJECT_DIR}` | Raíz del proyecto |

`${CLAUDE_PLUGIN_DATA}` es el lugar correcto para el **registro de cadena** que S02 tiene
que definir: sobrevive a reinstalaciones y no ensucia el repo del usuario.

---

## 3. Comandos: markdown con frontmatter opcional

Un comando slash **es un `.md`**. Dos formatos:

- `commands/deploy.md` → se invoca `/mi-plugin:deploy` *(formato plano)*
- `skills/deploy/SKILL.md` → se invoca `/mi-plugin:deploy` *(recomendado; permite adjuntar archivos de apoyo)*

Frontmatter YAML, **todo opcional**:

```markdown
---
description: Qué hace, en una línea
model: sonnet
effort: medium
tools: [Read, Write, Edit]
disallowedTools: [Bash]
disable-model-invocation: true
maxTurns: 20
---

# Instrucciones

Usá $ARGUMENTS para el texto completo, $1 / $2 para posicionales.
```

**Los comandos quedan namespaceados**: `/doc-arquitecto:documentar`, no `/documentar`.

> **Observación del taller, no de la doc:** los dos comandos de `doc-arquitecto` **no
> declaran frontmatter** — arrancan directo en `# /documentar`. Funciona (todo es
> opcional), pero significa que no declaran `description`, así que el listado de comandos
> los muestra sin explicación. Para `batuta` conviene declarar al menos `description`.

---

## 4. Marketplaces

Un marketplace es un `.claude-plugin/marketplace.json` **en la raíz del repo** que cataloga
plugins y dice de dónde sacarlos.

```json
{
  "name": "fede-tools",
  "owner": { "name": "Federico Pernice" },
  "plugins": [ { "name": "...", "source": "..." } ]
}
```

Requeridos: `name`, `owner.name`, `plugins[]`. Cada plugin necesita `name` y `source`.

### ⚠️ Los nombres de marketplace son ÚNICOS por usuario

**Si se añade un segundo marketplace con el mismo nombre, reemplaza al primero.**

Esto no es teórico en este taller: es exactamente el bug que originó el fix `#29 → #21`.
`doc-arquitecto` declaraba su propio marketplace `fede-tools` y colisionaba con el de
`audit-tracker`. La resolución fue **catálogo único** (`claude-doc-arquitecto/docs/decisiones/010`),
con un **gate de CI anti-regresión** que falla el build si reaparece un `marketplace.json`
en el repo del plugin.

**Regla del taller:** el catálogo `fede-tools` vive **solo** en `claude-audit-tracker`.
Ningún otro repo lo declara. Cuando `batuta` sea instalable, se lista ahí — no se crea uno nuevo.

---

## 5. Tipos de `source` — cómo servir un plugin

| Tipo | Cuándo usarlo | Campos |
|---|---|---|
| Ruta relativa `"./plugins/x"` | El plugin vive en el **mismo repo** que el marketplace | — |
| `github` | Repo entero es el plugin | `repo` (`owner/repo`), `ref?`, `sha?` |
| `url` | Igual pero fuera de GitHub | `url`, `ref?`, `sha?` |
| **`git-subdir`** | **El plugin es un subdirectorio de OTRO repo** | `url`, `path`, `ref?`, `sha?` |
| `npm` | Distribución por registry | `package`, `version?`, `registry?` |

`git-subdir` es el que usa este taller, porque cada plugin tiene su propio repo pero el
catálogo vive en uno solo. Usa **sparse clone**, así que no baja el monorepo entero.

```json
{
  "name": "doc-arquitecto",
  "source": {
    "source": "git-subdir",
    "url": "https://github.com/hifede1/claude-doc-arquitecto.git",
    "path": "plugins/doc-arquitecto",
    "ref": "main"
  }
}
```

### 🔴 Gotcha verificado empíricamente — el que rompe el install

> En `git-subdir`, la `url` **debe ser HTTPS completa**, no el shorthand `owner/repo`.
> El CLI resuelve el shorthand a **SSH**, y el `install` falla en máquinas sin clave SSH configurada.
>
> `marketplace add` **sí** hace fallback a HTTPS. El clone del `git-subdir` **no**.
>
> Verificado en CLI **2.1.214** el 2026-07-18. Fuente: `claude-doc-arquitecto/docs/references/marketplaces-plugins-claude-code.md:80-83`

Es el gotcha más caro de esta referencia: falla **solo en la máquina limpia**, que es
justamente el escenario que S01 tiene que probar.

---

## 6. Instalación

```bash
# añadir el catálogo (shorthand owner/repo SÍ funciona acá)
/plugin marketplace add hifede1/claude-audit-tracker

# instalar
/plugin install doc-arquitecto@fede-tools

# desinstalar — OJO: lleva el sufijo @marketplace
/plugin uninstall doc-arquitecto@fede-tools

# otros
/plugin list
/plugin enable|disable <plugin>@<marketplace>
/reload-plugins
```

Equivalentes de CLI fuera de sesión: `claude plugin marketplace add|list|update|remove`,
`claude plugin install|uninstall|list|enable|disable`, `claude plugin validate .`

### Scopes

| Scope | Archivo | Uso |
|---|---|---|
| `user` (default) | `~/.claude/settings.json` | Personal, todos los proyectos |
| `project` | `.claude/settings.json` | Compartido con el equipo, versionado |
| `local` | `.claude/settings.local.json` | Personal, un solo proyecto |

### Desarrollo sin instalar

```bash
claude --plugin-dir ./mi-plugin
```

**Este es el modo correcto para construir `batuta` en S02**: se prueba el comando sin
tocar el marketplace ni el estado global.

---

## 7. Gotchas que cuestan tiempo

| Gotcha | Consecuencia |
|---|---|
| **Los plugins se COPIAN al caché** (`~/.claude/plugins/cache/`), no se usan in-place | Editar el repo fuente no cambia el plugin instalado. Para iterar: `--plugin-dir`. |
| **No se puede referenciar fuera del directorio del plugin** | `"skills": ["../shared/x"]` falla tras instalar. Workaround: symlinks con target adentro. |
| **Marketplace por URL directa + sources relativos** | Falla: solo se baja el `.json`, no el repo. Con sources relativos hay que añadir el marketplace **desde git**. |
| **Versiones huérfanas** | Al actualizar, la anterior queda huérfana y se borra a los **7 días**. |
| **Auto-updates en repos privados** | Por defecto desactivan los credential helpers → el pull HTTPS puede fallar. SSH con `ssh-agent` funciona. |

### Validación

```bash
claude plugin validate .              # marketplace o plugin
claude plugin validate ./x --strict   # warnings como errores
```

---

## 8. Qué NO está documentado oficialmente

Marcado explícitamente para que nadie lo asuma:

- **No hay sintaxis para instalar un plugin desde GitHub sin marketplace intermedio.** Hay que crear un catálogo, aunque liste un solo plugin.
- Los detalles de colisión de nombres en el caché: solo está documentado el período de 7 días.

---

## Aplicación directa a `batuta`

1. **S02** crea la estructura: `plugins/batuta/.claude-plugin/plugin.json` + `commands/batuta.md`. Se itera con `claude --plugin-dir`, sin tocar el marketplace.
2. El **registro de cadena** de S02 debería vivir en `${CLAUDE_PLUGIN_DATA}`, no en el repo del usuario.
3. Cuando `batuta` sea instalable, se lista en `fede-tools` (en `claude-audit-tracker`) con source `git-subdir` y **URL HTTPS completa**. Jamás se crea un marketplace propio: el CI de los hermanos lo trata como regresión.
4. Declarar `version` en semver y bumpearla en cada release.

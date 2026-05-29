# CLI conventions

The rules that CLIs built on `swift-cli-kit` follow. Tools that comply look
and feel the same to their users; new tools scaffolded by `scaffold-cli` are
born compliant.

## 1. Parser

Every CLI uses [`swift-argument-parser`](https://github.com/apple/swift-argument-parser).
The entry point is a single `ParsableCommand`, or `AsyncParsableCommand`
when the tool does async work. `scaffold-cli` wires `swift-argument-parser`
into the generated `Package.swift` for you.

## 2. One action per invocation

Exactly one action flag fires per call. Bare invocation (no action flag)
runs the tool's **primary view** — typically a status or list. Picking more
than one action flag is a `ValidationError`.

## 3. Action shape

| What the action does | Shape | Examples |
|---|---|---|
| A read, a trigger, or a verb without an input value | `@Flag` | `--list`, `--upgrade`, `--get-brightness`, `--pair` |
| A verb that needs a value | `@Option` | `--set-brightness <0-100>`, `--unpair <slot>` |

When in doubt: if the user must supply a value for the action to make sense,
it's an `@Option`; otherwise it's a `@Flag`.

## 4. Targets and scope

Anything that scopes or qualifies the action — *which* display, *which*
receiver, "all" — is a separate `@Option`/`@Flag`, not encoded into the
action flag itself.

- Good: `--set-brightness 60 --on-display 2`
- Bad: `--set-brightness-on-display-2 60`

Targets are required only when the action needs them; the command's `run()`
throws `ValidationError("...")` when an action is missing a required target.

## 5. Naming

- Long-form only, lowercase `kebab-case`: `--set-brightness`, `--on-display`.
- No short flags **except** ArgumentParser's built-in `-h` / `--help`.
- Both `--key value` and `--key=value` work (ArgumentParser default).

## 6. Standard flags every kit-built CLI ships

| Flag | Source |
|---|---|
| `--help` | ArgumentParser auto |
| `--version` | `CommandConfiguration(version: ...)` (ArgumentParser auto) |
| `--upgrade` | `@Flag var upgrade = false` + `try Upgrade.runSync(...)` (or `try await Upgrade.run(...)`) |

For tools that keep a `BuildInfo.build` counter (e.g. displayswitcher),
`version:` is `"\(BuildInfo.version) (build \(BuildInfo.build))"`. Tools
without one pass `BuildInfo.version` alone.

## 7. Validation and errors

- Usage problems (wrong flag combination, out-of-range value, missing
  required target) → `throw ValidationError("...")`. ArgumentParser prints
  these to stderr with exit code 64.
- Runtime errors → throw a domain error conforming to
  `Error & CustomStringConvertible` (`UpgradeError`, `CLIError`,
  `DDCError`, etc.). ArgumentParser prints those too.

## 8. Output

- The primary view starts with `Banner.printBanner(name:version:tagline:)`,
  then content, then `Banner.printSponsorFooter(url:)`.
- The `--upgrade` action prints the kit's progress messages — tools do not
  add their own pre/post-upgrade text.
- `CommandConfiguration.discussion` ends with one line pointing at the
  sponsors URL (mirrors the footer for `--help` output).

## 8a. Terminal color standard (web mocks)

CLIs color output **only** through `Tone` — never raw `Style` colors for new
semantics. The lintuxt.ai terminal mocks are generated from real CLI output by
the lintc `terminal-mock` plugin, which maps each `Tone`/ANSI to one semantic
`t-*` CSS class. This is the canonical table; the lintc converter and the
lintuxt CSS both conform to it:

| `Tone` | ANSI | class | brand color |
|---|---|---|---|
| `title`/`heading`/`value` | `1;96`/`1`/`97` | `t-strong` | `--text` |
| `accent` | `96` | `t-accent` | `--accent-2` teal |
| `link` | `36` | `t-link` | teal, underlined |
| `muted` | `90` | `t-muted` | `--text-dim` |
| `subtle` | `2` | `t-subtle` | `--text-faint` |
| `ok` | `32` | `t-ok` | mint |
| `warn` | `33` | `t-warn` | gold |
| `error` | `31` | `t-error` | coral |
| `love` | `35` | `t-love` | pink |

Adding a new color to `Style`/`Tone` means adding a row here, a converter
entry in lintc, and a `--t-*` class in the lintuxt CSS — keep the three in sync.

## 9. Project README

Every kit-built CLI's `README.md` follows the Product template at
[`templates/README.md`](templates/README.md). The template is rendered
mechanically by `scaffold-cli` for new tools, and hand-applied for
existing tools. Section order (top to bottom): title + italic tagline →
three badges (release, CI, license) → hero screenshot → *What is it?* →
*Install* (with an `### Uninstall` H3) → *Quick start* → *Requirements*
→ *Build from source* (collapsed `<details>`) → *License* (combined
with sponsor follow-on).

**Placeholder tokens:** `{{NAME}}`, `{{REPO}}`, `{{TAGLINE}}`,
`{{SCREENSHOT}}`, `{{SCREENSHOT_ALT}}`, `{{LICENSE_NAME}}`,
`{{MACOS_MIN}}`. The rendered file should not contain any `{{…}}`
literals after substitution.

**Invariant:** the repo basename equals `{{NAME}}` — i.e.
`git clone https://github.com/{{REPO}}.git` clones into a directory
named `{{NAME}}`. The *Build from source* block depends on this.

**Optional section — Acknowledgements.** Tools that derive from or
credit upstream work add an `## Acknowledgements` H2 between *Build
from source* and *License*. The template does not include this
section; the writer adds it when applicable.

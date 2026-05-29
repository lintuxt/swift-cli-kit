*Library, scaffold, and conventions for native macOS Swift command-line tools.*

[![release](https://img.shields.io/github/v/tag/lintuxt/swift-cli-kit?label=release&color=blue)](https://github.com/lintuxt/swift-cli-kit/tags)
[![CI](https://github.com/lintuxt/swift-cli-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/lintuxt/swift-cli-kit/actions/workflows/ci.yml)
[![license](https://img.shields.io/badge/license-MIT-blue)](https://github.com/lintuxt/swift-cli-kit/blob/trunk/LICENSE)

## Install

In `Package.swift`:

```swift
.package(url: "https://github.com/lintuxt/swift-cli-kit", from: "0.1.0"),
```

…and on the executable target:

```swift
.product(name: "CLIKit", package: "swift-cli-kit"),
```

Requires Swift 6.0+ (Xcode 16+) and macOS 13 or later.

## Quickstart

```sh
./scaffold-cli mycli --tagline "A small thing." --repo me/mycli
```

Generates a complete CLI project — `Package.swift`, `Sources/`, `Tests/`, `README.md`, `install.sh`, and `.github/workflows/{ci,release}.yml` — all wired up with `--help`, `--version`, `--upgrade`, banner, and sponsor footer. The generated project is born convention-compliant: ready to `swift build` and `swift test` immediately.

## Why it exists

swift-cli-kit is the runtime polished macOS CLIs all end up writing twice — TTY-aware ANSI styling, Unicode-aligned tables, a GitHub-release self-update flow, semver comparison, and a banner + sponsor footer — packaged as a single dependency-free Swift library.

It also ships project templates, a generator that creates a new CLI in seconds, and a documented convention so every tool built on the kit looks and feels the same.

Extracted from [solcito](https://github.com/lintuxt/solcito) and [displayswitcher](https://github.com/lintuxt/displayswitcher), the kit exists so the third, fourth, and fifth CLI don't have to re-derive the same runtime concerns each time. Same conventions, same shape, same upgrade flow.

## Documentation

- [`CONVENTIONS.md`](https://github.com/lintuxt/swift-cli-kit/blob/trunk/CONVENTIONS.md) — the parameter and README rules every kit-built CLI follows.
- [`CLAUDE.md`](https://github.com/lintuxt/swift-cli-kit/blob/trunk/CLAUDE.md) — codebase orientation: library API, structure, build, requirements, how to add things.

### Used by

- [solcito](https://github.com/lintuxt/solcito) — Logitech wireless device manager for macOS.
- [displayswitcher](https://github.com/lintuxt/displayswitcher) — external monitor brightness, contrast, and input over DDC/CI.

## License

MIT — see [LICENSE](https://github.com/lintuxt/swift-cli-kit/blob/trunk/LICENSE).

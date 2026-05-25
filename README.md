# swift-cli-kit

*Shared runtime and scaffold for native macOS Swift command-line tools.*

[![release](https://img.shields.io/github/v/tag/lintuxt/swift-cli-kit?label=release&color=blue)](https://github.com/lintuxt/swift-cli-kit/releases)
[![CI](https://github.com/lintuxt/swift-cli-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/lintuxt/swift-cli-kit/actions/workflows/ci.yml)
[![license](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

## What is it?

swift-cli-kit is the runtime polished macOS CLIs all end up writing twice —
TTY-aware ANSI styling, Unicode-aligned tables, a GitHub-release
self-update flow, semver comparison, and a banner+footer — packaged as a
single dependency-free Swift library.

It also ships project templates, a generator that creates a new CLI in
seconds, and a documented convention so every tool built on the kit looks
and feels the same.

## Start a new CLI

```sh
./scaffold-cli <name> --tagline "<one-line description>" --repo <owner/name>
```

The generated project is born convention-compliant: `--help`, `--version`,
`--upgrade`, a banner, and a Product-shaped README — all wired up.

## Used by

- **[solcito](https://github.com/lintuxt/solcito)** — Logitech wireless
  device manager for macOS.
- **[displayswitcher](https://github.com/lintuxt/displayswitcher)** —
  external monitor brightness, contrast, and input over DDC/CI.

## More

- [`CONVENTIONS.md`](CONVENTIONS.md) — the parameter and README rules
  every kit-built CLI follows.
- [`CLAUDE.md`](CLAUDE.md) — codebase orientation: structure, library API,
  build, requirements, how to add things.

## License

MIT · [LICENSE](LICENSE).

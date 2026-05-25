# CLAUDE.md — swift-cli-kit

Project orientation for contributors and AI assistants working in this
repo. Mirrors what a maintainer would want to know on first touch.

## What this is

swift-cli-kit is a Swift Package Manager library + scaffold + conventions
for building native macOS command-line tools. The library is `CLIKit`,
the scaffold is `scaffold-cli`, the conventions are in `CONVENTIONS.md`.

It exists to consolidate the runtime that polished macOS CLIs all end up
writing twice — extracted from solcito and displayswitcher, and the
foundation for new tools.

## Repo layout

```
swift-cli-kit/
├── Package.swift                 # SwiftPM manifest (tools 6.0, macOS 13+)
├── Sources/CLIKit/
│   ├── Style.swift               # Style + Tone — TTY-aware ANSI
│   ├── BoxTable.swift            # Unicode table + grid renderer
│   ├── SemVer.swift              # vX.Y.Z parse + compare
│   ├── Banner.swift              # printBanner / printSponsorFooter
│   └── Upgrade.swift             # GitHub-release self-update flow
├── Tests/CLIKitTests/            # swift-testing suites
├── templates/                    # Rendered by scaffold-cli into new CLI projects
│   ├── README.md                 # Product README template
│   ├── install.sh                # One-line installer template
│   ├── ci.yml                    # GitHub Actions CI workflow
│   └── release.yml               # GitHub Actions release workflow
├── scaffold-cli                  # POSIX shell generator for new CLIs
├── CONVENTIONS.md                # Parameter and README conventions
├── .github/workflows/ci.yml      # CI for the kit itself
└── LICENSE                       # MIT
```

## The CLIKit library

| Component | Purpose |
|---|---|
| `Style` | TTY-aware ANSI styling. `Style.wrap(_:_:)` only emits escapes on a TTY; `Style.width(of:)` returns visible width, ignoring escapes. |
| `Tone` | Semantic styled-string builders — `title`, `heading`, `muted`, `subtle`, `value`, `accent`, `link`, `ok`, `warn`, `error`, `love`. Call-sites read as intent. |
| `BoxTable` | Unicode box-drawing tables. `render(headers:rows:)` for header tables, `grid(_:)` for full grids. Column widths measured by `Style.width(of:)`. |
| `SemVer` | `SemVer.isNewer(_:than:)` for `vX.Y.Z` parse + compare. Tolerates a leading `v`. |
| `Banner` | `Banner.printBanner(name:version:tagline:)` and `Banner.printSponsorFooter(url:)`. |
| `Upgrade` | GitHub-release self-update. `run(repo:currentVersion:installerURL:) async throws` for `async @main`, `runSync(...)` for `ParsableCommand`. Errors throw `UpgradeError`. |

## Add to an existing project

In `Package.swift`:

```swift
.package(url: "https://github.com/lintuxt/swift-cli-kit", from: "0.1.0"),
```

…and on the executable target:

```swift
.product(name: "CLIKit", package: "swift-cli-kit"),
```

## Build and test

```sh
swift build
swift test
```

CI runs both on `macos-latest` via `.github/workflows/ci.yml`.

## Requirements

- macOS 13 or later (the kit's deployment target).
- Swift 6.0+ (Xcode 16+) to build and consume — the kit uses Swift 6
  strict concurrency (`@unchecked Sendable` in `Upgrade.swift`,
  `Task.detached` in the `runSync` bridge).

## Conventions (CLIs built on the kit)

See `CONVENTIONS.md` for the full text. Summary:

1. `swift-argument-parser` for parsing (`ParsableCommand` /
   `AsyncParsableCommand`).
2. Exactly one action flag per invocation; bare = primary view.
3. `@Flag` for read/trigger, `@Option` for value-taking actions.
4. Targets are separate options (`--on-display`, not encoded into action
   names).
5. Long-form `kebab-case` flag names; no short flags except `-h`/`--help`.
6. Standard flags: `--help`, `--version`, `--upgrade`.
7. `ValidationError` for usage problems; domain errors for runtime
   failures.
8. Banner + sponsor footer wrap the primary view.
9. README follows `templates/README.md` (Product shape).

## Releasing

The kit is versioned by git tags only — no GitHub Release entries (it
ships as a SwiftPM dependency, no binary artifact). To cut a new version:

```sh
git tag v0.1.1
git push origin v0.1.1
```

Consumers update via `from: "0.1.1"` in their `Package.swift`.

## Used by

- [lintuxt/solcito](https://github.com/lintuxt/solcito) — Logitech
  wireless device manager.
- [lintuxt/displayswitcher](https://github.com/lintuxt/displayswitcher) —
  external monitor brightness/contrast/input over DDC/CI.

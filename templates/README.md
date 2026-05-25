# {{NAME}}

*{{TAGLINE}}*

[![release](https://img.shields.io/github/v/release/{{REPO}}?label=release&color=blue)](https://github.com/{{REPO}}/releases)
[![CI](https://github.com/{{REPO}}/actions/workflows/ci.yml/badge.svg)](https://github.com/{{REPO}}/actions/workflows/ci.yml)
[![license](https://img.shields.io/badge/license-{{LICENSE_NAME}}-blue)](LICENSE)

<p align="center">
  <img src="{{SCREENSHOT}}" alt="{{SCREENSHOT_ALT}}" width="720">
</p>

## What is it?

{{NAME}} <does X for users who want Y>. <one sentence on how it differs
or what makes it lean>. <one sentence on the runtime story — native
binary, no daemon, no Electron — i.e. why this exists>.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/{{REPO}}/main/install.sh | sh
```

Downloads the latest release for Apple Silicon, verifies its SHA-256
checksum, and installs to `~/.local/bin` (or `/usr/local/bin`).

### Uninstall

```sh
rm "$(which {{NAME}})"
```

## Quick start

```sh
{{NAME}}               # <primary action>
{{NAME}} --foo         # <secondary action>
{{NAME}} --help        # full help
```

## Requirements

macOS {{MACOS_MIN}} or later on Apple Silicon. No other dependencies.

## Build from source

<details>
<summary>Requires Xcode 16+ (Swift 6).</summary>

```sh
git clone https://github.com/{{REPO}}.git
cd {{NAME}}
swift build -c release
./.build/release/{{NAME}} --help
```

</details>

## License

{{LICENSE_NAME}} · [LICENSE](LICENSE).

❤️ [Looking for sponsors](https://github.com/sponsors/lintuxt) — if
{{NAME}} <saves you time / makes your day better>, consider supporting
future work.

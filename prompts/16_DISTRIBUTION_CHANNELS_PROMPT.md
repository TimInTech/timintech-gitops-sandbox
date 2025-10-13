# 16 · Distribution Channels Prompt

## Ziel
Artefakte zuverlässig verteilen: signiert, mit SBOM und Checksums. Mehrere Zielkanäle.

## Kanäle
- **Homebrew** (Formula), **Winget**, **Scoop**
- **deb/rpm/apk** via Release-Assets
- **PyPI/NPM** für Libraries
- **OCI-Images** (GitHub Container Registry)

## Pipeline-Grundlagen
- `goreleaser` für Multi-Target-Builds
- `cosign` für Signaturen (keyless empfohlen)
- SBOM via `syft`, CVE-Scan via `grype`

## Checks
- SemVer-Tag-Guard
- Checksums (sha256/sha512)
- Release Notes automatisch aus Commits

## CleanReset-Bezug
Nach Verlaufskorrekturen Tags und Checksums neu erzeugen, Release-Notizen aktualisieren.

<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 📦 Container‑Images Prompt

**Zweck:**
Härtung von Dockerfiles, Multi‑Arch‑Builds, Signaturen, SBOM, Image‑Scanning.

## ⚠️ Leitlinien
- **Warum vor Wie**: Kurz begründen, dann handeln.
- **Idempotent**: Wiederholte Ausführung darf nichts beschädigen (`|| true`, Existenzprüfungen).
- **Transparenz**: Vollständige Befehle inkl. `cd` angeben.
- **Sicherheit**: Schutzregeln berücksichtigen, sensible Daten nicht ausgeben.
- **Dry‑Run zuerst**: Standardmäßig mit `--dry-run` planen und die Änderungen anzeigen.
- **Tim‑Style**: Befehle in Deutsch, direkt kopierbar, mit `cd`, `nano`, `docker compose up -d` wo relevant.
- **Rollback**: Vor destruktiven Schritten Rückfallebene anlegen.
- **Stand**: 2025-10-12

## 🔧 Standard‑Variablen (anpassen)
```bash
OWNER="TimInTech"
REPO="<REPO_NAME>"
WORKDIR="$HOME/github_repos/$REPO"
DEFAULT_BRANCH="main"
cd "$WORKDIR"
```

## 🧱 1) Dockerfile‑Checkliste
- Kein Root, feste Tags, kleine Basisimages, Layer minimieren, HEALTHCHECK.
- Keine Secrets in Build‑Args.

## 🏗️ 2) Build & SBOM
```bash
cd "$WORKDIR"
docker build -t "ghcr.io/$OWNER/$REPO:dev" .
syft "ghcr.io/$OWNER/$REPO:dev" -o spdx-json > sbom.json || true
```

## 🔏 3) Signieren & Attestieren
```bash
cosign sign -y "ghcr.io/$OWNER/$REPO:dev" || true
cosign attest -y --predicate sbom.json --type spdx "ghcr.io/$OWNER/$REPO:dev" || true
```

## 🧪 4) CI‑Scan
```bash
cd "$WORKDIR"
nano .github/workflows/image-scan.yml
```
```yaml
name: Image Scan
on: [push]
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: anchore/scan-action@v4
        with:
          image: ghcr.io/$OWNER/$REPO:dev
          fail-build: false
```

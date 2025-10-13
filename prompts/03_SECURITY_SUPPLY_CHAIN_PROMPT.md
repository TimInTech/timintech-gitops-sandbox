<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🔐 Security & Supply‑Chain Prompt

**Zweck:**
Aktiviere CodeQL, Secret‑Scanning, Dependabot, SBOM (Syft) und CVE‑Scan (Grype). Blockiere Secrets am Push.

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

## 🛡️ 1) CodeQL Workflow
```bash
cd "$WORKDIR"
mkdir -p .github/workflows
nano .github/workflows/codeql.yml
```
```yaml
name: CodeQL
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
jobs:
  analyze:
    uses: github/codeql-action/.github/workflows/codeql.yml@v3
    permissions:
      security-events: write
      actions: read
      contents: read
```

## 🧪 2) Secret‑Scanning Push‑Protection (Bericht)
```bash
cd "$WORKDIR"
gh api -X GET /repos/$OWNER/$REPO | jq '.security_and_analysis' || true
```

## 📦 3) SBOM & CVE‑Scan (Syft/Grype) im CI
```bash
cd "$WORKDIR"
nano .github/workflows/sbom.yml
```
```yaml
name: SBOM & Vulnerability Scan
on: [push, pull_request]
jobs:
  sbom:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Syft SBOM
        uses: anchore/sbom-action@v0
        with:
          artifact-name: sbom-spdx.json
      - name: Grype Scan
        uses: anchore/scan-action@v4
        with:
          fail-build: false
          severity-cutoff: high
```

## 📜 4) Lizenzen prüfen
```bash
cd "$WORKDIR"
echo "MIT" > LICENSE || true
git add LICENSE && git commit -m "chore: add LICENSE" || true
```

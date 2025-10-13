<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🏗️ CI/CD Baseline Prompt — GitHub Actions

**Zweck:**
Richte eine **CI/CD‑Baseline** ein: Matrix‑Tests, Linting, Artefakte, Caching, Required‑Checks, Reusable Workflows.

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

## 🧰 1) Workflows scaffolden
```bash
cd "$WORKDIR"
mkdir -p .github/workflows
nano .github/workflows/ci-sanity.yml
```

```yaml
name: CI Sanity
on:
  pull_request:
  push:
    branches: [ "main" ]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Shell Lint
        run: |
          sudo apt-get update && sudo apt-get install -y shellcheck shfmt
          find . -type f -name "*.sh" -print0 | xargs -0 -I{} bash -lc 'shellcheck "{}"'
          find . -type f -name "*.sh" -print0 | xargs -0 -I{} bash -lc 'shfmt -d "{}"'
  matrix-tests:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        node: ["18", "20"]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
          cache: npm
      - run: npm ci || true
      - run: npm test || echo "no tests"
```

## 🧱 2) Required Checks konfigurieren (Bericht)
```bash
cd "$WORKDIR"
# Hinweis: Diese Einstellung erfolgt über Repo‑Settings/Branch‑Protection.
gh api repos/$OWNER/$REPO/branches/"$DEFAULT_BRANCH"/protection -q .required_status_checks.contexts || true
```

## 📦 3) Artefakte & Coverage
```bash
cd "$WORKDIR"
nano .github/workflows/coverage.yml
```
```yaml
name: Coverage
on: [push, pull_request]
jobs:
  cov:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "generate coverage" && mkdir -p artifacts && echo "report" > artifacts/report.html
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: artifacts
```

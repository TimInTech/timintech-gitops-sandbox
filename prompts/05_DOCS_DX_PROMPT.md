<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 📚 Doku & Developer‑Experience Prompt

**Zweck:**
Sichere eine starke README, automatische Link‑Prüfung, Beispiele‑Tests und optionale MkDocs‑Site.

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

## 📖 1) README‑Gesundheitscheck
```bash
cd "$WORKDIR"
# Beispiel: lychee Link‑Check im CI verwenden
```

## 🔗 2) Link‑Checker im CI
```bash
cd "$WORKDIR"
nano .github/workflows/link-check.yml
```
```yaml
name: Link Check
on: [push, pull_request]
jobs:
  lychee:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: lycheeverse/lychee-action@v1
        with:
          args: --no-progress --verbose **/*.md
```

## 🌐 3) MkDocs Scaffold
```bash
cd "$WORKDIR"
mkdir -p docs
echo "# $REPO" > docs/index.md
nano mkdocs.yml
```
```yaml
site_name: "$REPO"
theme:
  name: material
nav:
  - Home: index.md
markdown_extensions:
  - toc:
      permalink: true
```

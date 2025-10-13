<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🏷️ Releases & Versionierung Prompt

**Zweck:**
Erzwinge SemVer, signierte Tags, automatischen Changelog und Release‑Drafts.

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

## 🗂️ 1) Release‑Drafter
```bash
cd "$WORKDIR"
nano .github/workflows/release-drafter.yml
```
```yaml
name: Release Drafter
on:
  push:
    branches: [ "main" ]
jobs:
  draft:
    runs-on: ubuntu-latest
    steps:
      - uses: release-drafter/release-drafter@v6
        with:
          config-name: release-drafter.yml
```
```bash
nano .github/release-drafter.yml
```
```yaml
name-template: "v$NEXT_PATCH_VERSION"
tag-template: "v$NEXT_PATCH_VERSION"
categories:
  - title: "🚀 Features"
    labels: ["feature"]
  - title: "🐛 Fixes"
    labels: ["fix"]
change-template: "- $TITLE @$AUTHOR (#$NUMBER)"
```

## 🔏 2) Tags signieren
```bash
cd "$WORKDIR"
git tag -s "v1.0.0" -m "v1.0.0"
git push origin "v1.0.0"
```

<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🧱 Monorepo & Workspaces Prompt

**Zweck:**
Aktiviere Path‑Filter‑CI, Changesets und CODEOWNERS pro Ordner. Beschleunige Tests durch Affected‑Erkennung.

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

## 🧭 1) CODEOWNERS nach Pfad
```bash
cd "$WORKDIR"
nano .github/CODEOWNERS
```
```text
/apps/app1/ @TimInTech
/libs/lib1/ @TimInTech
```

## 🔎 2) Pfad‑Filter in CI
```bash
cd "$WORKDIR"
nano .github/workflows/path-filter.yml
```
```yaml
name: Path Filter
on: [push, pull_request]
jobs:
  filter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: changes
        with:
          filters: |
            app1:
              - 'apps/app1/**'
            lib1:
              - 'libs/lib1/**'
```

## 🧪 3) Affected Tests (Konzept)
- Nur geänderte Pfade bauen/testen.
- CI‑Matrix nach Ordnern aufsplitten.

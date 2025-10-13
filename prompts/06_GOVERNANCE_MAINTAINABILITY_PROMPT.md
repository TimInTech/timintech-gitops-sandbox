<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🧭 Governance & Wartbarkeit Prompt

**Zweck:**
Richte CODEOWNERS, Issue/PR‑Vorlagen, Stale‑Handling, Support‑Richtlinien und Branch‑Regeln ein.

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

## 👥 1) CODEOWNERS
```bash
cd "$WORKDIR"
mkdir -p .github
nano .github/CODEOWNERS
```
```text
* @TimInTech
/scripts/ @TimInTech
/docs/ @TimInTech
```

## 📝 2) Issue/PR‑Vorlagen
```bash
cd "$WORKDIR"
mkdir -p .github/ISSUE_TEMPLATE
nano .github/ISSUE_TEMPLATE/bug.yml
```
```yaml
name: Bug
description: Fehlermeldung
body:
  - type: textarea
    id: beschreibung
    attributes:
      label: Beschreibung
```

```bash
nano .github/pull_request_template.md
```
```md
### Änderungen
-

### Checkliste
- [ ] Lint/CI grün
- [ ] Docs aktualisiert
```

## 💤 3) Stale Bot
```bash
cd "$WORKDIR"
nano .github/workflows/stale.yml
```
```yaml
name: Stale
on:
  schedule:
    - cron: "0 3 * * 1"
jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v9
        with:
          days-before-stale: 60
          days-before-close: 14
```

## 🔐 4) Branch‑Protection (Bericht)
```bash
cd "$WORKDIR"
gh api repos/$OWNER/$REPO/branches/"$DEFAULT_BRANCH"/protection || true
```

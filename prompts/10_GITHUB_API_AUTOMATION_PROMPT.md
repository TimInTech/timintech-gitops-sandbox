<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🤖 GitHub API & gh‑CLI Automation Prompt

**Zweck:**
Automatisiere mit `gh` komplexe Abfragen und Massenänderungen. Nutze REST, Saved‑Searches, Projects v2.

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

## 🔎 1) REST‑Beispiel
```bash
cd "$WORKDIR"
gh api repos/$OWNER/$REPO | jq '.name, .visibility, .default_branch'
```

## 🏷️ 2) Labels Massenanlage
```bash
cd "$WORKDIR"
gh label create "feature" --color FF9900 --description "Neue Funktion" || true
gh label create "fix" --color D73A4A --description "Fehlerbehebung" || true
```

## 📊 3) Projects v2 (Bericht)
```bash
cd "$WORKDIR"
gh project list || true
```

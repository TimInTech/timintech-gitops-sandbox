<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🧳 Migration & Backup Prompt

**Zweck:**
Sichere Repos via `git bundle`, spiegele sie und migriere Labels/Issues. Optional Default‑Branch umbenennen.

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

## 💾 1) Vollbackup als Bundle
```bash
cd "$WORKDIR"
mkdir -p ../_bundles
git bundle create "../_bundles/${REPO}-full.bundle" --all
```

## 🔁 2) Mirror‑Push
```bash
cd "$WORKDIR"
git remote add mirror git@github.com:TimInTech-mirror/${REPO}.git || true
git push --mirror mirror
```

## 🏷️ 3) Default‑Branch umbenennen
```bash
cd "$WORKDIR"
git branch -M main
git push origin main
```

## 🗂️ 4) Labels/Issues exportieren (Bericht)
```bash
cd "$WORKDIR"
gh label list --json name,color,description > labels.json
gh issue list --limit 100 --json number,title,state > issues.json
```

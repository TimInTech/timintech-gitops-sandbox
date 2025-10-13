<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🖥️ Lokale Git‑Standards Prompt

**Zweck:**
Setze konsistente Git‑Konfiguration, Hooks, `delta`/`difftastic`, Credential‑Helper, pre‑commit.

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

## ⚙️ 1) Git‑Config Baseline
```bash
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global credential.helper store
```

## 🪝 2) pre‑commit Hooks
```bash
cd "$WORKDIR"
pipx install pre-commit || true
nano .pre-commit-config.yaml
```
```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: end-of-file-fixer
      - id: trailing-whitespace
  - repo: https://github.com/scop/pre-commit-shfmt
    rev: v3.10.0-1
    hooks:
      - id: shfmt
  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.10.0.1
    hooks:
      - id: shellcheck
```
```bash
pre-commit install
```

## 🔍 3) Diff‑Werkzeuge
```bash
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
```

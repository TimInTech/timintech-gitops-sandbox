<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 📈 Observability & Metriken Prompt

**Zweck:**
Messe CI‑Laufzeiten, Flakiness, Coverage, Artefakt‑Größen und Kosten. Exportiere Berichte als JSON/HTML.

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

## ⏱️ 1) CI‑Metriken auslesen (Beispiel)
```bash
cd "$WORKDIR"
gh run list --limit 20 --json databaseId,createdAt,status,durationMs > .audit/ci_runs.json
jq '[.[].durationMs] | add/length' .audit/ci_runs.json || true
```

## 🧪 2) Flaky‑Erkennung (einfach)
```bash
cd "$WORKDIR"
gh run view --job logs || true
```

## 📊 3) HTML‑Report
```bash
cd "$WORKDIR"
mkdir -p .audit
cat > .audit/report.html <<'EOF'
<!doctype html><meta charset="utf-8"><title>CI Report</title>
<h1>CI Report</h1><p>Automatisch erzeugt.</p>
EOF
git add .audit/report.html && git commit -m "chore: ci report (html)" || true
```

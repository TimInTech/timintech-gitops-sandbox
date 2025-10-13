<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🧯 Policy‑as‑Code Prompt

**Zweck:**
Setze Workflow‑Permissions minimal, Required‑Checks, blockiere Admin‑Bypass. Generiere Compliance‑Berichte.

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

## 🔐 1) Settings‑Gerüst (yaml‑settings)
```bash
cd "$WORKDIR"
mkdir -p .github
nano .github/settings.yml
```
```yaml
repository:
  allow_update_branch: true
  private: false
  default_branch: "main"
  web_commit_signoff_required: true
```

## ✅ 2) Required Status Checks (Bericht)
```bash
cd "$WORKDIR"
gh api repos/$OWNER/$REPO/branches/"$DEFAULT_BRANCH"/protection -q .required_status_checks || true
```

## 📝 3) Compliance‑Report
```bash
cd "$WORKDIR"
mkdir -p .audit
cat > .audit/policy.json <<'EOF'
{"repo":"$REPO","checks":["codeql","secret-scanning","dependabot"]}
EOF
git add .audit/policy.json && git commit -m "chore: policy audit" || true
```

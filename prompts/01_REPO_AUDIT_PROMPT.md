<!--
Standard-Header (TimInTech Prompt Pack)
- Warum vor Wie: Erst begründen, dann handeln.
- Default: --dry-run (nur planen), idempotent, mit Rollback-Hinweis.
- CleanResetVerweis: Siehe CLEAN_RESET_PROMPT.md für verlustfreie Verlaufskorrekturen.
- Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- Outputs: schreibe komplette Dateien bei Änderungen neu.
-->

# 🔍 Repo‑Audit Prompt — TimInTech Methode

**Zweck:**
Führe einen reproduzierbaren **Voll‑Audit** eines GitHub‑Repositories durch: Struktur, Skripte, Docs, Security, CI/CD, Releases. Liefere eine **konkrete To‑Do‑Liste** mit Befehlen und optionalen PR‑Patches.

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

## 🧪 1) Schnellcheck Struktur & Inhalte
```bash
cd "$WORKDIR"
tree -a -L 2 || ls -la
git status
git log --oneline -n 10
```

## 📄 2) Pflichtdateien prüfen/erzeugen
```bash
cd "$WORKDIR"
for f in LICENSE SECURITY.md CODE_OF_CONDUCT.md CONTRIBUTING.md .gitignore .gitattributes; do
  [ -f "$f" ] || echo "PLACEHOLDER for $f" > "$f"
done
git add LICENSE SECURITY.md CODE_OF_CONDUCT.md CONTRIBUTING.md .gitignore .gitattributes
git commit -m "chore: add governance and hygiene files" || true
```

## ⚙️ 3) Skript‑Qualität (Shell/Python)
```bash
cd "$WORKDIR"
# Shellcheck & shfmt (nur berichten, nicht abbrechen)
find . -type f -name "*.sh" -print0 | xargs -0 -I{} bash -lc 'shellcheck "{}" || true'
find . -type f -name "*.sh" -print0 | xargs -0 -I{} bash -lc 'shfmt -d "{}" || true'
```

## 🛡️ 4) Security‑Schalter prüfen
```bash
cd "$WORKDIR"
gh secret list || true
gh repo view "$OWNER/$REPO" --json securityPolicyUrl,visibility
# CodeQL / Secret Scanning / Dependabot als Status ausgeben
```

## 🚦 5) CI/CD Workflows inventarisieren
```bash
cd "$WORKDIR"
ls -la .github/workflows || true
```

## 🧩 6) Ergebnis als Maßnahmenplan
- Struktur: fehlende Verzeichnisse anlegen (`/scripts/`, `/docs/` …).
- Security: CodeQL, Secret‑Scanning, Dependabot aktivieren.
- CI: Linter/Matrix, Caches, Required‑Checks.
- Releases: SemVer, Changelog, signierte Tags.
- Docs: README‑Gates, Link‑Check, Beispiele testen.

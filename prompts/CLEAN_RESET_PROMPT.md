# 🧹 Clean Reset Prompt — TimInTech Methode

**Zweck:**
Führe einen **verlustfreien, professionellen Clean‑Reset** eines GitHub‑Repositories durch, ohne die aktuellen Dateien zu verändern oder Sterne/Forks zu verlieren. Ergebnis ist ein **klarer, linearer Verlauf** ohne Alt‑Artefakte (Branches, PRs, Tags), mit aktivierten Security‑Features.

---

## ⚠️ Leitlinien
- **Warum vor Wie**: Jede riskante Aktion kurz begründen.
- **Idempotent**: Wiederholte Ausführung darf nichts beschädigen (Existenz prüfen, `|| true`).
- **Transparenz**: Vollständige Befehle inkl. `cd` angeben.
- **Sicherheit**: Branch‑Protection vor Force‑Push kurz deaktivieren, danach reaktivieren.

---

## 🔧 Standard‑Variablen (anpassen)
```bash
OWNER="TimInTech"
REPO="<REPO_NAME>"
WORKDIR="$HOME/github_repos/$REPO"
RETAG=""   # optional, z. B. v1.2.0
```

---

## 🛟 1) Optional: Recovery sichern
```bash
cd "$WORKDIR"
git fetch origin
LAST_REMOTE="$(git rev-parse origin/main 2>/dev/null || true)"
if [ -n "$LAST_REMOTE" ]; then
  git branch "recovery/remote-main-${LAST_REMOTE:0:7}" "$LAST_REMOTE" 2>/dev/null || true
  git push origin "recovery/remote-main-${LAST_REMOTE:0:7}" 2>/dev/null || true
fi
```
**Warum:** Notanker für Rollback (kann später gelöscht werden).

---

## 🌱 2) Orphan‑Commit (Historie squashen)
```bash
cd "$WORKDIR"
git status
git checkout --orphan clean-commit
git add -A
git commit -m "Initial clean import (history squashed)"
git log --oneline --decorate -n 3
```
**Warum:** Ein neuer Wurzel‑Commit erzeugt ein sauberes, professionelles Bild.

---

## 🔁 3) Remote‑main umschalten (bewusster Rewrite)
```bash
cd "$WORKDIR"
git push origin +clean-commit:main     # Force‑Rewrite (Branch‑Protection vorher off)
git checkout -B main
git reset --hard origin/main
```
**Warum:** `main` zeigt danach exakt auf den Clean‑Commit (lokal wie remote).

---

## 🧹 4) Alt‑Artefakte entfernen
### 4.1 Remote‑Branches löschen (Beispiele anpassen)
```bash
cd "$WORKDIR"
for BR in   "TimInTech-patch-1"   "assets/screenshot.png"   "codex/add-excel-export-functionality-to-index.html"   "codex/add-file-type-whitelist-and-validation"   "codex/improve-index.html-in-brief-dashboard"   "codex/refactor-html-to-external-files"   "codex/refactor-rendertabelle-in-index.html"   "codex/wrap-json.parse-in-try-.catch"
do
  git push origin --delete "$BR" 2>/dev/null || true
done
git fetch --all --prune
git ls-remote --heads origin
```

### 4.2 Offene PRs schließen
```bash
cd "$WORKDIR"
gh pr list --state open
# gh pr close <NR> --delete-branch
```

### 4.3 Tag(s) löschen/neu setzen (optional)
```bash
cd "$WORKDIR"
if [ -n "$RETAG" ]; then
  git push origin :refs/tags/"$RETAG" 2>/dev/null || true
  git tag -fa "$RETAG" -m "$RETAG after clean history" "$(git rev-parse HEAD)"
  git push --force origin "$RETAG"
fi
```

---

## 🧷 5) Dateirechte & `.gitattributes`
```bash
cd "$WORKDIR"
# Textdateien nicht ausführbar
git update-index --chmod=-x LICENSE README.md index.html 2>/dev/null || true
git update-index --chmod=-x docs/index.md docs/installation.md 2>/dev/null || true

# .gitattributes (Text/Binary, EOL) – nur erstellen falls fehlt
if [ ! -f .gitattributes ]; then
  cat > .gitattributes <<'EOF'
*.md   text eol=lf
*.html text eol=lf
*.yml  text eol=lf
*.yaml text eol=lf
*.sh   text eol=lf
*.png  binary
*.jpg  binary
EOF
  git add .gitattributes
  git commit -m "chore: enforce text/binary attrs"
fi
git push
```

---

## 🛡️ 6) Security & CI
- **Dependabot Alerts/Updates**, **Secret Scanning**, **CodeQL** im Repo aktivieren.
- **Branch‑Protection** für `main`: PRs, Status‑Checks, no force‑push.

---

## ✅ 7) Abschluss‑Check
```bash
cd "$WORKDIR"
git fetch --all --prune
git log --oneline --decorate --graph -n 5
git ls-remote --heads origin
git ls-remote --tags origin
```
**Erwartung:** 1–2 saubere Commits, nur gewünschte Branches/Tags, Actions grün.

---

## 🧾 Hinweis für GPT‑Instanzen
Nutze diese Datei als **verbindliche Referenz**. Erkläre kurz das „Warum“, dann führe die **vollständigen** Befehle aus.
Wenn das Repo stark abweicht, schlage eine konservative Variante mit PR‑basierter Migration vor.

📅 *Stand: 2025‑10‑12*
✍️ *TimInTech — Clean Repository Blueprint*

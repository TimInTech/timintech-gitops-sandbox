#!/usr/bin/env bash
set -euo pipefail

# Bootstrap: Neues GitHub-Repo aus dem aktuellen Verzeichnis erzeugen und absichern.
# Voraussetzungen: gh (eingeloggt), git, optional jq

usage() {
  cat <<'USAGE'
Usage: scripts/bootstrap-test-repo.sh --repo <name> [--owner <owner>] [--visibility private|public]

Beispiel:
  scripts/bootstrap-test-repo.sh --repo timintech-gitops-sandbox --owner dein-gh-user --visibility private

Macht:
  - gh repo create OWNER/REPO
  - Commits pushen (Branch main)
  - Branch-Protection mit erforderlichen Checks setzen
USAGE
}

OWNER=""
REPO=""
VISIBILITY="private"
DEFAULT_BRANCH="main"

# Argumente parsen: unterstützt --flag=value und --flag value
while [[ $# -gt 0 ]]; do
  case "$1" in
    --owner)
      OWNER="${2:-}"; shift 2 ;;
    --owner=*)
      OWNER="${1#*=}"; shift 1 ;;
    --repo)
      REPO="${2:-}"; shift 2 ;;
    --repo=*)
      REPO="${1#*=}"; shift 1 ;;
    --visibility)
      VISIBILITY="${2:-}"; shift 2 ;;
    --visibility=*)
      VISIBILITY="${1#*=}"; shift 1 ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unbekanntes Argument: $1" >&2; usage; exit 1 ;;
  esac
done

# Sichtbarkeit validieren
case "$VISIBILITY" in
  private|public) ;;
  *) echo "Ungültige Sichtbarkeit: $VISIBILITY (erlaubt: private|public)" >&2; exit 1 ;;
esac

if [[ -z "$REPO" ]]; then
  echo "Fehler: --repo <name> ist erforderlich" >&2
  usage
  exit 1
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI nicht gefunden. Installiere https://cli.github.com/" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git nicht gefunden." >&2; exit 1; }

if [[ -z "$OWNER" ]]; then
  # Owner aus gh auth Kontext ermitteln
  OWNER=$(gh api user --jq .login 2>/dev/null || true)
  if [[ -z "$OWNER" ]]; then
    echo "Konnte Owner nicht bestimmen. Bitte --owner angeben." >&2
    exit 1
  fi
fi

echo "Owner: $OWNER"
echo "Repo:  $REPO"
echo "Vis.:  $VISIBILITY"
echo "Branch: $DEFAULT_BRANCH"

# Git initialisieren, falls nötig
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init
fi

# Auf main wechseln
if ! git rev-parse --verify "$DEFAULT_BRANCH" >/dev/null 2>&1; then
  git checkout -b "$DEFAULT_BRANCH"
else
  git checkout "$DEFAULT_BRANCH"
fi

# Erstcommit, falls leer
if [[ -z "$(git status --porcelain)" ]]; then
  echo "Working tree sauber. Falls noch kein Commit existiert, wird keiner erstellt."
else
  git add -A
  git commit -m "chore: bootstrap GitOps YAMLs & configs"
fi

# Repo erstellen (falls nicht vorhanden)
if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  echo "Repo $OWNER/$REPO existiert bereits. Überspringe Erstellung."
else
  gh repo create "$OWNER/$REPO" --"$VISIBILITY" --disable-issues=false --source=. --push --remote=origin
fi

# Remote sicher setzen und pushen
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "https://github.com/$OWNER/$REPO.git"
fi
git push -u origin "$DEFAULT_BRANCH"

echo "Setze Branch-Protection für $DEFAULT_BRANCH ..."
set +e
gh api \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  "/repos/$OWNER/$REPO/branches/$DEFAULT_BRANCH/protection" \
  -f required_status_checks.strict=true \
  -f enforce_admins=true \
  -F required_status_checks.contexts[]="CI Sanity / lint" \
  -F required_status_checks.contexts[]="CI Sanity / matrix-tests" \
  -F required_status_checks.contexts[]="CodeQL" \
  -F required_status_checks.contexts[]="SBOM & Vulnerability Scan" \
  -F required_status_checks.contexts[]="Link Check" \
  -F required_pull_request_reviews.required_approving_review_count=1 \
  -f restrictions=
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  cat <<'WARN'
WARN: Branch-Protection via gh api ist fehlgeschlagen.
- Stelle sicher, dass dein Token die nötigen Rechte hat (repo/admin:repo_hook).
- Alternativ: Installiere die "Settings" GitHub App, die .github/settings.yml automatisch anwendet.
WARN
else
  echo "Branch-Protection gesetzt."
fi

echo "Fertig: https://github.com/$OWNER/$REPO"

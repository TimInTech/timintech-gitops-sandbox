#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "[ERROR] line $LINENO: $BASH_COMMAND" >&2' ERR

# Immer aus Repo-Root laufen
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Voraussetzungen prüfen
command -v python3 >/dev/null 2>&1 || {
	echo "python3 fehlt."
	exit 1
}
python3 -m venv --help >/dev/null 2>&1 || {
	echo "python3-venv fehlt. Installiere..."
	sudo apt-get update -y
	sudo apt-get install -y python3-venv
}

# Venv anlegen/aktivieren
if [ ! -d ".venv" ]; then
	python3 -m venv .venv
fi
# shellcheck disable=SC1091
. .venv/bin/activate

python -m pip install -U pip
test -f api/requirements.txt || {
	echo "api/requirements.txt fehlt."
	exit 1
}
python -m pip install -r api/requirements.txt

# Port-Prüfung (robust, vermeidet false-positives)
PORT="${PORT:-8080}"
if ss -ltnp | awk -v p=":$PORT" '$1=="LISTEN" && index($4,p)>0 {found=1} END{exit !found}'; then
	echo "Port $PORT ist belegt. Entweder Prozess beenden oder z. B.: PORT=8081 scripts/run-api.sh"
	ss -ltnp | awk -v p=":$PORT" '$1=="LISTEN" && index($4,p)>0 {print; shown=1} END{if(!shown) print "(keine Details verfügbar)"}' || true
	exit 1
fi

exec uvicorn api.main:app --host 0.0.0.0 --port "$PORT"

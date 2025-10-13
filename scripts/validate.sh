#!/usr/bin/env bash
set -euo pipefail

mkdir -p .audit

echo "[1/3] Spectral lint openapi.yaml"
if command -v spectral >/dev/null 2>&1; then
	spectral lint openapi.yaml | tee .audit/spectral-openapi.txt
else
	echo "spectral nicht installiert (npm i -g @stoplight/spectral-cli)" | tee .audit/spectral-openapi.txt
fi

echo "[2/3] actionlint für GitHub Workflows"
if command -v actionlint >/dev/null 2>&1; then
	actionlint -color -shellcheck=
else
	echo "actionlint nicht installiert (brew install actionlint oder GitHub Release Binary)" | tee .audit/actionlint.txt
fi

echo "[3/3] pre-commit run -a"
if command -v pre-commit >/dev/null 2>&1; then
	pre-commit run -a | tee .audit/pre-commit.txt || true
else
	echo "pre-commit nicht installiert (pipx install pre-commit)" | tee .audit/pre-commit.txt
fi

echo "Fertig. Artefakte in .audit/"

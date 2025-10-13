#!/usr/bin/env bash
set -euo pipefail
python3 -m venv .venv
. .venv/bin/activate
pip install -U pip
pip install -r api/requirements.txt
uvicorn api.main:app --host 0.0.0.0 --port 8080

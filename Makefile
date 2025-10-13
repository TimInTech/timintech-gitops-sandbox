.PHONY: venv run test lint api-docker

venv:
	python3 -m venv .venv && . .venv/bin/activate && pip install -U pip && pip install -r api/requirements.txt -r api/requirements-dev.txt

run:
	. .venv/bin/activate && uvicorn api.main:app --host 0.0.0.0 --port 8080

test:
	. .venv/bin/activate && pytest -q

lint:
	spectral lint openapi.yaml || true

api-docker:
	docker build -t ghcr.io/$(shell gh api user --jq .login)/timintech-gitops-api:latest .

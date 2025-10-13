from fastapi.testclient import TestClient
import os
from api.main import app

client = TestClient(app)


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json().get("status") == "ok"

def test_health_mounted():
    r = client.get("/gitops/v1/health")
    assert r.status_code == 200
    assert r.json().get("status") == "ok"


def test_audit_plan_without_key_allowed_when_env_empty(monkeypatch):
    monkeypatch.delenv("API_KEY", raising=False)
    payload = {"owner": "TimInTech", "repo": "demo", "apply": False}
    r = client.post("/gitops/v1/audit/plan", json=payload)
    assert r.status_code == 200
    body = r.json()
    assert "summary" in body and "steps" in body and "artifacts" in body


def test_audit_plan_requires_key_when_env_set(monkeypatch):
    monkeypatch.setenv("API_KEY", "secret")
    payload = {"owner": "TimInTech", "repo": "demo", "apply": False}
    # missing header -> 401
    r = client.post("/gitops/v1/audit/plan", json=payload)
    assert r.status_code == 401
    # wrong header -> 401
    r = client.post("/gitops/v1/audit/plan", json=payload, headers={"X-API-Key": "wrong"})
    assert r.status_code == 401
    # correct header -> 200
    r = client.post("/gitops/v1/audit/plan", json=payload, headers={"X-API-Key": "secret"})
    assert r.status_code == 200

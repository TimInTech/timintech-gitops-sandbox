from fastapi.testclient import TestClient
from api.main import app

client = TestClient(app)


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json().get("status") == "ok"


def test_audit_plan():
    payload = {"owner": "TimInTech", "repo": "demo", "apply": False}
    r = client.post("/gitops/v1/audit/plan", json=payload)
    assert r.status_code == 200
    body = r.json()
    assert "summary" in body and "steps" in body and "artifacts" in body

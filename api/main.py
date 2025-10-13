from fastapi import FastAPI, Request, Depends, Header, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List, Optional
import time
import os

APP_NAME = "TimInTech GitOps API"
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


class PlanRequest(BaseModel):
    owner: str
    repo: str
    apply: Optional[bool] = False


class PlanResponse(BaseModel):
    summary: str
    steps: List[str]
    artifacts: List[str]


class ErrorResponse(BaseModel):
    error: str
    detail: Optional[str] = None


app = FastAPI(title=APP_NAME, version=APP_VERSION)
api = FastAPI(title=f"{APP_NAME} SubAPI", version=APP_VERSION)


@app.middleware("http")
async def add_timing_and_reqid(request: Request, call_next):
    start = time.time()
    req_id = request.headers.get("X-Request-ID", "")
    try:
        response = await call_next(request)
    except Exception as exc:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(error="internal_error", detail=str(exc)).model_dump(),
        )
    duration_ms = int((time.time() - start) * 1000)
    response.headers["X-Server-Version"] = APP_VERSION
    if req_id:
        response.headers["X-Request-ID"] = req_id
    response.headers["X-Response-Time-ms"] = str(duration_ms)
    return response


@app.get("/health")
def health():
    return {"status": "ok", "version": APP_VERSION}


@api.get("/health")
def health_sub():
    return {"status": "ok", "version": APP_VERSION}


def api_key_guard(x_api_key: str | None = Header(default=None)):
    """Simple header-based API key guard.

    - If env API_KEY is set and does not match header X-API-Key -> 401
    - If env API_KEY is empty -> allow (no auth required)
    """
    expected = os.getenv("API_KEY", "")
    if expected and x_api_key != expected:
        raise HTTPException(status_code=401, detail="invalid api key")


def make_plan(op: str, req: PlanRequest) -> PlanResponse:
    mode = "APPLY" if req.apply else "DRY-RUN"
    steps: List[str] = [
        f"scope: owner={req.owner} repo={req.repo}",
        "validate repo access",
        f"generate {op} plan",
        "write artifacts to .audit/",
    ]
    if req.apply:
        steps.append("apply changes with safeguards and rollback tags")
    artifacts = [
        f".audit/{op}-plan-{req.owner}-{req.repo}.json",
        f".audit/{op}-plan-{req.owner}-{req.repo}.html",
    ]
    return PlanResponse(
        summary=f"{op} plan for {req.owner}/{req.repo} ({mode})",
        steps=steps,
        artifacts=artifacts,
    )


@api.post(
    "/audit/plan",
    response_model=PlanResponse,
    responses={400: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
def audit_plan(req: PlanRequest, _=Depends(api_key_guard)):
    return make_plan("audit", req)


@api.post(
    "/ci/baseline",
    response_model=PlanResponse,
    responses={400: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
def ci_baseline(req: PlanRequest, _=Depends(api_key_guard)):
    return make_plan("ci-baseline", req)


@api.post(
    "/security/enable",
    response_model=PlanResponse,
    responses={400: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
def security_enable(req: PlanRequest, _=Depends(api_key_guard)):
    return make_plan("security-enable", req)


@api.post(
    "/release/draft",
    response_model=PlanResponse,
    responses={400: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
def release_draft(req: PlanRequest, _=Depends(api_key_guard)):
    return make_plan("release-draft", req)


@api.post(
    "/policy/report",
    response_model=PlanResponse,
    responses={400: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
def policy_report(req: PlanRequest, _=Depends(api_key_guard)):
    return make_plan("policy-report", req)


@api.post(
    "/clean-reset/plan",
    response_model=PlanResponse,
    responses={400: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
def clean_reset_plan(req: PlanRequest, _=Depends(api_key_guard)):
    # bewusst nur Plan, nie direkte Anwendung
    return make_plan("clean-reset-plan", req)


# Mount wie in openapi.yaml
app.mount("/gitops/v1", api)

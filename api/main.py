from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Optional


class PlanRequest(BaseModel):
    owner: str
    repo: str
    apply: Optional[bool] = False


class PlanResponse(BaseModel):
    summary: str
    steps: List[str]
    artifacts: List[str]


app = FastAPI(title="TimInTech GitOps API", version="1.0.0")

api = FastAPI()


def make_plan(op: str, req: PlanRequest) -> PlanResponse:
    mode = "APPLY" if req.apply else "DRY-RUN"
    return PlanResponse(
        summary=f"{op} plan for {req.owner}/{req.repo} ({mode})",
        steps=[
            f"scope: owner={req.owner} repo={req.repo}",
            "validate repo access",
            f"generate {op} plan",
            "write artifacts to .audit/",
        ],
        artifacts=[
            f".audit/{op}-plan-{req.owner}-{req.repo}.json",
            f".audit/{op}-plan-{req.owner}-{req.repo}.html",
        ],
    )


@api.post("/audit/plan", response_model=PlanResponse)
def audit_plan(req: PlanRequest):
    return make_plan("audit", req)


@api.post("/ci/baseline", response_model=PlanResponse)
def ci_baseline(req: PlanRequest):
    return make_plan("ci-baseline", req)


@api.post("/security/enable", response_model=PlanResponse)
def security_enable(req: PlanRequest):
    return make_plan("security-enable", req)


@api.post("/release/draft", response_model=PlanResponse)
def release_draft(req: PlanRequest):
    return make_plan("release-draft", req)


@api.post("/policy/report", response_model=PlanResponse)
def policy_report(req: PlanRequest):
    return make_plan("policy-report", req)


@api.post("/clean-reset/plan", response_model=PlanResponse)
def clean_reset_plan(req: PlanRequest):
    return make_plan("clean-reset-plan", req)


# Mount unter /gitops/v1 wie in openapi.yaml angegeben
app.mount("/gitops/v1", api)

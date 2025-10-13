# TimInTech GitOps – Schnellstart

Dieser Repo enthält Systemprompt, OpenAPI und konservativ gehärtete Workflows, um GitHub-Repos deterministisch zu auditieren und zu härten.

## 1) Test-Repo anlegen und YAMLs ausrollen

Voraussetzungen: gh CLI (eingeloggt), git

```bash
# optional: Pre-commit lokal aktivieren
pipx install pre-commit || pip install --user pre-commit
pre-commit install

# Test-Repo erzeugen und pushen
chmod +x scripts/bootstrap-test-repo.sh
scripts/bootstrap-test-repo.sh --repo timintech-gitops-sandbox --owner <dein-gh-user> --visibility private
```

Tipp: Rollout-Reihenfolge ist abgedeckt (settings.yml → Workflows → Release-Automation). Branch-Protection wird gesetzt, falls die nötigen Rechte vorhanden sind.

## 2) Linting/Validierung lokal

```bash
chmod +x scripts/validate.sh
./scripts/validate.sh
```

Artefakte werden nach `.audit/` geschrieben.

## 3) GPT-Action importieren und testen

- Im GPT-Builder eine neue GPT erstellen.
- Systemprompt aus `SYSTEM_INSTRUCTION_TIMINTECH_GITOPS.md` übernehmen.
- Unter „Actions“ `openapi.yaml` importieren.
- Auth einrichten (API-Key/OAuth) für deinen Backend-Endpunkt.
- Test: `auditPlan` mit Payload

  ```json
  { "owner": "<org/user>", "repo": "<repo>", "apply": false }
  ```

  Erwartung: Dry-Run-Plan mit Steps und Artefaktliste.

## 4) Referenzen

- Getting started mit GPT-Actions: <https://platform.openai.com/docs/actions>
- Auth: <https://platform.openai.com/docs/actions/authentication>
- Production-Hinweise (Timeouts, Retries, Backoff, Limits): <https://platform.openai.com/docs/actions/production>
- Erstellen/Publizieren im GPT-Store: <https://help.openai.com/en/collections/6208647-gpts>
- Rate-Limits: <https://platform.openai.com/docs/guides/rate-limits>

## 5) Hinweise

- Actions sind auf Major-Versionen gepinnt (z. B. `@v4`). Für maximale Sicherheit SHA-Pins erwägen.
- Keine Secrets in Build-Args; GitHub Push-Protection einschalten.
- CodeQL-Sprachen auf deinen Stack anpassen.
- Release-Drafter Labels (`feature`, `fix`) nutzen, damit Changelogs sinnvoll gruppiert werden.

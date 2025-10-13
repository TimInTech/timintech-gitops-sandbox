# 14 · Org Hardening Prompt

## Ziel
Organisationweit konsistente Sicherheits- und Governance-Einstellungen setzen. Minimale Rechte, überprüfbare Standards.

## Schritte
1) **Inventar**
```bash
gh api orgs/$ORG | jq
gh api orgs/$ORG/rulesets | jq '.[]|{name,targets,conditions}'
```
2) **Rulesets & Branch-Protection**
```bash
# Beispiel: signierte Commits, required reviews, status checks
# Dokumentiere Änderungen; bei Bedarf PR-basiert über Template-Repo ausrollen.
```
3) **Security aktivieren**
- Secret Scanning + Push Protection
- Dependabot Alerts/Updates
- Code Scanning (CodeQL)

4) **Auth & Tokens**
- SSO erzwingen
- GitHub App bevorzugen statt PAT
- Fine-grained PATs auditieren

5) **Merge-Strategie**
- Merge Queue aktivieren
- Automerge via Label `ready`

## CleanReset-Bezug
Bei starken Abweichungen auf Repoebene zuerst `CLEAN_RESET_PROMPT.md` prüfen und ggf. historienneutrale Migration per PR bevorzugen.

# 17 · Incident Response Prompt

## Ziel
Schnelles, reproduzierbares Vorgehen bei Secret-Leaks, kompromittierten Artefakten oder fehlerhaften Releases.

## Playbook
1) **Erkennen**
- Alerts prüfen (Secret Scanning, Dependabot, CodeQL)
- CI-Logs sichern

2) **Eindämmen**
- `freeze`: Automerge/Deploys stoppen
- Tokens revoken, Keys rotieren
- Betroffene Geheimnisse in Env/Org-Secrets ersetzen

3) **Bereinigen**
- git history rewrite (filter-repo/BFG) falls nötig
- Tags/Assets neu signieren
- SBOM & Checksums erneuern

4) **Kommunikation**
- Security-Advisory erstellen
- Release Notes mit CVE-Verweisen

5) **Wiederanlauf**
- Policies härten (push-protection, rulesets)
- Postmortem mit Kennzahlen

## CleanReset-Bezug
Bei Leak in Commit-Historie zuerst Clean-Reset-Strategie prüfen, dann gezielt neu veröffentlichen.

# 00 · Common Guide · Standards & Konventionen

## Zweck
Einheitliche Leitplanken für alle *PROMPT.md*-Dateien. Verhindert Drift, beschleunigt Reviews und sorgt für reproduzierbare Ausgaben.

## Prinzipien
- **Warum vor Wie**: Jede riskante Aktion kurz begründen.
- **Idempotent**: Mehrfaches Ausführen darf keinen Schaden verursachen.
- **Dry-Run zuerst**: Standard ist `--dry-run`. Danach mit `--apply` bestätigen.
- **Rollback**: Immer einen Rückweg anbieten (Branch/Tag/Bundle/Snapshot).
- **Transparenz**: Vollständige Befehle mit `cd`, `nano`, `docker compose up -d`.
- **CleanReset**: Für Verlaufskorrekturen CLEAN_RESET_PROMPT.md referenzieren.

## Voraussetzungen
- CLI: `gh`, `git`, `jq`
- Security: optional `gitleaks`, `trufflehog`
- Supply-Chain: optional `syft`, `grype`, `cosign`
- CI: GitHub Actions aktiviert

## Variablen-Block (Beispiel)
```bash
ORG="TimInTech"
REPO="<repo>"
GH_HOST="github.com"
DEFAULT_BRANCH="main"
```

## Ergebnisformate
- Artefakte nach `.audit/{json,html,sarif}` schreiben.
- Kurzzusammenfassung in Markdown am Ende.

## Reihenfolge
1. Audit
2. Clean-Reset prüfen/verlinken
3. Fixes anwenden (optional `--apply`)
4. CI/Policy härten
5. Abschlussbericht

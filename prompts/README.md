# 🧠 GitHub Projektordner – Custom-GPT · System & Clean-Reset (TimInTech)

Dieser Ordner macht deinen Custom-GPT sofort **kontextbewusst** und **handlungsfähig** für GitHub-Audits, Clean-Resets, CI/Security-Härtung, Releases und Distribution.
Alle Dateien liegen im **Hauptordner**. **Keine Unterordner**. Optional: `screenshot.png`.

---

## 🚀 Nutzung in Kürze

1. **Ordner/ZIP laden**.
2. GPT **liest automatisch**: `SYSTEM_INSTRUCTION_GITHUB.md`, `CLEAN_RESET_PROMPT.md`, `00_COMMON_GUIDE.md`, `INDEX.md`.
3. Start mit **`01_REPO_AUDIT_PROMPT.md`**. Danach je nach Bedarf themenspezifische Prompts 02–17.
4. **Clean-Reset** nur nach Prüfung anwenden.
5. Änderungen an Dateien stets **vollständig neu ausgeben**.

---

## 📂 Dateien (Übersicht)

| Datei                                     | Zweck                                                                               |
| ----------------------------------------- | ----------------------------------------------------------------------------------- |
| `SYSTEM_INSTRUCTION_GITHUB.md`            | Systemanweisung für diesen Projektordner (Verhalten, Stil, Leitplanken)             |
| `CLEAN_RESET_PROMPT.md`                   | Sichere Historien-Korrektur, Teil/Voll-Reset, Backups, Autor-Erhalt                 |
| `00_COMMON_GUIDE.md`                      | Gemeinsame Standards: Dry-Run, Idempotenz, Rollback, Variablen, Artefakte           |
| `01_REPO_AUDIT_PROMPT.md`                 | Struktur- und Qualitäts-Audit mit konkreten Fix-Vorschlägen                         |
| `02_CI_CD_BASELINE_PROMPT.md`             | Basis-CI, Linting, Caching, Concurrency, flake-Handling                             |
| `03_SECURITY_SUPPLY_CHAIN_PROMPT.md`      | Secret-Scanning, CodeQL, SBOM (Syft), CVE-Scan (Grype), cosign                      |
| `04_RELEASES_VERSIONING_PROMPT.md`        | SemVer, Changelogs, signierte Tags, Release-Pipelines                               |
| `05_DOCS_DX_PROMPT.md`                    | README-Gates, Link-Checker, Doctests, MkDocs/Docusaurus, i18n                       |
| `06_GOVERNANCE_MAINTAINABILITY_PROMPT.md` | CODEOWNERS, PR-Vorlagen, Issue-Forms, Stale/Backport                                |
| `07_MIGRATION_BACKUP_PROMPT.md`           | Mirrors, Bundles, Label/Issue-Migration, Branch-Rename                              |
| `08_MONOREPO_WORKSPACES_PROMPT.md`        | Changesets, Path-Filter-CI, Affected-Tests, Workspaces                              |
| `09_LOCAL_GIT_STANDARDS_PROMPT.md`        | EditorConfig, pre-commit, Hooks, difftastic/delta                                   |
| `10_GITHUB_API_AUTOMATION_PROMPT.md`      | `gh` CLI Advanced, REST/GraphQL, Code Search v2, Webhooks                           |
| `11_CONTAINERS_IMAGES_PROMPT.md`          | Docker Hardening, Multi-Arch, Image-Scanning, OCI-Flows                             |
| `12_POLICY_AS_CODE_PROMPT.md`             | Rulesets, Permissions, Required-Checks, OPA/Regeln                                  |
| `13_OBSERVABILITY_METRICS_PROMPT.md`      | CI-Metriken, Flakiness, Kosten, SARIF/JSON/HTML, Prometheus                         |
| `14_ORG_HARDENING_PROMPT.md`              | Org-weite Defaults: Branch-Protection, Push-Protection, SSO                         |
| `15_RUNNERS_INFRA_PROMPT.md`              | Self-Hosted/Ephemeral Runner, Isolation, Labels, Kosten                             |
| `16_DISTRIBUTION_CHANNELS_PROMPT.md`      | Homebrew/Winget/Scoop, deb/rpm/apk, PyPI/NPM, OCI                                   |
| `17_INCIDENT_RESPONSE_PROMPT.md`          | Secret-Leak-Playbook, Freeze, Rewrite, Re-sign, Advisory                            |
| `INDEX.md`                                | Index aller Dateien mit Kurzbeschreibung                                            |
| `README.md`                               | Diese Übersicht                                                                     |
| `Makefile`                                | `make verify` und ZIP-Pakete bauen (`pack_original_17.zip`, `pack_extended_23.zip`) |

---

## ✅ Empfohlene Reihenfolge

1. **00 Common Guide** → 2) **01 Audit** → 3) **Clean-Reset (optional, falls nötig)** → 4) **02 CI-Baseline** → 5) **03 Security/Supply-Chain** → 6) **04 Releases** → 7) **05 Docs/DX** → 8) **06 Governance** → 9) **07 Migration/Backup** → 10) **08 Monorepo** → 11) **09 Lokale Git-Standards** → 12) **10 API-Automation** → 13) **11 Container** → 14) **12 Policy-as-Code** → 15) **13 Observability** → 16) **14 Org-Hardening** → 17) **15 Runner-Infra** → 18) **16 Distribution** → 19) **17 Incident Response**.

---

## 🧠 System-Prompt (für diesen Ordner)

> Diesen Block **unverändert** lassen. Er ist die Steueranweisung für GPT in diesem Projektordner.

```
Rolle:
Du bist ein technischer Berater und Systemoptimierer für GitHub-Repositories von TimInTech. Fokus: strukturierte Audits, Clean-Resets, CI/Security-Härtung, Releases, Distribution, Policy-as-Code, Observability. Du arbeitest deterministisch, idempotent, mit Dry-Run als Standard.

Dateizugriff:
Du hast in dieser Sitzung direkten Zugriff auf alle im Hauptordner liegenden Dateien:
- SYSTEM_INSTRUCTION_GITHUB.md
- CLEAN_RESET_PROMPT.md
- 00_COMMON_GUIDE.md
- 01_REPO_AUDIT_PROMPT.md … 17_INCIDENT_RESPONSE_PROMPT.md
- INDEX.md, README.md, Makefile
Es gibt keine Unterordner. Ein optionales screenshot.png kann vorhanden sein.

Verhalten:
1) Antworte kurz, präzise, in Deutsch. Keine Floskeln. Keine Versprechen für später. Keine Hintergrundarbeit.
2) Gib bei Dateiänderungen immer den **vollständigen neuen Dateiinhalt** aus.
3) **Dry-Run zuerst.** Erkläre geplante Änderungen, Backups/Tags/Bundles. Anwenden erst nach ausdrücklicher Freigabe.
4) **Clean-Reset** nur nach Audit begründet vorschlagen. Nutze CLEAN_RESET_PROMPT.md für verlustarme Historien-Korrekturen.
5) Befehle stets **copy-paste-fähig** mit `cd`, `nano`, `docker compose up -d`. Nutze `gh`/CLI wo sinnvoll.
6) Schreibe artefaktische Ausgaben nach `.audit/` (JSON/HTML/SARIF), wenn relevant.
7) Strukturierte Ausgabe: Input → Hebel → Output. Trenne Planung und Ausführung.
8) Wenn ein Themenbereich adressiert wird, ziehe **den passenden *_PROMPT.md** heran und folge dessen Checkliste.
9) Prüfe bei sicherheitsrelevanten oder zeitkritischen Aussagen aktuelle Quellen, bevor du Empfehlungen gibst.

Standard-Checks (immer prüfen):
- Secrets, Lizenzen, Branch-Schutz, CI-Gesundheit, Release-Historie, README-Links, SBOM/CVE-Befund, Runner-Status.
```

---

## 🧩 Arbeitsprinzipien

* **Warum vor Wie.** Erst Ziel und Risiken, dann Schritte.
* **Idempotenz.** Wiederholtes Ausführen darf keine Schäden erzeugen.
* **Rollback.** Immer einen Rückweg (Tag/Branch/Bundle/Snapshot).
* **Sichtbarkeit.** Berichte und Artefakte unter `.audit/`.
* **Vollständige Outputs.** Bei Dateiänderungen immer die ganze Datei neu schreiben.

---

## 🔁 Clean-Reset sicher anwenden

* Nur nach **Audit (01)** und **Common-Guide (00)**.
* **CLEAN_RESET_PROMPT.md** nutzen: Teil-Reset (`--scope`) bevorzugen, Autoren erhalten, Backups anlegen (`--bundle`, `--tag`).
* Nach Reset: **02 CI**, **03 Security**, **04 Releases** erneut validieren.

---

## 🧰 Makefile (optional lokal)

```bash
make verify      # Prüft lokale Tools (gh, git, jq)
make zip         # Baut ZIPs: pack_original_17.zip, pack_extended_23.zip
make clean       # Entfernt erzeugte ZIPs
```

---

## 🔒 Sicherheit & Compliance

* Secrets nie ins Repo. **Push-Protection** aktiv.
* Signierte Commits/Tags, SBOM + CVE-Scan bei Releases.
* Org-Regeln über **14_ORG_HARDENING_PROMPT.md** setzen.
* Runner hart isolieren (**15_RUNNERS_INFRA_PROMPT.md**).

---

## 📈 Observability

* CI-Laufzeiten, Queue-Times, Flakiness, Coverage, Kosten.
* Reports als **SARIF/JSON/HTML**, Export nach Prometheus.
* Dashboards aus **13_OBSERVABILITY_METRICS_PROMPT.md** ableiten.

---

## ✅ Ziele

* Einheitliche Struktur, nachvollziehbare Automatisierung, reproduzierbare Releases.
* Harter Security-Baseline, klare Governance, gepflegte Docs.
* Skalierbar von **Repo** bis **Org**.

---

📅 *Stand: 2025-10-12*
✍️ *Maintainer: TimInTech · GitHub Optimization System*

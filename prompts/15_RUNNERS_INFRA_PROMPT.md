# 15 · Runner Infra Prompt

## Ziel
Self-hosted und Ephemeral Runner planbar betreiben. Kosten, Isolation und Sicherheit im Griff.

## Baseline
- Labels: `x64`, `arm64`, `gpu`, `large`
- Isolation: Rootless-Container, ausgehender Traffic minimal
- Ephemeral Registration Tokens verwenden

## Beispiele
```bash
# Runner-Registration (Beispiel-Skript, Platzhalter ersetzen)
cd /opt/actions-runner && ./config.sh --url "https://github.com/$ORG/$REPO" --token "$TOKEN" --labels "x64,ephemeral" --ephemeral
sudo ./svc.sh install && sudo ./svc.sh start
```

## CI-Hinweise
- `concurrency: cancel-in-progress: true`
- Caching pro Ecosystem (node/pip/go/cargo)
- Test-Sharding, Flake-Quarantäne

## Observability
- Runner-Logs an zentralen Speicher (Promtail/Loki)
- Kennzahlen: Warteschlangenzeit, Laufzeit, Fehlerquote

## CleanReset-Bezug
Wenn Runner-Definitionen im Repo liegen, nach Reset Workflows validieren und Runner-Labels konsistent halten.

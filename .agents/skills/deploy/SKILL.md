---
name: deploy
description: "Deploy or publish project artifacts safely. Use when Codex needs to prepare a site, service, documentation artifact, or generated output for release, confirm prerequisites, and outline the reproducible deployment steps without skipping verification."
---

# Deploy

## Workflow

1. Identify what is being deployed and where.
2. Verify build and environment prerequisites first.
3. Keep the release path reproducible and documented.
4. Prefer dry-run style verification before any live change.

## Load references as needed

- Read `references/deploy-rules.md` for release and rollback checks.

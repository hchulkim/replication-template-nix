---
name: replication-project-init
description: "Set up a project from this replication template for Codex. Use when cloning or customizing the template, wiring Dropbox symlinks, preparing the nix or rix environment, replacing placeholder project metadata, or checking that the issue-numbered folder layout is ready for research work."
---

# Replication Project Init

Use this skill to get a fresh project into a runnable state without dragging the full old Claude workflow into context.

## Workflow

1. Read `README.md`, `WORKFLOW.md`, `AGENTS.md`, and the environment files before editing anything.
2. Confirm the project identity:
   - repo name
   - Dropbox path assumptions
   - main analysis language
   - whether paper and slides will live under `output/`
3. Set up or verify the symlinked layout for `data/` and `output/`.
4. Update the project metadata that should stop referring to the template.
5. Verify the environment using the smallest relevant command.

## Focus areas

- Keep the repo code-only; do not generate tracked data or output fixtures.
- Prefer editing the setup instructions, environment manifests, and issue-numbered folders over adding one-off docs.
- Preserve `generate_env.R`, `generate_env_python.R`, `Makefile`, and `Dockerfile` unless the task actually needs changes there.

## Load references as needed

- Read `references/setup-checklist.md` for the exact bootstrap checklist and handoff outputs.

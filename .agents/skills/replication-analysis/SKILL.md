---
name: replication-analysis
description: "Implement build and analysis work inside this replication template. Use when Codex needs to create or revise scripts under `code/build/` or `code/analysis/`, construct datasets, run estimators, generate tables or figures, or keep outputs aligned with the numbered issue-folder workflow."
---

# Replication Analysis

Use this skill to turn an approved analysis idea into scripts and outputs that fit the repo's numbered workflow.

## Workflow

1. Locate the target workstream and nearest existing pattern.
2. Decide whether the task belongs in:
   - `code/build/NN_issue_name/`
   - `code/analysis/NN_issue_name/`
3. Implement the smallest vertical slice that produces a concrete artifact.
4. Save outputs to the matching numbered folder under `data/build/` or `output/`.
5. Verify with the narrowest credible command, preferably through `nix-shell`.

## Non-negotiables

- Use relative paths only.
- For R execution, prefer `nix-shell --run "Rscript ..."` unless the task is explicitly about bootstrapping the environment itself.
- For Python execution, prefer `uv run ...` and keep dependency changes reflected in the repo's Python dependency files.
- Document sample restrictions, merges, and dropped observations.
- Save reproducible intermediates when they matter for downstream work.
- Do not silently change estimators, clustering, or file destinations.

## Load references as needed

- Read `references/script-standards.md` for script structure, output conventions, and verification expectations.

---
name: econometrics-r
description: "Implement or review econometrics workflows in R. Use when Codex needs to write R estimation scripts, translate an empirical design into R code, enforce reproducible R execution through `nix-shell`, or review R analysis output against project conventions."
---

# Econometrics R

## Workflow

1. Start from the design memo or estimation target.
2. Keep R work in the numbered build or analysis folders.
3. Run R via `nix-shell --run "Rscript ..."` unless the task is environment setup.
4. Save outputs and intermediates explicitly.

## Load references as needed

- Read `references/r-workflow.md` for execution and style expectations.

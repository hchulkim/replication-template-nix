---
name: replication-audit
description: "Audit this repository as a replication package. Use when Codex needs to verify script execution, LaTeX compilation, file integrity, output freshness, dependency documentation, and AEA-style submission readiness before sharing, archiving, or submitting a paper."
---

# Replication Audit

Use this skill as the mechanical verification gate. Focus on whether another researcher can run the package and reproduce the manuscript artifacts.

## Workflow

1. Identify the package root and the main manuscript or slide entry point.
2. Run the standard checks first.
3. If the task is for sharing or submission, run the expanded audit.
4. Report failures with the exact command, file, and missing artifact.

## Standard checks

- LaTeX or Quarto compilation
- script execution
- file integrity for referenced inputs and outputs
- stale output detection

## Load references as needed

- Read `references/audit-checklist.md` for the standard and submission-level audit checklist.

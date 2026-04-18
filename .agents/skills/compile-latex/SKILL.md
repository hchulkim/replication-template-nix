---
name: compile-latex
description: "Compile LaTeX papers or slide decks reproducibly. Use when Codex needs to build a paper or Beamer deck, summarize warnings, rerun bibliography steps, or verify that a manuscript target compiles cleanly before review or submission."
---

# Compile Latex

## Workflow

1. Identify the main `.tex` target and bibliography inputs.
2. Prefer the repo's existing build pattern if one exists.
3. Report undefined citations, broken refs, and overfull warnings.
4. Keep the output focused on actionable compile issues.

## Load references as needed

- Read `references/latex-build-notes.md` for build sequences and warning priorities.

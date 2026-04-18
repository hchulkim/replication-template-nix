---
name: validate-bib
description: "Check project citations against bibliography entries. Use when Codex needs to scan `.tex` or `.qmd` files for citation keys, find missing bibliography entries, detect unused or malformed references, or produce a bibliography cleanup report before compilation or submission."
---

# Validate Bib

Use this skill before compile-heavy paper work or submission when bibliography drift is likely.

## Workflow

1. Identify the bibliography file.
2. Scan manuscript and slide sources for citation keys.
3. Cross-check:
   - cited but missing
   - present but unused
   - suspiciously similar keys
4. Report the results before editing anything.

## Output rules

- Missing citations are highest priority.
- Unused entries are informational unless the user wants cleanup.
- Keep the report keyed to exact citation strings.

## Load references as needed

- Read `references/citation-scan.md` for file patterns and report format.

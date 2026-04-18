---
name: research-code-review
description: "Review research code for reproducibility, correctness risk, and professional polish. Use when Codex needs to review R, Stata, Python, Julia, or shell scripts that build datasets, estimate models, or generate paper outputs, especially before commits, PRs, or sharing results."
---

# Research Code Review

Use this skill in review mode. Do not rewrite code unless the user explicitly asks for fixes after the review.

## Workflow

1. Review the diff or target files first.
2. Prioritize findings that can change results, break reproducibility, or confuse downstream paper generation.
3. Report findings before summaries.
4. Cite exact files and lines whenever possible.

## Review priorities

- wrong estimators, clustering, or sample logic
- absolute paths or local-machine assumptions
- non-reproducible randomness
- missing output creation or stale output risk
- style issues only after correctness and reproducibility

## Load references as needed

- Read `references/review-rubric.md` for the scoring frame and checklist.

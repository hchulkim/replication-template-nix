---
name: review-paper
description: "Simulate a referee-style review of a manuscript, paper draft, or empirical memo. Use when Codex needs to act like a journal referee, assess contribution and identification and evidence and writing, produce major and minor comments, or generate a structured peer-review memo before submission."
---

# Review Paper

Use this skill in critic mode. It should read like an actual blind referee report, not a generic summary.

## Workflow

1. Read the manuscript and identify the paper's claim, design, and likely target journal tier.
2. Evaluate the paper across contribution, identification, evidence, writing, and fit.
3. Separate major comments from minor comments.
4. Make a calibrated recommendation:
   - accept
   - minor revisions
   - major revisions
   - reject

## Output rules

- Be specific about sections, tables, equations, and missing evidence.
- Judge the paper, not the code implementation details, unless they affect credibility.
- Keep the report constructive even when the recommendation is negative.

## Load references as needed

- Read `references/referee-rubric.md` for the evaluation dimensions and report format.

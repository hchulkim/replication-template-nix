# Codex Workflow

This repository keeps the old Claude setup in `.claude/`, but the Codex source of truth is this file plus the local skills in `.agents/skills/`.

## Working rules

- Keep `SKILL.md` files short. Put long rubrics, templates, and checklists in `references/`.
- Treat Git as code only. Keep raw data and generated output in the symlinked `data/` and `output/` trees, not in tracked folders.
- Map work to numbered issue folders when possible:
  - `code/build/NN_issue_name/`
  - `code/analysis/NN_issue_name/`
  - `output/NN_issue_name/tables/`
  - `output/NN_issue_name/figures/`
- Prefer `nix-shell --run ...` or the repo's existing automation for verification when the task depends on the project environment.
- For R commands, prefer `nix-shell --run "Rscript ..."` over bare `Rscript`.
- For Python commands, prefer `uv run ...` so execution uses the project-managed environment.
- Use relative paths only. Do not add `setwd()` or absolute Dropbox paths.
- Before larger edits, read the closest existing script, table, figure, or manuscript section and follow the local pattern.
- Verify before closing work: script run, test, lint, compile, or a concrete manual check.

## Using subagents

Codex already has built-in subagent types. Keep delegation narrow:

- Use `explorer` for bounded read-only tasks such as locating prior code, tracing a variable, or summarizing a paper section.
- Use `worker` for isolated implementation slices with a disjoint write scope.
- Keep the critical path local. Do not delegate the next blocking step just to wait for it.
- Ask critics to review, not rewrite. Findings should feed back into the main implementation.

## Local skills

Use the smallest matching skill and load only its referenced files when needed:

- `replication-project-init`: bootstrap a new project from this template.
- `interview-me`: elicit a project idea through questions.
- `research-ideation`: generate and filter project ideas.
- `literature-review`: survey papers and build a contribution memo.
- `find-data`: identify and compare candidate datasets.
- `identification-strategy`: design or audit an empirical strategy.
- `replication-analysis`: implement build or analysis scripts in the numbered workflow.
- `econometrics-r`: implement or review econometrics code in R.
- `econometrics-julia`: implement or review econometrics code in Julia.
- `research-code-review`: review research scripts for reproducibility and polish.
- `paper-drafting`: draft or revise manuscript sections from existing results.
- `review-paper`: simulate a referee-style manuscript review.
- `respond-to-referee`: draft point-by-point responses to reports.
- `compile-latex`: compile paper or slide targets and summarize warnings.
- `quarto-papers`: work on Quarto paper workflows.
- `latex-econ-model`: typeset economics model notation in LaTeX.
- `replication-audit`: audit the package for reproducibility and submission readiness.
- `data-deposit`: prepare materials for deposit.
- `submit`: run the final submission gate.
- `talk-from-paper`: convert a paper into a talk outline and slide plan.
- `target-journal`: rank journal targets for a draft.
- `validate-bib`: cross-check citations against bibliography entries.
- `visual-audit`: audit paper or slide visuals.
- `api-data-fetcher`: fetch reproducible API-based datasets.
- `general-equilibrium-model-builder`: structure GE model workflows.
- `journal`: write durable research journal entries.
- `learn`: capture reusable lessons.
- `context-status`: summarize durable session state.
- `deploy`: prepare deploy or release steps safely.

## Migration note

The `.claude/agents/` and `.claude/skills/` directories are reference material for this repo's prior workflow. Reuse ideas from them, but keep new Codex instructions concise and repo-local.

See `CLAUDE_TO_CODEX_SKILL_MAP.md` for the full inventory of legacy Claude skills and their current Codex status.

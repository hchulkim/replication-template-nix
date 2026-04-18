# Claude to Codex Skill Map

This file inventories every legacy skill under `.claude/skills/` and records how it is represented in the current Codex setup.

## Status meanings

- `codex-native`: has a direct local Codex skill in `.agents/skills/`
- `covered`: covered by a broader Codex skill or repo-level workflow rule
- `legacy-reference`: kept in `.claude/skills/` as reference material; not yet ported as a dedicated Codex skill

## Mapping

| Legacy Claude skill | Status | Codex equivalent or note |
|---|---|---|
| academic-paper-writer | covered | `paper-drafting` |
| api-data-fetcher | codex-native | `api-data-fetcher` |
| audit-replication | covered | `replication-audit` |
| code-simplifier | covered | general Codex editing workflow in `AGENTS.md` |
| compile-latex | codex-native | `compile-latex` |
| context-status | codex-native | `context-status` |
| create-talk | covered | `talk-from-paper` |
| data-analysis | covered | `replication-analysis` |
| data-deposit | codex-native | `data-deposit` |
| deploy | codex-native | `deploy` |
| draft-paper | covered | `paper-drafting` |
| econometrics-check | covered | `identification-strategy` plus `research-code-review` |
| econometrics-julia | codex-native | `econometrics-julia` |
| econometrics-r | codex-native | `econometrics-r` |
| find-data | codex-native | `find-data` |
| general-equilibrium-model-builder | codex-native | `general-equilibrium-model-builder` |
| humanizer | covered | `paper-drafting` style guards |
| identify | covered | `identification-strategy` |
| interview-me | codex-native | `interview-me` |
| journal | codex-native | `journal` |
| latex-econ-model | codex-native | `latex-econ-model` |
| learn | codex-native | `learn` |
| lit-review | covered | `literature-review` |
| new-project | covered | `replication-project-init` |
| paper-excellence | covered | combined use of `review-paper`, `research-code-review`, `replication-audit`, and `paper-drafting` |
| pre-analysis-plan | covered | `identification-strategy` |
| project-init | covered | `replication-project-init` |
| proofread | covered | `paper-drafting` plus `review-paper` |
| quarto-papers | codex-native | `quarto-papers` |
| replication-package | covered | `replication-audit` plus repo workflow docs |
| research-ideation | codex-native | `research-ideation` |
| respond-to-referee | codex-native | `respond-to-referee` |
| review-paper | codex-native | `review-paper` |
| review-r | covered | `research-code-review` |
| submit | codex-native | `submit` |
| target-journal | codex-native | `target-journal` |
| tech debt | covered | general Codex refactor and review workflow in `AGENTS.md` |
| validate-bib | codex-native | `validate-bib` |
| visual-audit | codex-native | `visual-audit` |

## Current Codex-native skills

- `replication-project-init`
- `literature-review`
- `find-data`
- `identification-strategy`
- `replication-analysis`
- `research-code-review`
- `paper-drafting`
- `review-paper`
- `respond-to-referee`
- `replication-audit`
- `talk-from-paper`
- `target-journal`
- `validate-bib`
- `api-data-fetcher`
- `compile-latex`
- `context-status`
- `data-deposit`
- `deploy`
- `econometrics-julia`
- `econometrics-r`
- `general-equilibrium-model-builder`
- `interview-me`
- `journal`
- `latex-econ-model`
- `learn`
- `quarto-papers`
- `research-ideation`
- `submit`
- `visual-audit`

## Reproducibility defaults

- For R execution, prefer `nix-shell --run "Rscript ..."` or interactive `nix-shell`.
- For Python execution, prefer `uv run ...` and keep dependencies reflected in `requirements.txt` or the chosen Python lock workflow.

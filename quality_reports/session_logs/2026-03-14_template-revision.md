# Session Log — 2026-03-14

## Goal
Revise and refine the replication template to reflect the user's actual workflow:
- Only `code/` in GitHub; `data/` and `output/` on Dropbox (symlinked)
- Numbered folders matching GitHub issues in `code/build/`, `code/analysis/`, `data/build/`, and `output/`
- `output/paper/` and `output/slides/` NOT numbered
- Fix `.claude/` setup issues
- Create a detailed workflow guide (WORKFLOW.md)

## Changes Made
- `.gitignore` — simplified, `data/` and `output/` fully ignored
- `code/build/01_example/` and `code/analysis/01_example/` — numbered example scripts
- `Makefile` — updated for new structure
- `README.md` — rewritten with GitHub vs Dropbox split, symlink instructions, numbering convention
- `CLAUDE.md` — updated project structure section
- `notify.sh` — fixed for Linux (notify-send)
- `generate_env_python.R` — fixed syntax error (closing paren before shell_hook)
- Updated agents: coder.md, verifier.md
- Updated rules: single-source-of-truth, quality-gates, separation-of-powers, table-generator, pdf-processing
- Restored quality_reports/, templates/, explorations/ directories
- Created WORKFLOW.md

## Decisions
- Numbered folders use `NN_issue_name` format (e.g., `01_data_cleaning`)
- Skills files left with generic paths (they adapt from CLAUDE.md context)
- `default.nix` gitignored (regenerated from `generate_env.R`)

## Open Questions
- User may want skills files updated too (many still reference old `output/tables/` paths)


---
**Context compaction (auto) at 13:20**
Check git log and quality_reports/plans/ for current state.

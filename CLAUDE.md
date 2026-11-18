# Project Instructions

## Scope and priorities

This is a multi-author academic research repository. Work must remain reproducible,
transparent, reviewable, and safe for another researcher to rerun.

These instructions apply repository-wide unless a more specific `CLAUDE.md` (in a
subdirectory) or a personal `CLAUDE.local.md` applies to the files being changed. The
user's current request takes precedence. When instructions or repository conventions
conflict in a way that could materially change results, explain the conflict and ask
before proceeding.

## Working style

- Treat coding and presentation preferences below as defaults to adapt to the task
  and surrounding code. They should support readability and review, not require
  unnecessary rewrites. Data boundaries and research-integrity safeguards still apply.
- Prefer simple, easy-to-understand code. Improve efficiency where useful, especially
  for large data, without sacrificing clarity for small performance gains.
- Read only the files and surrounding context needed for the task. Consult Makefiles,
  configuration, documentation, and upstream code when the proposed change depends on
  them; do not inventory the repository by default.
- Use the current on-disk version of any file before editing it.
- For a reported failure, inspect the exact command, error, relevant code, inputs, and
  dependencies before diagnosing it. Label hypotheses as hypotheses.
- Keep edits focused. Preserve unrelated code and working-tree changes, and do not
  reformat untouched code.
- For routine, reversible work, make reasonable assumptions and continue. Ask only
  when a choice could materially affect research results, data, external state, or an
  irreversible action.
- Carry requested implementation through targeted validation. Fix failures caused by
  the change and rerun the affected checks without stopping for approval at each step.

## Local execution and dependencies

For projects under `/home/himakun/`, `/home/hchulkim/`, `/Users/hchulkim/`, or
`/Users/himakun/`:

- Run R, Python, and Julia commands—including tests, formatters, package checks, and
  one-line commands—through the repository's Nix environment. Example:
  `nix-shell --run "Rscript code/analysis/1-task/01-script.R"`.
- Do not bypass Nix if it fails or its entry point is unclear; report the command and
  error.
- Ask before installing software or language packages, or changing Nix files,
  lockfiles, or package manifests.

## Repository and data boundaries

- The code repository contains source and documentation. Raw data, generated data,
  tables, figures, reports, and other outputs belong under `data/` and `output/`
  (see layout below), never in `code/`.
- Never modify `data/raw/` or overwrite existing analysis/output unless the user
  explicitly requests it.
- Preserve actual path casing. Never hardcode a user's absolute path in source code.
- Use `here::here()` (or `here()` after loading `here`) for project paths and rely on
  the `.here` file at the repository root. Never use `setwd()`.
- Follow the existing code-to-data-root mapping. Ask only if multiple plausible roots
  would lead to different results.
- Create required output directories without deleting existing contents.

### Layout

Each task uses one name (`<task>`, chosen by the user) across all trees:

- `code/build/<task>/`: build scripts, `00-config.R`, and the task `task.mk`.
- `code/analysis/<task>/`: analysis scripts and the task `task.mk`.
- `data/raw/`: source data; read-only.
- `data/build/<task>/`: cleaned or intermediate data written by `code/build/<task>/`.
- `output/<task>/tables/` and `output/<task>/figures/`: results written by
  `code/analysis/<task>/` (tables in `tables/`, figures in `figures/`).
- Where `code/pipeline.mk` exists, it includes every task `.mk` and the root `Makefile`
  includes it. Until then, steps are registered directly in the root `Makefile`.

New projects use lowercase `code/`; some older projects use `Code/`, so preserve
whatever casing the repository already has. `.here` marks the project root for
`here()`. `data/` and `output/` are either directories under that root or symlinks to
a shared data root (e.g. Dropbox); `here("data", ...)` and `here("output", ...)`
resolve either way. Do not replace symlinks or move data into the code repository.

A script writes only to its own task's `data/build/<task>/` or `output/<task>/`
directories. Read another task's results only from its `data/build/<task>/` outputs
and register that file as a Make dependency.

## Pipeline changes

Apply this section when adding or modifying a research script, task, dependency, or
execution order:

- Read the affected task-level `.mk` file and the relevant part of
  `code/pipeline.mk` (or the root `Makefile` where no `pipeline.mk` exists).
- Register every research script in its task-level `.mk` file as an executed step or
  explicit dependency, with explicit inputs and outputs. Register every task in the
  master pipeline.
- Keep a script's numbered prefix, Make step, header inputs/outputs, and generated
  paths synchronized.
- Do not change pipeline order, target names, or dependencies as incidental cleanup.
- If execution order changes, update all affected script, task, data/output directory,
  Makefile, header, and documentation references, then search for stale names.
- Run the narrowest affected target. Run the full pipeline only when task order,
  registration, shared upstream data, or cross-task dependencies changed. If data,
  credentials, compute, or another resource prevents a full run, perform the feasible
  narrower checks and state the limitation.

## Statistical analysis and outputs

Before creating or substantially editing an R, R Markdown, or Quarto script, read
`.claude/rules/r-scripts.md` (R style, data manipulation, table formatting, figures)
if it is not already in context.


- Prefer `fixest` for supported regression models. Keep outcome, treatment, controls,
  fixed effects, weights, clustering, and estimation sample visible near the model.
- Use `fixest::setFixest_dict()` for publication labels, `fixest::etable()` for
  regression tables, and `broom::tidy()` for programmatic coefficient extraction.
  Use `texreg` only when `etable()` cannot support the required model or table.
- Write regression `.tex` tables with `fixest::etable(..., tex = TRUE,
  style.tex = fixest::style.tex("aer"))`; keep an existing table's style unless asked.
- Do not broadly suppress estimation errors or silently omit failed required models.
- Preserve existing specifications when adding new ones. Give new models and outputs
  distinct, descriptive names.
- Ask before changing an estimand, sample, variable definition, fixed effect, weight,
  clustering level, standard-error method, or significance convention unless the
  user explicitly requested that exact change. State how such a change can affect
  results.
- For each required `.tex` table, write a matching `.md` table from the same finalized
  model list or data object, with consistent values, labels, order, rounding, caption,
  and notes. Register both as Make targets.
- Prefer `kableExtra::kbl()` for non-regression tables. Use
  `kableExtra::save_kable()` to save kable objects in formats supported by the
  installed version, including `.tex`, `.md`, `.html`, `.pdf`, `.png`, and `.jpg`.
  Ensure the object's format matches the file extension; use another appropriate
  writer only when the output is not a kable object.

## Validation and completion

Match validation effort to the change:

- Always inspect the final diff and check for unintended edits.
- For documentation-only or local edits, run only directly relevant checks.
- For code changes, run syntax/parse checks and the narrowest affected task through
  Nix. Confirm required outputs exist and are non-empty when the task generates them.
- Search for stale paths, filenames, step numbers, task names, or output references
  only when the change could create them.
- Use the full pipeline criteria in “Pipeline changes”; do not run it by default.
- Report what ran, what passed, and what could not be verified. Never claim success
  for a command or pipeline that was not run successfully in the current state.

## Git and destructive actions

- Do not commit, push, rebase, merge, or open a pull request unless the user asks.
- Never discard changes or use destructive Git commands without explicit permission.
- If conflicts exist, inspect and summarize them, then ask before resolving them.
- Ask before modifying raw data, replacing/deleting existing analysis or outputs,
  installing dependencies, changing environment files, or taking an irreversible
  action not explicitly requested.

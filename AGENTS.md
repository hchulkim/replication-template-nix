# Project Instructions

## Scope and priorities

This is a multi-author academic research repository. Work must remain reproducible,
transparent, reviewable, and safe for another researcher to rerun.

These instructions apply repository-wide unless a more specific `AGENTS.md` or
`AGENTS.override.md` applies to the files being changed. The user's current request
takes precedence. When instructions or repository conventions conflict in a way that
could materially change results, explain the conflict and ask before proceeding.

## Working style

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
  `nix-shell --run "Rscript Code/analysis/01_task/01_script.R"`.
- Do not bypass Nix if it fails or its entry point is unclear; report the command and
  error.
- Ask before installing software or language packages, or changing Nix files,
  lockfiles, or package manifests.

## Repository and data boundaries

- The code repository contains source and documentation. Raw data, generated data,
  tables, figures, reports, and other outputs belong in the configured project data
  directory.
- Never modify `data/raw/` or overwrite existing analysis/output unless the user
  explicitly requests it.
- Preserve actual path casing. Never hardcode a user's absolute path in source code.
- Use `here::here()` (or `here()` after loading `here`) for project paths and rely on
  the data root's `.here` file. Never use `setwd()`.
- Follow the existing code-to-data-root mapping. Ask only if multiple plausible roots
  would lead to different results.
- Create required output directories without deleting existing contents.

The expected layout is a code repository with `Code/pipeline.mk`, task-level `.mk`
files and scripts under `Code/build/` or `Code/analysis/`, paired with a separate data
root containing `.here`, `data/raw/`, `data/build/`, and `output/`.

## Pipeline changes

Apply this section when adding or modifying a research script, task, dependency, or
execution order:

- Read the affected task-level `.mk` file and the relevant part of
  `Code/pipeline.mk`.
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

## R scripts

When creating or substantially changing an R data-processing, modeling, table,
figure, or spatial-analysis script, read
[`docs/agent-guides/r-best-practices.md`](docs/agent-guides/r-best-practices.md) for
project examples. Skip that guide for minor comments, renames, formatting-only edits,
and non-R tasks. Treat its examples as adaptable patterns, not mandatory templates.

### Header and organization

New scripts must start with a concise header containing title, maintainer, initial and
modified dates, description and unit of analysis, inputs, and outputs. When editing,
preserve the original maintainer and initial date and keep the description and I/O
accurate; update the modified date only when repository convention requires it.

- Use short, labeled logical sections and comments for purpose, assumptions, and
  non-obvious choices. Do not narrate obvious syntax.
- Add a brief adjacent comment explaining each data input.
- Keep console output limited to useful progress and validation messages.

### Packages, paths, and style

- Load used packages once near the top with one `pacman::p_load(...)` call. Spell
  `pacman` correctly and do not add unused or unnecessary packages.
- Define reused input/output directories once; use `here()` directly for one-off
  paths.
- Follow the surrounding style when consistent. Otherwise use two-space indentation,
  `<-`, `snake_case`, `TRUE`/`FALSE`, spaces around operators and after commas, and
  roughly 100-character lines when clarity permits.
- Prefer named vectors/lists or small functions over copied specifications.

### Data manipulation

- Prefer `data.table`; use `fread()`/`fwrite()` for delimited files unless the task
  already requires another format.
- Use `:=` intentionally and `copy()` when the original object must remain unchanged.
- Read only needed columns from large files when practical.
- State join keys and retention explicitly. Check uniqueness before joins expected to
  be one-to-one or many-to-one, and guard against row multiplication.
- Sort explicitly before `shift()`, cumulative operations, or other order-dependent
  work.
- Handle missing and non-finite values deliberately. Use `na.rm = TRUE` only when it
  matches the estimand, and document consequential filtering.
- Set a seed immediately before randomized work and explain why randomness is used.
- Assert essential invariants with clear checks instead of printing large objects.

## Statistical analysis and outputs

- Prefer `fixest` for supported regression models. Keep outcome, treatment, controls,
  fixed effects, weights, clustering, and estimation sample visible near the model.
- Use `fixest::setFixest_dict()` for publication labels, `fixest::etable()` for
  regression tables, and `broom::tidy()` for programmatic coefficient extraction.
  Use `texreg` only when `etable()` cannot support the required model or table.
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

## Figures and spatial work

- Use `ggplot2`, clear labels and units, and explicit output dimensions/resolution.
  Use a minimal statistical theme and `theme_void()` for maps only when axes have no
  substantive meaning.
- Use `sf` for vector data and `terra` for rasters. Check or transform coordinate
  reference systems before joins, distances, areas, or extraction, and validate
  geometries when invalid features could affect results.
- Document intentionally excluded geographic units and why they were excluded.

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

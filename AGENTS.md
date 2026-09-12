# Project Instructions

## Scope and Purpose

This is a multi-author academic research repository. All work must be replicable,
transparent, reviewable, and easy for another researcher to rerun.

These instructions apply to the entire repository unless a more specific
`AGENTS.md` or `AGENTS.override.md` exists in a subdirectory. Follow the more
specific file for work in that subtree.

## Instruction Strength

Interpret the terms in this file as follows:

- **Must** and **never** are mandatory.
- **Prefer** means use the stated approach unless the existing code or task gives a
  concrete reason not to.
- **Ask first** means stop and obtain explicit user approval before acting.

When an instruction conflicts with the current user's explicit request, follow the
current request. When repository conventions conflict or the correct interpretation
would materially change results, describe the conflict and ask the user.

## Before Suggesting, Diagnosing, or Editing

Before making any suggestion, diagnosis, or edit:

1. Read the current version of every relevant file and enough surrounding context to
   understand the code path.
2. Check the applicable `AGENTS.md`, Makefile fragments, configuration, and nearby
   scripts.
3. Do not rely on a previously viewed version of a file.
4. Do not recommend code that is already present.
5. If an error is reported, inspect the exact failing command, error message,
   surrounding code, inputs, and upstream dependencies before proposing a cause.
6. Distinguish observed facts from hypotheses. Do not present an unverified diagnosis
   as certain.

Keep edits narrowly scoped. Do not modify unrelated files or reformat untouched code.

## Environment-Specific Execution

Treat a project under any of the following paths as Hyoungchul's local environment:

- `/home/himakun/`
- `/home/hchulkim/`
- `/Users/hchulkim/`
- `/Users/himakun/`

In this environment:

- Run all R, Python, and Julia commands through Nix. For example:
  `nix-shell --run "Rscript Code/analysis/01_task/01_script.R"`.
- This requirement includes scripts, tests, formatters, package checks, and interactive
  one-line commands. Do not invoke `R`, `Rscript`, `python`, or `julia` directly.
- Never install software or language packages without explicit permission.
- Do not run `install.packages()`, `pak::pkg_install()`, `pip install`, `conda install`,
  `julia Pkg.add`, or an equivalent installation command without permission.
- Ask first before changing Nix environment files, lockfiles, or package manifests.

If Nix fails or the correct Nix entry point is unclear, report the command and error;
do not bypass Nix silently.

## Repository and Data Boundaries

The code repository contains source code and documentation only. Data, generated
tables, figures, reports, and other outputs belong in the user's project data
directory, never in the code repository.

Expected code-repository structure:

```text
research_title/
├── code/
│   ├── pipeline.mk
│   ├── build/
│   │   └── XX_task/
│   │       ├── XX_task.mk
│   │       ├── 01_script.R
│   │       └── ...
│   └── analysis/
│       └── XX_task/
│           ├── XX_task.mk
│           ├── 01_script.R
│           └── ...
└── README.md
```

Expected project data-directory structure:

```text
project_data_root/
├── .here
├── data/
│   ├── raw/
│   └── build/
│       └── XX_task/
└── output/
    └── XX_task/
```

Rules:

- Treat paths as case-sensitive. Inspect the repository and preserve its actual
  casing; do not silently change `Code/` to `code/` or the reverse.
- Never modify files in `data/raw/`.
- Never write generated data or outputs into the code repository.
- Never hardcode a user's absolute path in source code.
- Use `here::here()` for project paths and rely on the `.here` file at the project
  data root. Never use `setwd()`.
- Follow existing repository configuration that maps the code repository to the
  project data root. If that mapping is unclear, ask the user before changing paths.
- Create output directories explicitly when needed, without deleting their existing
  contents.

## Makefile and Pipeline Discipline

The build uses a two-level `.mk` structure:

- `Code/pipeline.mk` is the master pipeline and calls task-level `.mk` files in order.
- Each `Code/build/XX_task/XX_task.mk` or
  `Code/analysis/XX_task/XX_task.mk` runs the scripts for one task in order.

Every research script must appear in its task-level `.mk` file, either as an executed
step or an explicit dependency. Every task must be registered in `Code/pipeline.mk`.
Do not leave an unregistered script or task.

When adding or modifying a script:

1. Read the task-level `.mk` file and the relevant section of `Code/pipeline.mk`.
2. Add or update the script target in the task-level `.mk` file with explicit input
   dependencies and output targets.
3. Ensure the Make step number matches the script filename prefix. Step `01` must run
   a file beginning with `01_`.
4. If this is a new task folder, register its `.mk` file in `Code/pipeline.mk`.
5. Keep the script header's Inputs and Outputs synchronized with the Make targets and
   dependencies.
6. Run the narrowest affected task target through `nix-shell` and report the result.

When execution order changes:

1. Renumber all affected scripts.
2. Renumber all affected task folders and task `.mk` files.
3. Renumber the matching task subdirectories under `data/build/` and `output/` where
   applicable.
4. Update all affected references in scripts, headers, documentation,
   `Code/pipeline.mk`, and task-level `.mk` files.
5. Search for stale references to the old names or numbers.
6. Run the full pipeline end to end through `nix-shell`. If the run requires
   unavailable data, credentials, excessive compute, or another external resource,
   explain that limitation and run every feasible narrower check instead.

Do not change pipeline order, target names, or dependencies merely as cleanup.

## R Script Structure

New R scripts must begin with a concise header in this form:

```r
###############################################################################
# Title: <descriptive title>
# Maintainer: <name>
# Initial date: YYYY-MM-DD
# Modified date: YYYY-MM-DD
#
# Description:
#   <what the script does and the unit of analysis>
#
# Inputs:
#   - data/build/XX_task/input_file.ext
#
# Outputs:
#   - output/XX_task/table_or_figure.ext
###############################################################################
```

When editing an existing script:

- Preserve the original maintainer and initial date.
- Update the modified date only when the repository's existing convention calls for
  it.
- Keep the Description, Inputs, and Outputs accurate.
- Organize code into short, clearly labeled logical sections.
- Put one blank line between logical blocks and two blank lines only between major
  sections.
- Add comments that explain purpose, assumptions, or non-obvious choices. Do not
  narrate obvious syntax.
- Add a brief adjacent comment for every data input explaining what the file contains
  or why it is used.
- Keep console output minimal. Prefer a small number of meaningful progress messages
  and explicit validation failures over decorative banners or repeated data prints.

## R Package and Path Conventions

- Load required packages once, near the top of the script, with a single
  `pacman::p_load(...)` call.
- Spell the package as `pacman`, not `paceman`.
- Do not add a package to `p_load()` unless the script actually uses it.
- Do not add a new package when the task can be completed clearly with an already
  loaded dependency or base R.
- Use `here::here()` or `here()` after loading `here`; never construct project paths
  from a home directory.
- Define reused input and output directories once. For one-off paths, call `here()`
  directly.

Preferred setup pattern:

```r
pacman::p_load(here, data.table, fixest, ggplot2)

input_dir <- here("data", "build", "09_build_main_panel")
table_dir <- here("output", "09_main_analysis", "tables")
figure_dir <- here("output", "09_main_analysis", "figures")

dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(figure_dir, recursive = TRUE, showWarnings = FALSE)

# Main analysis panel at the grid-cell-by-year level
panel <- fread(file.path(input_dir, "main_panel.csv"))
```

## R Formatting and Naming

- Follow the surrounding file when it has a clear, consistent style. Otherwise:
  - use two spaces for indentation;
  - use `<-` for assignment;
  - use `snake_case` for objects and functions;
  - write `TRUE` and `FALSE`, never `T` and `F`;
  - put spaces around infix operators and after commas;
  - wrap long calls so each major argument is easy to scan;
  - target a maximum line length of approximately 100 characters, allowing longer
    model formulas or LaTeX strings when splitting would reduce clarity.
- Use descriptive names. Short names such as `dt`, `x`, or `res` are acceptable only
  in a small local scope where their meaning is immediately clear.
- Keep related specifications in named vectors or lists rather than copying nearly
  identical code.

## Data Manipulation

- Prefer `data.table` syntax for tabular data manipulation.
- Use `fread()` and `fwrite()` for delimited files unless the existing task requires a
  different reader or writer.
- Use `:=` for intentional modification by reference.
- Use `copy()` before `:=` when the original object must remain unchanged.
- Select only required columns when reading large files when practical.
- State join keys explicitly. Before a join that should be many-to-one or one-to-one,
  check key uniqueness and guard against unintended row multiplication.
- State join retention intentionally with `all.x`, `all.y`, or `all`; do not rely on an
  ambiguous default.
- Sort explicitly with `setorder()` before `shift()`, cumulative calculations, or any
  operation whose meaning depends on row order.
- Handle missing and non-finite values deliberately. Use `na.rm = TRUE` only when
  omitting missing values matches the estimand, and document consequential filtering.
- Prefer vectorized operations, `lapply()`, `vapply()`, or `purrr::map*()` over `for`
  loops when this improves clarity. Use a loop when it is clearer or materially more
  memory-efficient.
- Use `janitor::clean_names()` when imported column names are inconsistent and
  downstream code does not require the original names.
- Use `set.seed()` immediately before any randomized operation and document why
  randomness is used.
- Prefer assertions such as `stopifnot()` or clear `stop()` conditions for essential
  invariants instead of printing large intermediate objects.

Preferred transformation pattern:

```r
analysis_data <- copy(raw_data)

stopifnot(anyDuplicated(analysis_data[, .(unit_id, year)]) == 0L)
setorder(analysis_data, unit_id, year)

analysis_data[, outcome_lag := shift(outcome), by = unit_id]
analysis_data[, outcome_change := outcome - outcome_lag]
analysis_data <- analysis_data[is.finite(outcome_change)]
```

## Regression and Statistical Output

- Use `fixest` for OLS, fixed-effects, IV, and related regressions when supported.
- Make the outcome, treatment, controls, fixed effects, weights, clustering level, and
  estimation sample visible near the model definition.
- Reuse common specifications through named vectors, lists, or small functions.
- Use `fixest::setFixest_dict()` to give variables and fixed effects publication-ready
  labels.
- Use `fixest::etable()` for `fixest` regression tables.
- Use `broom::tidy()` to extract coefficients, standard errors, confidence intervals,
  and p-values for subsequent calculations or plots. Do not parse printed model text.
- Use `texreg` only when `etable()` does not support the model class or required table.
- Do not suppress estimation errors broadly. A safe wrapper may be used for an
  explicitly exploratory batch, but final output must verify that every required model
  succeeded and must not silently omit failed specifications.
- Keep existing regressions intact when adding a regression. Give new models distinct,
  descriptive object names and add them in a separate labeled block.
- Do not change an estimand, sample filter, fixed effect, weight, clustering level,
  standard-error method, or significance convention without explicitly calling out the
  change.

Preferred model pattern:

```r
outcomes <- c("yield_mean", "yield_maize", "yield_wheat")
controls <- c("precipitation", "temperature", "drought_year")
fixed_effects <- c("cell_id", "country^year")

estimate_ols <- function(outcome) {
  model_formula <- as.formula(sprintf(
    "%s ~ treatment + %s | %s",
    outcome,
    paste(controls, collapse = " + "),
    paste(fixed_effects, collapse = " + ")
  ))

  feols(
    model_formula,
    data = analysis_data,
    weights = ~cropland,
    cluster = ~region_id
  )
}

ols_models <- lapply(outcomes, estimate_ols)
stopifnot(length(ols_models) == length(outcomes))
```

## Tables

- For regression tables, prefer `etable()`.
- For non-regression tables, use `kableExtra::kbl()` and `kableExtra` styling
  functions. Do not call `knitr::kable()` directly.
- Whenever a table is written as `.tex`, also write an equivalent Markdown table as
  `.md` from the same underlying object so results can be reviewed without compiling
  LaTeX.
- For Markdown, prefer an existing project helper. Otherwise use a Markdown-capable
  `etable()` option supported by the installed `fixest` version or
  `kableExtra::kbl(..., format = "pipe")` for data-frame-like results.
- Do not install a package solely to create the second format.
- Keep labels, column order, sample, rounding, and notes consistent across `.tex` and
  `.md` outputs.
- Use `booktabs`-style LaTeX and publication-ready labels unless the project specifies
  a journal template.
- Write both outputs in the script and register both as Make targets.
- Finalize the model list or table data before formatting. Never calculate statistics
  independently inside the LaTeX and Markdown output calls.
- Keep output basenames paired, for example `main_results.tex` and
  `main_results.md`.
- Use `kableExtra::save_kable()` for output extensions supported by the installed
  `kableExtra` version, especially rendered `.html`, `.pdf`, `.png`, or `.jpg`
  artifacts. For raw `.tex` or `.md` source, use `writeLines()` unless the installed
  version explicitly supports that extension. Do not change the requested output
  format merely to use `save_kable()`.

### Paired regression-table template with `etable()`

Use a named model list to control column order and labels. Use direct `etable()` calls;
do not use `do.call()` merely to avoid repeating a short, readable set of formatting
arguments. Keep the two calls visibly adjacent so reviewers can compare them. Ensure
`here`, `fixest`, and `kableExtra` are included in the script's single
`pacman::p_load()` call.

```r
# Publication labels shared by the LaTeX and Markdown tables
setFixest_dict(c(
  "yield_mean" = "Mean crop yield (t/ha)",
  "yield_maize" = "Maize yield (t/ha)",
  "swarm_hit_season" = "Swarm shock",
  "cell_id" = "Cell",
  "iso3" = "Country",
  "year" = "Year"
))

# Named list fixes the output column order
ols_models <- list(
  "Mean yield" = estimate_ols("yield_mean"),
  "Maize yield" = estimate_ols("yield_maize")
)

stopifnot(length(ols_models) == 2L)
stopifnot(all(vapply(ols_models, inherits, logical(1), what = "fixest")))

# LaTeX output
etable(
  ols_models,
  tex = TRUE,
  se.below = TRUE,
  fitstat = ~ n + r2,
  keep = "Swarm shock",
  extralines = list("Controls" = rep("Yes", length(ols_models))),
  digits = 3,
  signif.code = c(`***` = 0.01, `**` = 0.05, `*` = 0.10),
  depvar = TRUE,
  style.tex = style.tex("aer"),
  file = file.path(table_dir, "ols_results.tex")
)

# Markdown output from the same models and matching options
etable_markdown <- etable(
  ols_models,
  tex = FALSE,
  se.below = TRUE,
  fitstat = ~ n + r2,
  keep = "Swarm shock",
  extralines = list("Controls" = rep("Yes", length(ols_models))),
  digits = 3,
  signif.code = c(`***` = 0.01, `**` = 0.05, `*` = 0.10),
  depvar = TRUE
)

markdown_table <- kableExtra::kbl(
  as.data.frame(etable_markdown),
  format = "pipe",
  row.names = TRUE
)

writeLines(
  as.character(markdown_table),
  file.path(table_dir, "ols_results.md")
)
```

Adapt `fitstat`, `keep`, `extralines`, and labels to the analysis, but keep the paired
calls synchronized. Use `summary(model, stage = 1)` for first-stage IV tables and give
those outputs a distinct paired basename such as `main_first_stage.tex` and
`main_first_stage.md`.

### Paired descriptive-table template with `kableExtra`

Construct and finalize one table object before formatting it. Ensure `here` and
`kableExtra` are included in the script's single `pacman::p_load()` call.

```r
# Final table values and display order; do not recalculate inside output calls
trade_summary <- trade_table[, .(
  Year = period,
  Export = round(export / 1e9, 1),
  Import = round(import / 1e9, 1),
  Balance = round((export - import) / 1e9, 1)
)]

table_caption <- "Trade with China (billion USD)"
table_alignment <- c("l", "r", "r", "r")

# LaTeX output with format-specific styling
latex_table <- kableExtra::kbl(
  trade_summary,
  format = "latex",
  booktabs = TRUE,
  caption = table_caption,
  align = table_alignment,
  digits = 1
) |>
  kableExtra::add_header_above(
    c(" " = 1, "Trade values" = 3),
    bold = TRUE
  ) |>
  kableExtra::kable_styling(
    latex_options = "hold_position",
    full_width = FALSE
  )

writeLines(
  as.character(latex_table),
  file.path(table_dir, "trade_summary.tex")
)

# Markdown output from the same finalized data, caption, order, and rounding
markdown_table <- kableExtra::kbl(
  trade_summary,
  format = "pipe",
  caption = table_caption,
  align = table_alignment,
  digits = 1
)

writeLines(
  as.character(markdown_table),
  file.path(table_dir, "trade_summary.md")
)

# Optional rendered copy when requested and supported by the environment
kableExtra::save_kable(
  latex_table,
  file = file.path(table_dir, "trade_summary.pdf"),
  keep_tex = FALSE
)
```

LaTeX-only presentation features such as spanning headers, `booktabs`, width control,
and placement options do not need a Markdown equivalent. The underlying values,
variable labels, column order, rounding, caption, and substantive notes must remain
the same.

Only add the optional `save_kable()` output when the rendered format is requested and
its system dependencies are available. Register that additional file in the task-level
`.mk` file. A failure to render a PDF or image must not prevent the script from writing
the required raw `.tex` and `.md` tables first.

## Figures and Spatial Analysis

- Use `ggplot2` for plots.
- Use a minimal theme for statistical plots and `theme_void()` for maps when axes have
  no substantive meaning.
- Include clear axis labels, legend labels, units, and captions or notes needed to
  understand transformations and samples.
- Save figures with explicit width, height, units, and resolution; do not depend on an
  interactive graphics-device size.
- Use `sf` for vector spatial data and polygons.
- Use `terra` for raster data and `terra::extract()` for raster extraction.
- Check and, when necessary, transform coordinate reference systems before spatial
  joins, distance calculations, area calculations, or extraction.
- Validate geometries when invalid polygons could affect the operation.
- Document intentionally excluded geographic units and the reason for exclusion.

## Editing Existing Work

- Never overwrite, delete, or replace existing analysis unless the user explicitly
  asks for that change.
- Preserve existing models, tables, figures, and output files when adding a new
  specification; use distinct names for new results.
- Add new work as a separate, clearly labeled cell or block at the logical location in
  the script or notebook.
- Do not duplicate an existing block merely to make a small modification. Make the
  smallest safe edit while preserving unrelated work.
- Do not change results as a side effect of style cleanup.
- Do not rewrite an entire script when a focused patch is sufficient.
- Before altering data construction or analysis logic, state whether the change can
  affect the sample, variable definition, estimand, or published output.

## Validation and Completion

After making changes:

1. Re-read the diff and check for unintended edits.
2. Confirm that all documented input and output paths match the code and Makefiles.
3. Search for stale filenames, step numbers, task names, and output references.
4. Run syntax or parse checks through `nix-shell`.
5. Run the narrowest relevant task-level Make target through `nix-shell`.
6. Run the full pipeline when execution order, task registration, shared upstream data,
   or pipeline dependencies changed.
7. Confirm that expected outputs exist and are non-empty. For paired tables, confirm
   both `.tex` and `.md` files were produced.
8. Report what was run, what passed, and anything that could not be verified.

Never claim a script or pipeline succeeds unless it was actually run successfully in
the current state.

## Git Discipline

- Do not create a commit, push, rebase, merge, or open a pull request unless the user
  asks.
- Keep commit messages brief and descriptive; exclude authorship claims or generated-by
  notices.
- Preserve unrelated working-tree changes.
- If conflicts exist, inspect and summarize them, then ask the user how to proceed
  before resolving them.
- Never discard changes or use destructive Git commands without explicit permission.

## Ask Before Proceeding When

Ask the user before:

- installing or adding a dependency;
- changing the Nix environment;
- modifying raw data;
- changing a statistical specification or estimation sample;
- replacing or deleting existing analysis or output;
- resolving a Git conflict;
- choosing among ambiguous project-data roots or path mappings;
- making a change that cannot be validated with the available data or environment and
  could materially affect results.

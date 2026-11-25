---
paths:
  - "**/*.R"
  - "**/*.Rmd"
  - "**/*.qmd"
---

# R script conventions

Loaded when working with R, R Markdown, or Quarto files. Research-integrity rules for
estimation (estimand/sample changes, suppressed errors) stay in the root `CLAUDE.md`.

## R scripts

### Header and organization

New scripts must start with a concise header containing title, maintainer, initial and
modified dates, description and unit of analysis, inputs, and outputs. When editing,
preserve the original maintainer and initial date and keep the description and I/O
accurate; update the modified date only when repository convention requires it.

- Use short, labeled logical sections and comments for purpose, assumptions, and
  non-obvious choices. Do not narrate obvious syntax.
- Separate logical groups of statements with blank lines so the flow is easy to read
  and review; avoid spacing every statement apart mechanically.
- Leave clear vertical space between code blocks, sections, and modules (for example,
  a blank line before each section header and between function definitions) so
  each unit is easy to scan.
- Add a brief adjacent comment explaining each data input.
- Keep console output limited to useful progress and validation messages.

### Packages, paths, and style

- Load used packages once near the top with one `pacman::p_load(...)` call. Do not
  add unused or unnecessary packages.
- Define reused input/output directories once; use `here()` directly for one-off
  paths.
- Follow the surrounding style when consistent. Otherwise use two-space indentation,
  `<-`, `snake_case`, `TRUE`/`FALSE`, spaces around operators and after commas, and
  roughly 100-character lines when clarity permits.
- Prefer named vectors/lists or small functions over copied specifications.
- Put reusable helpers in `R/` as pure, modular functions: pass inputs as arguments, return
  results, and do not modify global options (`options()`), the working directory
  (`setwd()`), or other global state.
- Default to a functional style: use `lapply()`/`Map()` (or vectorized operations)
  for repeated work. Use a `for` loop only when iterations depend on each other or
  the loop is clearly simpler.
- Bind tables with `data.table::rbindlist()` (lists of tables) or `rbind()` (a few
  named objects); do not use `do.call(rbind, ...)`. Likewise prefer direct functions
  such as `Reduce()` or `merge()` over `do.call()` wrappers when one exists.

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
- Account for `NA` and `NULL` explicitly, and do not assume a vector or table is
  non-empty without checking when emptiness is possible.
- Guard against silent vector recycling: verify lengths before element-wise operations
  on vectors that could differ (e.g., `stopifnot(length(a) == length(b))`).
- Set a seed immediately before randomized work and explain why randomness is used.
- Assert essential invariants with clear checks instead of printing large objects.
- Keep conditionals and assertions focused on meaningful risks, such as missing
  required inputs, invalid join keys, or unexpected sample changes. Avoid repetitive
  `if` branches and `stopifnot()` calls for conditions already guaranteed by the code.
  Remove temporary debugging checks once they have served their purpose, but retain
  checks that protect correctness on future runs; one successful run is not enough
  reason to remove those safeguards.

## Suggested table formatting

Use these as starting points for new tables, adapting them to the model, audience,
and existing project conventions. Do not restyle existing tables incidentally.

- For LaTeX regression tables, a useful `fixest::etable()` default is `tex = TRUE`,
  `se.below = TRUE`, `digits = 3`, `style.tex = fixest::style.tex("aer")`, and
  `fitstat = ~ n + r2` when those statistics suit the model. Use descriptive column
  headers and a named label dictionary through `dict` or `setFixest_dict()`.
- Prefer standalone `\begin{tabular} ... \end{tabular}` output for inclusion in the
  manuscript: set `float = FALSE` and use `tabular = "normal"`. Let the manuscript
  supply the surrounding `table` environment, caption, label, and placement. Use
  `float = TRUE` and an exported `\begin{table} ... \end{table}` wrapper only when
  the requested output or document workflow needs it. Set `float` explicitly because
  supplying an `etable()` caption or label can otherwise enable the wrapper.
- Use `depvar = FALSE` when column headers already identify the outcomes. Use `keep`
  only when a table intentionally focuses on selected coefficients, and make included
  controls and fixed effects clear elsewhere in the table or notes.
- For new tables without an established significance convention, the template default
  is `signif.code = c("***" = 0.01, "**" = 0.05, "*" = 0.1)`. Explain the symbols
  in the notes and preserve any existing convention unless a change is requested.
- For non-regression LaTeX tables, start with
  `kableExtra::kbl(..., format = "latex", booktabs = TRUE)`. Add
  `kableExtra::kable_styling(latex_options = "striped")` when shading improves
  readability and suits the publication format. Use `escape = FALSE` only when labels
  deliberately contain LaTeX and other text has been handled appropriately.
- Save tables to `output/<task>/tables/` and figures to `output/<task>/figures/`. Produce
  Markdown companions from the same finalized content using the appropriate format; LaTeX styling need not
  carry over. Formatting examples do not authorize overwriting existing outputs.

## Figures and spatial work

- Use `ggplot2`, clear labels and units, and explicit output dimensions/resolution.
  Use a minimal statistical theme and `theme_void()` for maps only when axes have no
  substantive meaning.
- Use `sf` for vector data and `terra` for rasters. Check or transform coordinate
  reference systems before joins, distances, areas, or extraction, and validate
  geometries when invalid features could affect results.
- Document intentionally excluded geographic units and why they were excluded.

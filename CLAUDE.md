# AI Coding Agent Guidelines (claude.md)

These rules define how an AI coding agent should plan, execute, verify, communicate, and recover when working in a real codebase. Optimize for correctness, minimalism, and developer experience.

---

## Operating Principles (Non-Negotiable)

- **Correctness over cleverness**: Prefer boring, readable solutions that are easy to maintain.
- **Smallest change that works**: Minimize blast radius; don't refactor adjacent code unless it meaningfully reduces risk or complexity.
- **Leverage existing patterns**: Follow established project conventions before introducing new abstractions or dependencies.
- **Prove it works**: "Seems right" is not done. Validate with tests/build/lint and/or a reliable manual repro.
- **Be explicit about uncertainty**: If you cannot verify something, say so and propose the safest next step to verify.

---

## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for any non-trivial task (3+ steps, multi-file change, architectural decision, production-impacting behavior).
- Include verification steps in the plan (not as an afterthought).
- If new information invalidates the plan: **stop**, update the plan, then continue.
- Write a crisp spec first when requirements are ambiguous (inputs/outputs, edge cases, success criteria).

### 2. Subagent Strategy (Parallelize Intelligently)
- Use subagents to keep the main context clean and to parallelize:
  - repo exploration, pattern discovery, test failure triage, dependency research, risk review.
- Give each subagent **one focused objective** and a concrete deliverable:
  - "Find where X is implemented and list files + key functions" beats "look around."
- Merge subagent outputs into a short, actionable synthesis before coding.

### 3. Incremental Delivery (Reduce Risk)
- Prefer **thin vertical slices** over big-bang changes.
- Land work in small, verifiable increments:
  - implement -> test -> verify -> then expand.
- When feasible, keep changes behind:
  - feature flags, config switches, or safe defaults.

### 4. Self-Improvement Loop
- After any user correction or a discovered mistake:
  - add a `[LEARN:category]` entry to `MEMORY.md` capturing:
    - the failure mode, the detection signal, and a prevention rule.
- Review `MEMORY.md` at session start and before major refactors.

### 5. Verification Before "Done"
- Never mark complete without evidence:
  - tests, lint/typecheck, build, logs, or a deterministic manual repro.
- Compare behavior baseline vs changed behavior when relevant.
- Ask: "Would a staff engineer approve this diff and the verification story?"

### 6. Demand Elegance (Balanced)
- For non-trivial changes, pause and ask:
  - "Is there a simpler structure with fewer moving parts?"
- If the fix is hacky, rewrite it the elegant way **if** it does not expand scope materially.
- Do not over-engineer simple fixes; keep momentum and clarity.

### 7. Autonomous Bug Fixing (With Guardrails)
- When given a bug report:
  - reproduce -> isolate root cause -> fix -> add regression coverage -> verify.
- Do not offload debugging work to the user unless truly blocked.
- If blocked, ask for **one** missing detail with a recommended default and explain what changes based on the answer.

---

## Task Management (File-Based, Auditable)

1. **Plan First**
   - Write a checklist to `quality_reports/plans/` for any non-trivial work.
   - Include "Verify" tasks explicitly (lint/tests/build/manual checks).
2. **Define Success**
   - Add acceptance criteria (what must be true when done).
3. **Track Progress**
   - Mark items complete as you go; keep one "in progress" item at a time.
4. **Checkpoint Notes**
   - Capture discoveries, decisions, and constraints as you learn them.
5. **Document Results**
   - Add a short "Results" section: what changed, where, how verified.
6. **Capture Lessons**
   - Update `MEMORY.md` with `[LEARN:category]` entries after corrections or postmortems.

---

## Communication Guidelines (User-Facing)

### 1. Be Concise, High-Signal
- Lead with outcome and impact, not process.
- Reference concrete artifacts:
  - file paths, command names, error messages, and what changed.
- Avoid dumping large logs; summarize and point to where evidence lives.

### 2. Ask Questions Only When Blocked
When you must ask:
- Ask **exactly one** targeted question.
- Provide a recommended default.
- State what would change depending on the answer.

### 3. State Assumptions and Constraints
- If you inferred requirements, list them briefly.
- If you could not run verification, say why and how to verify.

### 4. Show the Verification Story
- Always include:
  - what you ran (tests/lint/build), and the outcome.
- If you didn't run something, give a minimal command list the user can run.

### 5. Avoid "Busywork Updates"
- Don't narrate every step.
- Do provide checkpoints when:
  - scope changes, risks appear, verification fails, or you need a decision.

---

## Context Management Strategies (Don't Drown the Session)

### 1. Read Before Write
- Before editing:
  - locate the authoritative source of truth (existing module/pattern/tests).
- Prefer small, local reads (targeted files) over scanning the whole repo.

### 2. Keep a Working Memory
- Maintain a short running "Working Notes" section in plans:
  - key constraints, invariants, decisions, and discovered pitfalls.
- When context gets large:
  - compress into a brief summary and discard raw noise.

### 3. Minimize Cognitive Load in Code
- Prefer explicit names and direct control flow.
- Avoid clever meta-programming unless the project already uses it.
- Leave code easier to read than you found it.

### 4. Control Scope Creep
- If a change reveals deeper issues:
  - fix only what is necessary for correctness/safety.
  - log follow-ups as TODOs/issues rather than expanding the current task.

---

## Error Handling and Recovery Patterns

### 1. "Stop-the-Line" Rule
If anything unexpected happens (test failures, build errors, behavior regressions):
- stop adding features
- preserve evidence (error output, repro steps)
- return to diagnosis and re-plan

### 2. Triage Checklist (Use in Order)
1. **Reproduce** reliably (test, script, or minimal steps).
2. **Localize** the failure (which layer: UI, API, DB, network, build tooling).
3. **Reduce** to a minimal failing case (smaller input, fewer steps).
4. **Fix** root cause (not symptoms).
5. **Guard** with regression coverage (test or invariant checks).
6. **Verify** end-to-end for the original report.

### 3. Safe Fallbacks (When Under Time Pressure)
- Prefer "safe default + warning" over partial behavior.
- Degrade gracefully:
  - return an error that is actionable, not silent failure.
- Avoid broad refactors as "fixes."

### 4. Rollback Strategy (When Risk Is High)
- Keep changes reversible:
  - feature flag, config gating, or isolated commits.
- If unsure about production impact:
  - ship behind a disabled-by-default flag.

### 5. Instrumentation as a Tool (Not a Crutch)
- Add logging/metrics only when they:
  - materially reduce debugging time, or prevent recurrence.
- Remove temporary debug output once resolved (unless it's genuinely useful long-term).

---

## Engineering Best Practices (AI Agent Edition)

### 1. API / Interface Discipline
- Design boundaries around stable interfaces:
  - functions, modules, components, route handlers.
- Prefer adding optional parameters over duplicating code paths.
- Keep error semantics consistent (throw vs return error vs empty result).

### 2. Testing Strategy
- Add the smallest test that would have caught the bug.
- Prefer:
  - unit tests for pure logic,
  - integration tests for DB/network boundaries,
  - E2E only for critical user flows.
- Avoid brittle tests tied to incidental implementation details.

### 3. Type Safety and Invariants
- Avoid suppressions (`any`, ignores) unless the project explicitly permits and you have no alternative.
- Encode invariants where they belong:
  - validation at boundaries, not scattered checks.

### 4. Dependency Discipline
- Do not add new dependencies unless:
  - the existing stack cannot solve it cleanly, and the benefit is clear.
- Prefer standard library / existing utilities.

### 5. Security and Privacy
- Never introduce secret material into code, logs, or chat output.
- Treat user input as untrusted:
  - validate, sanitize, and constrain.
- Prefer least privilege (especially for DB access and server-side actions).

### 6. Performance (Pragmatic)
- Avoid premature optimization.
- Do fix:
  - obvious N+1 patterns, accidental unbounded loops, repeated heavy computation.
- Measure when in doubt; don't guess.

### 7. Accessibility and UX (When UI Changes)
- Keyboard navigation, focus management, readable contrast, and meaningful empty/error states.
- Prefer clear copy and predictable interactions over fancy effects.

---

## Git and Change Hygiene (If Applicable)

- Keep commits atomic and describable; avoid "misc fixes" bundles.
- Don't rewrite history unless explicitly requested.
- Don't mix formatting-only changes with behavioral changes unless the repo standard requires it.
- Treat generated files carefully:
  - only commit them if the project expects it.

---

## Definition of Done (DoD)

A task is done when:
- Behavior matches acceptance criteria.
- Tests/lint/typecheck/build (as relevant) pass or you have a documented reason they were not run.
- Risky changes have a rollback/flag strategy (when applicable).
- The code follows existing conventions and is readable.
- A short verification story exists: "what changed + how we know it works."

---

## Templates

### Plan Template (Paste into `quality_reports/plans/`)
- [ ] Restate goal + acceptance criteria
- [ ] Locate existing implementation / patterns
- [ ] Design: minimal approach + key decisions
- [ ] Implement smallest safe slice
- [ ] Add/adjust tests
- [ ] Run verification (lint/tests/build/manual repro)
- [ ] Summarize changes + verification story
- [ ] Record lessons (if any)

### Bugfix Template (Use for Reports)
- Repro steps:
- Expected vs actual:
- Root cause:
- Fix:
- Regression coverage:
- Verification performed:
- Risk/rollback notes:

---

# Specific Claude Code Instructions for Academic Economics Research

## CRITICAL: Read Before Acting
Before making ANY suggestion or diagnosis about code errors:
1. Read current state of relevant file(s) using the Read tool
2. Do NOT assume code is same as what you last saw
3. Do NOT suggest solutions already in the code
4. If user reports an error, read surrounding code context FIRST

## Project Structure Standard
```
project-name/
├── data/
│   ├── raw/          # Original, immutable data
│   ├── build/        # Intermediate data products
│   └── temp/         # Temporary working files
├── code/
│   ├── build/        # Data cleaning and construction
│   └── analysis/     # Estimation and analysis scripts
├── output/
│   ├── figures/      # Publication-ready figures
│   ├── tables/       # Publication-ready tables
│   ├── paper/        # LaTeX/Quarto paper files
│   └── slides/       # Beamer presentation files
├── quality_reports/  # Plans, session logs, specs, merge reports
├── explorations/     # Research sandbox (relaxed quality gates)
├── templates/        # Session log, quality report, skill templates
├── _extensions/      # Quarto extensions (aea template)
├── .here             # Project root marker
├── .claude/          # Rules, skills, agents, hooks
├── Dockerfile        # Docker-based replication (Nix bootstrapped inside)
├── Makefile          # Build automation
└── generate_env.R    # rix/nix environment setup
```

## Package Environment (rix / Nix)

### Non-Negotiable Rules
- **Never install packages globally** (no `install.packages()`, `pip install`, etc. outside of Nix).
- **Always enter `nix-shell`** before running any R, Python, or Julia code in this project.
- All package dependencies must be declared in `generate_env.R` using the `rix` R package so that the environment is fully reproducible via Nix.
- **Never run Docker commands** (`docker build`, `docker run`, etc.). The Dockerfile is scaffolded for the user's later use (replication packages, journal submission). Day-to-day work uses `nix-shell` only.

### Environment Setup with `rix`
Every project must have a `generate_env.R` at the root that defines the Nix environment. Example:
```r
library(rix)

rix(
  r_ver   = "latest",
  r_pkgs  = c("data.table", "fixest", "ggplot2", "modelsummary",
               "kableExtra", "here", "sf"),
  system_pkgs = c("quarto"),       # non-R system dependencies
  ide         = "other",           # "other" for CLI / Claude Code usage
  project_path = ".",
  overwrite    = TRUE
)
```
- Run `Rscript generate_env.R` once (from a system R that has `rix` installed) to produce `default.nix`.
- After that, all work happens inside `nix-shell` (or `nix-shell --pure` for strict isolation).

### Workflow for the AI Agent
1. **Before writing or running any code**, execute `nix-shell` in the project root to enter the reproducible environment.
2. **Adding a new package**: edit `generate_env.R` to include the package, re-run `Rscript generate_env.R`, then re-enter `nix-shell`. Never use `install.packages()` or equivalent.
3. **Verification**: confirm the environment works by running `R -e "library(<pkg>)"` inside `nix-shell` for any newly added package.
4. **Commit `generate_env.R` and `default.nix`** to version control so collaborators and replication reviewers can reproduce the environment exactly.

### Docker-Based Replication (Scaffolding Only -- Do Not Run)
The Dockerfile below is included in every project for the user to run later when preparing replication packages or journal submissions. **The AI agent must never execute `docker build`, `docker run`, or any Docker commands.** It only needs to keep the Dockerfile in sync when project structure changes (e.g., updating `generate_env.R`). Every project should include a `Dockerfile` at the root:
```dockerfile
FROM ubuntu:latest

RUN apt update -y

RUN apt install curl -y

# Bootstrap rix by downloading the default.nix that ships with {rix}
RUN curl -O https://raw.githubusercontent.com/ropensci/rix/main/inst/extdata/default.nix

# Copy the rix environment definition
COPY generate_env.R .

# Copy all project files into the image
COPY . .

# Install Nix via the Determinate Systems installer
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --init none \
  --no-confirm

# Add Nix to PATH
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
ENV user=root

# Configure rstats-on-nix binary cache (avoids compiling from source)
RUN mkdir -p /root/.config/nix && \
    echo "substituters = https://cache.nixos.org https://rstats-on-nix.cachix.org" > /root/.config/nix/nix.conf && \
    echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= rstats-on-nix.cachix.org-1:vdiiVgocg6WeJrODIqdprZRUrhi1JzhBnXv7aWI6+F0=" >> /root/.config/nix/nix.conf

# Generate the Nix expression from generate_env.R, then build the environment
RUN nix-shell --run "Rscript generate_env.R"
RUN nix-build

# Create shared folder for output
RUN mkdir -p shared_folder

# Run the full pipeline via Makefile inside the Nix environment
RUN nix-shell --run "make all"

# Move results to shared folder on container start
CMD ["sh", "-c", "mv output/* shared_folder/"]
```

**Building and running the replication container:**
```bash
# Build the image
docker build -t project-replication .

# Run and extract results to a local folder
docker run -v $(pwd)/results:/shared_folder project-replication
```

**Key points:**
- The Dockerfile bootstraps Nix without requiring Nix on the host machine -- only Docker is needed.
- The `rstats-on-nix.cachix.org` binary cache is configured so precompiled packages are downloaded rather than compiled from source.
- `nix-shell --run "make all"` executes the entire pipeline inside the pinned environment.
- Output is copied to `shared_folder/` which can be volume-mounted to the host.

### Why This Matters
- `install.packages()` is non-reproducible: versions drift, CRAN snapshots change, system libraries differ across machines.
- Nix pins every dependency (R version, package versions, system libraries) to a specific nixpkgs revision, guaranteeing identical builds on any machine.
- Docker + Nix provides a two-layer guarantee: Docker ensures the OS layer is reproducible, Nix ensures the R/package layer is reproducible.
- This is required for DCAS-compliant replication packages and journal submissions.

---

## Language-Specific Style

### R
- Use `data.table` syntax (`:=`, `.N`, `.SD`, `by=`)
- Use `fixest` for regressions (feols, fepois, etc.)
- Use `modelsummary`, `kableExtra`, or `etable` for tables
- Use `ggplot2` with minimal themes for figures
- Use `here::here()` for paths (requires `.here` file in project root)
- Align assignment operators for legibility:
```r
main_dt      <- fread(here("data", "raw", "main.csv"))  # Main survey data
controls_dt  <- fread(here("data", "raw", "ctrl.csv"))  # Regional controls
```

### Julia
- Use `DataFrames.jl` with broadcasting and efficient operations
- Use `FixedEffectModels.jl` for panel regressions
- Use `Optim.jl` for structural estimation
- Use `Distributions.jl` for probability distributions
- Optimize computation: prefer matrix operations, avoid unnecessary allocations
- Use `@views` for slicing, preallocate arrays when possible
```julia
# Good: preallocated, in-place operations
result = zeros(n, m)
@views result[:, 1] .= data[:, j] .* weights

# Avoid: creates intermediate arrays
result = data[:, j] .* weights  # Allocates new array
```

### Python (Jupyter Notebooks)
- Start with markdown block: filename, author, email, date, description, inputs/outputs
- All markdown headings <= `####`
- First code block: imports + directory setup
- Base directory: `os.path.join(os.path.expanduser("~"), "Dropbox/Projects")`
- Use `os.path.join` for all paths
- For matplotlib figures, use publication-quality settings:
```python
from matplotlib.ticker import FuncFormatter
import matplotlib as mpl
import matplotlib.pyplot as plt
from cycler import cycler

mpl.use("pgf")
mpl.rcParams.update({
    "pgf.texsystem": "pdflatex",
    "pgf.rcfonts": False,
    "font.family": "serif",
    "font.serif": ["Times"],
    "font.size": 12,
    "axes.labelsize": 14,
    "axes.titlesize": 15,
    "xtick.labelsize": 12,
    "ytick.labelsize": 12,
    "legend.fontsize": 12,
    "axes.facecolor": "white",
    "figure.facecolor": "white",
    "axes.edgecolor": "#404040",
    "axes.prop_cycle": cycler(color=["#4A4A4A"]),
    "pgf.preamble": r"\usepackage[T1]{fontenc}\usepackage{mathptmx}",
})
```

## Editing Rules
- Do NOT overwrite existing work unless explicitly asked
- Add new code as separate blocks, preserving original
- When adding regressions, keep existing ones intact
- Each data input: add brief comment describing it

## Tables Output
- Default: `modelsummary` (R) or `kableExtra` (R) with appropriate output format
- For LaTeX: use `output = "latex"` or `etable` from `fixest`
- For Word/HTML: use `kableExtra` formatting
- Make sure you remove `\begin{table}` `\end{Table}` so that you can import the tex file into the table setting in LaTeX
- Include standard errors, significance stars, observation counts

## Figures Output
- Save as `.png`
- Use consistent color palette across project
- Minimal themes: `theme_bw()` or custom clean theme
- Label axes clearly, include units

## Git Practices
- `.gitignore` file: Add `data`, `output` folders and also add `result` folder.

## Replication Package Checklist
When preparing for replication:
1. Use `rix` for R environment management (Nix-based)
2. Include `generate_env.R` with package specifications
3. Include `Dockerfile` for containerized replication (Nix bootstrapped inside Docker)
4. Create `Makefile` with full pipeline
5. Document all data sources in README
6. Local verification: `nix-build` then `nix-shell` should reproduce environment
7. Docker verification: `docker build -t replication .` then `docker run -v $(pwd)/results:/shared_folder replication` should reproduce all outputs

## Quarto Papers
- Use `hchulkim/econ-paper-template` for AEA-style formatting
- Render command: `quarto render paper.qmd --to aea-pdf`
- Keep `bibliography.bib` updated
- Use cross-references: `@fig-name`, `@tbl-name`, `@eq-name`

---

# Workflow System (clo-author)

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** -- compile and confirm output at the end of every task
- **Single source of truth** -- Paper `output/paper/main.tex` is authoritative; talks and supplements derive from it
- **Quality gates** -- weighted aggregate score; nothing ships below 80/100; see `scoring-protocol.md`
- **Worker-critic pairs** -- every creator has a paired critic; critics never edit files
- **[LEARN] tags** -- when corrected, save `[LEARN:category] wrong -> right` to MEMORY.md

## Quality Thresholds

| Score | Gate | Applies To |
|-------|------|------------|
| 80 | Commit | Weighted aggregate (blocking) |
| 90 | PR | Weighted aggregate (blocking) |
| 95 | Submission | Aggregate + all components >= 80 |
| -- | Advisory | Talks (reported, non-blocking) |

See `.claude/rules/scoring-protocol.md` for weighted aggregation formula.

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| `/new-project [topic]` | Full pipeline: idea -> paper (orchestrated) |
| `/interview-me [topic]` | Interactive research interview -> spec + domain profile |
| `/lit-review [topic]` | Librarian + Editor: literature search + synthesis |
| `/research-ideation [topic]` | Research questions + strategies |
| `/find-data [question]` | Explorer + Surveyor: data discovery + assessment |
| `/identify [question]` | Strategist + Econometrician: design identification strategy |
| `/pre-analysis-plan [spec]` | Strategist: draft PAP (AEA/OSF/EGAP) |
| `/data-analysis [dataset]` | Coder + Debugger: end-to-end analysis |
| `/draft-paper [section]` | Writer: draft paper sections + humanizer pass |
| `/compile-latex [file]` | 3-pass XeLaTeX + bibtex |
| `/econometrics-check [file]` | Econometrician: 4-phase causal inference audit |
| `/econometrics-r [spec]` | R econometrics (data.table + fixest) |
| `/econometrics-julia [spec]` | Julia econometrics (FixedEffectModels.jl + Optim.jl) |
| `/review-r [file]` | Debugger: code quality review (standalone) |
| `/proofread [file]` | Proofreader: 6-category manuscript review |
| `/paper-excellence [file]` | Multi-agent parallel review + weighted score |
| `/review-paper [file]` | 2 Referees + Editor: simulated peer review |
| `/validate-bib` | Cross-reference citations |
| `/respond-to-referee [report]` | Revision routing per revision-protocol |
| `/target-journal [paper]` | Editor: journal targeting + submission strategy |
| `/submit [journal]` | Final gate: score >= 95, all components >= 80 |
| `/create-talk [format]` | Storyteller + Discussant: Beamer talk from paper |
| `/visual-audit [file]` | Slide layout audit |
| `/audit-replication [dir]` | Verifier: 10-check submission audit |
| `/data-deposit` | Coder + Verifier: AEA replication package |
| `/replication-package` | Full replication package builder |
| `/project-init` | Initialize new project structure |
| `/quarto-papers` | Quarto/AEA paper rendering |
| `/academic-paper-writer` | Academic paper composition |
| `/api-data-fetcher` | API data retrieval and processing |
| `/latex-econ-model` | LaTeX economic model formatting |
| `/general-equilibrium-model-builder` | GE model specification |
| `/code-simplifier` | Code refactoring and simplification |
| `/humanizer [file]` | Strip 24 AI writing patterns |
| `/journal` | Research journal timeline |
| `/context-status` | Session health + context usage |
| `/learn` | Extract session discoveries into skills |
| `/deploy` | Quarto render + GitHub Pages sync |

## Beamer Custom Environments (Talks)

<!-- CUSTOMIZE: Replace the example entries below with your own Beamer environments for talks. -->

| Environment       | Effect        | Use Case       |
|-------------------|---------------|----------------|
| `[your-env]`      | [Description] | [When to use]  |

## Current Project State

| Component | File | Status | Description |
|-----------|------|--------|-------------|
| Paper | `output/paper/main.tex` | [draft/submitted/R&R] | [Brief description] |
| Data | `code/` | [complete/in-progress] | [Analysis description] |
| Replication | — | [not started/ready] | [Deposit status] |
| Talks | `output/slides/` | -- | [Status] |

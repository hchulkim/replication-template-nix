# Detailed Workflow Guide for Using AI Coding Agents

This document explains how to use AI coding agents with this replication template. The current repo-level Codex setup lives in `AGENTS.md` and `.agents/skills/`. The older `.claude/` setup is still present as legacy reference material.

---

## 1. Initial Project Setup

### Step 1: Clone the template

```bash
# Use this repo as a GitHub template, then clone your new repo
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

### Step 2: Set up Dropbox folders

Create your data and output folders on Dropbox:

```bash
mkdir -p ~/Dropbox/Projects/YOUR_PROJECT/data/raw
mkdir -p ~/Dropbox/Projects/YOUR_PROJECT/data/build
mkdir -p ~/Dropbox/Projects/YOUR_PROJECT/data/temp
mkdir -p ~/Dropbox/Projects/YOUR_PROJECT/output/paper
mkdir -p ~/Dropbox/Projects/YOUR_PROJECT/output/slides
```

### Step 3: Create symlinks

```bash
cd YOUR_PROJECT
ln -s ~/Dropbox/Projects/YOUR_PROJECT/data data
ln -s ~/Dropbox/Projects/YOUR_PROJECT/output output
```

### Step 4: Set up the nix environment

Edit `generate_env.R` to include the R packages you need, then:

```bash
Rscript generate_env.R   # generates default.nix
nix-build                 # builds the environment (first time takes a while)
nix-shell                 # enter the environment
```

### Step 5: Customize the AI setup

For Codex:
- Update `AGENTS.md` if your project needs repo-specific workflow rules
- Keep `.agents/skills/` focused on reusable tasks only

For the legacy Claude setup:
- Customize `CLAUDE.md` only if you still plan to use it

---

## 2. Daily Workflow

### Starting a session

1. Open your terminal in the project directory
2. Start your agent from the project root
3. For Codex, the main local instructions come from `AGENTS.md` and `.agents/skills/`
4. For Claude, the legacy instructions come from `CLAUDE.md` and `.claude/`

### The issue-driven workflow

This template maps GitHub issues to folder structure:

```
1. Create a GitHub issue (e.g., #03 "Build exposure variable")
2. Tell the agent: "Work on issue #03 — build the exposure variable"
3. The agent creates:
   - code/build/03_exposure_variable/01_construct.R
   - Saves output to data/build/03_exposure_variable/
4. When done, close the issue
```

For analysis issues:

```
1. Create a GitHub issue (e.g., #05 "Main regression results")
2. Tell the agent: "Work on issue #05 — run main regressions"
3. The agent creates:
   - code/analysis/05_main_regression/01_baseline.R
   - Saves tables to output/05_main_regression/tables/
   - Saves figures to output/05_main_regression/figures/
4. When done, close the issue
```

### Running code

Prefer running project-dependent code inside `nix-shell` for R work and `uv run` for Python work:

```bash
nix-shell --run "Rscript code/analysis/01_example/lorem.R"
uv run python path/to/script.py
```

### Adding packages

Never use `install.packages()`. Instead:

1. Tell the agent: "I need the sf package"
2. The agent edits `generate_env.R` to add `"sf"` to `r_pkgs`
3. The agent runs `Rscript generate_env.R` then `nix-build`
4. Re-enter `nix-shell`

For Python packages:

1. Tell the agent which Python package is needed
2. Update the Python dependency manifest used by the repo
3. Run Python commands with `uv run ...`
4. Avoid ad hoc global `pip install`

---

## 3. Using the Research Skills

For Codex, the local skills live in `.agents/skills/` and are designed to stay short, with longer rubrics in `references/`.

For the full legacy-to-current inventory, see `CLAUDE_TO_CODEX_SKILL_MAP.md`.

The current Codex local skill set includes:

- `api-data-fetcher`
- `compile-latex`
- `context-status`
- `data-deposit`
- `deploy`
- `econometrics-julia`
- `econometrics-r`
- `find-data`
- `general-equilibrium-model-builder`
- `replication-project-init`
- `identification-strategy`
- `interview-me`
- `journal`
- `latex-econ-model`
- `learn`
- `literature-review`
- `replication-analysis`
- `paper-drafting`
- `quarto-papers`
- `research-code-review`
- `research-ideation`
- `review-paper`
- `respond-to-referee`
- `replication-audit`
- `submit`
- `talk-from-paper`
- `target-journal`
- `validate-bib`
- `visual-audit`

### Quick reference

| What you want | Command |
|---|---|
| Set up the project from the template | `$replication-project-init` |
| Elicit and sharpen a project idea | `$interview-me` |
| Generate research directions | `$research-ideation` |
| Search for related papers | `$literature-review` |
| Find and compare datasets | `$find-data` |
| Design identification strategy | `$identification-strategy` |
| Run build or analysis work | `$replication-analysis` |
| Write or review R econometrics code | `$econometrics-r` |
| Write or review Julia econometrics code | `$econometrics-julia` |
| Review research code | `$research-code-review` |
| Draft a paper section | `$paper-drafting` |
| Work on a Quarto paper | `$quarto-papers` |
| Compile LaTeX and inspect warnings | `$compile-latex` |
| Typeset economic model notation | `$latex-econ-model` |
| Get a referee-style paper review | `$review-paper` |
| Draft responses to referee reports | `$respond-to-referee` |
| Audit replication readiness | `$replication-audit` |
| Prepare materials for deposit | `$data-deposit` |
| Run final submission checks | `$submit` |
| Create a talk plan from the paper | `$talk-from-paper` |
| Recommend journals for submission | `$target-journal` |
| Validate citations and bibliography keys | `$validate-bib` |
| Audit rendered visuals | `$visual-audit` |
| Fetch data from APIs | `$api-data-fetcher` |
| Structure GE model work | `$general-equilibrium-model-builder` |
| Update the research journal | `$journal` |
| Capture reusable lessons | `$learn` |
| Summarize durable session state | `$context-status` |
| Prepare deploy steps | `$deploy` |

### A practical pipeline

```
$interview-me                # Clarify the project idea
    |
$research-ideation          # Generate and filter directions
    |
$literature-review           # Survey the literature and define the gap
    |
$find-data                   # Identify datasets that can support the question
    |
$identification-strategy     # Lock the empirical design
    |
$replication-analysis        # Build data and run analysis
    |
$paper-drafting              # Draft the manuscript
    |
$compile-latex               # Compile the manuscript cleanly
    |
$review-paper                # Simulate referee review
    |
$respond-to-referee          # Draft the response letter after reports arrive
    |
$target-journal              # Pick the right venue and submission order
    |
$validate-bib                # Clean citations before final submission
    |
$data-deposit                # Prepare deposit-facing materials
    |
$replication-audit           # Check reproducibility and submission readiness
    |
$submit                      # Run the final pre-submission gate
    |
$talk-from-paper             # Turn the paper into a talk
```

You can enter at any stage. Most users start with standalone skills.

---

## 4. How the Agent Plans and Executes

### Plan-first workflow

For non-trivial tasks (3+ steps), the agent should:

1. **Plan** — write down the execution and verification path
2. **Execute** — implement the smallest credible slice
3. **Verify** — run code, compile, or otherwise check the result
4. **Report** — summarize what changed and how it was verified

### Quality gates

| Score | Meaning |
|---|---|
| >= 95 | Ready for journal submission |
| >= 90 | Ready for PR / sharing with coauthors |
| >= 80 | Ready to commit |
| < 80 | Blocked — must fix issues first |

### Worker-critic patterns

The old Claude setup used creator/critic pairs. The same idea still helps in Codex:

| Creator | Critic |
|---|---|
| Coder (writes scripts) | Debugger (reviews code) |
| Writer (drafts paper) | Proofreader (reviews manuscript) |
| Strategist (designs identification) | Econometrician (validates strategy) |
| Author draft | Referee review |

Critics score but never edit. Creators produce but never self-score.

---

## 5. Session Management

### Context and memory

- **MEMORY.md** — persistent learnings across sessions (loaded automatically)
- **Session logs** — saved to `quality_reports/session_logs/`
- **Plans** — saved to `quality_reports/plans/`

When a long session grows large, important state should be preserved through:
- Files on disk (plans, logs, MEMORY.md)
- Pre-compact hooks that save current state
- Post-compact hooks that restore context

### Useful skill entry points

| Command | What it does |
|---|---|
| `$literature-review` | Build a literature memo |
| `$find-data` | Compare candidate datasets |
| `$identification-strategy` | Write or audit the design |
| `$replication-analysis` | Implement analysis scripts |
| `$compile-latex` | Compile paper or slides |
| `$review-paper` | Act like a referee on a draft |
| `$respond-to-referee` | Draft the response letter |
| `$target-journal` | Recommend submission venues |
| `$validate-bib` | Cross-check citation keys |
| `$replication-audit` | Audit replication readiness |

---

## 6. Git Workflow

### Branch per issue

```bash
git checkout -b issue/03-exposure-variable
# ... work on the issue ...
git add code/build/03_exposure_variable/
git commit -m "Build exposure variable (#3)"
git push origin issue/03-exposure-variable
# Create PR on GitHub
```

### What gets committed

- `code/` — all scripts (numbered by issue)
- `generate_env.R` — environment definition
- `Makefile` — build pipeline
- `quality_reports/` — plans, session logs
- `.agents/` — Codex skill configuration
- `.claude/` — legacy agent configuration

### What does NOT get committed

- `data/` — on Dropbox (symlinked)
- `output/` — on Dropbox (symlinked)
- `default.nix` — generated from `generate_env.R`
- `result/` — nix build output

---

## 7. Preparing for Replication

When you're ready to submit to a journal:

### Step 1: Audit

```
$replication-audit
```

This checks: scripts run, outputs match, README complete, data documented.

### Step 2: Referee the manuscript

```
$review-paper
```

This acts like a referee service: it reads the paper, scores contribution and identification and evidence and writing, and produces major and minor comments before submission.

### Step 3: Clean citations and target a venue

```
$validate-bib
$target-journal
```

### Step 4: Prepare deposit and final submission

```
$data-deposit
$submit
```

### Step 5: Test with Docker

```bash
docker build -t replication .
docker run -v $(pwd)/results:/shared_folder replication
```

### Step 4: Submit

```
/submit [journal]
```

Final quality gate: overall score >= 95, all components >= 80.

---

## 8. Exploration Mode

For experimental work that may not lead anywhere:

1. Work in `explorations/` folder
2. Lower quality threshold (60/100 vs 80/100 for production)
3. No plan needed — just code and document
4. If it works, "graduate" to production code
5. If it doesn't, archive with a note

```bash
mkdir -p explorations/test_iv_approach/{R,output}
# Work here freely, then decide: graduate or archive
```

---

## 9. Tips

- **Be specific in requests**: "Run the main regression with state fixed effects and cluster at county level" is better than "run the analysis"
- **Use issues**: Create GitHub issues for every task, then reference them when asking Claude to work
- **Review plans**: Always review Claude's plan before approving — it's your chance to catch misunderstandings
- **Check MEMORY.md**: Claude learns from corrections. If it keeps making the same mistake, add a `[LEARN]` entry
- **Don't fight the structure**: The numbered folder convention pays off when you have 10+ issues and need to trace results back to code

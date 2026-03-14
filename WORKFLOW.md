# Detailed Workflow Guide for Using Claude Code

This document explains the step-by-step workflow for using Claude Code with this replication template. It covers project setup, daily usage, and the full research pipeline.

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

### Step 5: Customize CLAUDE.md

Fill in the template sections:
- Domain profile (your field, target journals)
- Current project state
- Beamer custom environments (if any)

---

## 2. Daily Workflow

### Starting a session

1. Open your terminal in the project directory
2. Run `claude` to start Claude Code
3. Claude reads `CLAUDE.md` and `MEMORY.md` automatically

### The issue-driven workflow

This template maps GitHub issues to folder structure:

```
1. Create a GitHub issue (e.g., #03 "Build exposure variable")
2. Tell Claude: "Work on issue #03 — build the exposure variable"
3. Claude creates:
   - code/build/03_exposure_variable/01_construct.R
   - Saves output to data/build/03_exposure_variable/
4. When done, close the issue
```

For analysis issues:

```
1. Create a GitHub issue (e.g., #05 "Main regression results")
2. Tell Claude: "Work on issue #05 — run main regressions"
3. Claude creates:
   - code/analysis/05_main_regression/01_baseline.R
   - Saves tables to output/05_main_regression/tables/
   - Saves figures to output/05_main_regression/figures/
4. When done, close the issue
```

### Running code

Claude always runs code inside `nix-shell`:

```bash
nix-shell --run "Rscript code/analysis/01_example/lorem.R"
```

### Adding packages

Never use `install.packages()`. Instead:

1. Tell Claude: "I need the sf package"
2. Claude edits `generate_env.R` to add `"sf"` to `r_pkgs`
3. Claude runs `Rscript generate_env.R` then `nix-build`
4. Re-enter `nix-shell`

---

## 3. Using Claude's Research Skills

### Quick reference

| What you want | Command |
|---|---|
| Start a new project from scratch | `/new-project [topic]` |
| Search for related papers | `/lit-review [topic]` |
| Find datasets | `/find-data [research question]` |
| Design identification strategy | `/identify [research question]` |
| Run data analysis | `/data-analysis [dataset]` |
| Draft a paper section | `/draft-paper [section]` |
| Review code quality | `/review-r [file]` |
| Check econometric validity | `/econometrics-check [file]` |
| Proofread a manuscript | `/proofread [file]` |
| Get simulated peer review | `/review-paper [file]` |
| Create presentation slides | `/create-talk [format]` |
| Build replication package | `/replication-package` |

### The full pipeline (if using orchestration)

```
/interview-me [topic]        # Discover your research question
    |
/lit-review [topic]          # What's been done?
    |
/find-data [question]        # What data exists?
    |
/identify [question]         # How to identify the causal effect?
    |
/data-analysis [dataset]     # Write the code
    |
/draft-paper [section]       # Write the paper
    |
/review-paper [file]         # Simulate peer review
    |
/submit [journal]            # Final quality gate
```

You can enter at any stage. Most users start with standalone skills.

---

## 4. How Claude Plans and Executes

### Plan-first workflow

For non-trivial tasks (3+ steps), Claude enters plan mode:

1. **Plan** — Claude drafts a plan and saves it to `quality_reports/plans/`
2. **Approve** — You review and approve (or modify) the plan
3. **Execute** — Claude implements step by step
4. **Verify** — Claude runs the code and checks output
5. **Report** — Claude summarizes what changed and how it was verified

### Quality gates

| Score | Meaning |
|---|---|
| >= 95 | Ready for journal submission |
| >= 90 | Ready for PR / sharing with coauthors |
| >= 80 | Ready to commit |
| < 80 | Blocked — must fix issues first |

### Worker-critic pairs

Every creator agent has a paired critic:

| Creator | Critic |
|---|---|
| Coder (writes scripts) | Debugger (reviews code) |
| Writer (drafts paper) | Proofreader (reviews manuscript) |
| Strategist (designs identification) | Econometrician (validates strategy) |
| Librarian (collects literature) | Editor (reviews coverage) |

Critics score but never edit. Creators produce but never self-score.

---

## 5. Session Management

### Context and memory

- **MEMORY.md** — persistent learnings across sessions (loaded automatically)
- **Session logs** — saved to `quality_reports/session_logs/`
- **Plans** — saved to `quality_reports/plans/`

When Claude's context gets full, it auto-compacts (summarizes prior conversation). Important state is preserved through:
- Files on disk (plans, logs, MEMORY.md)
- Pre-compact hooks that save current state
- Post-compact hooks that restore context

### Useful commands during a session

| Command | What it does |
|---|---|
| `/context-status` | Check how much context is used |
| `/journal` | View the research journal timeline |
| `/learn` | Save a discovery as a reusable skill |

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
- `.claude/` — agent configuration

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
/audit-replication
```

This checks: scripts run, outputs match, README complete, data documented.

### Step 2: Build the replication package

```
/replication-package
```

This creates a self-contained package with Makefile, Dockerfile, and documentation.

### Step 3: Test with Docker

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

# Task Template

## How to Use

1. **Copy** this template to a new file: `tasks/YYYY-MM-DD_description.md`
2. **Fill in** each section — delete placeholder text, leave sections blank if truly N/A
3. **Feed to Claude** with: "Read `tasks/YYYY-MM-DD_description.md` and execute the task"
4. **Mark done** by checking off acceptance criteria and adding a completion date

### Tips for getting consistent results

- **Be specific in Objective** — "Create a summary statistics table for the CPS sample" beats "make a table"
- **Always fill Out of Scope** — this is the single most effective section for preventing Claude from over-engineering or touching unrelated code
- **Provide exact file paths** in Inputs and Expected Outputs — Claude will read these files before acting instead of guessing
- **Include a runnable Verification command** — Claude will use it to prove the task is done, not just claim it
- **Constraints are guardrails** — use "Do NOT" bullets to block known failure modes (e.g., "Do NOT use install.packages()", "Do NOT refactor the existing regression code")

### Naming convention

```
tasks/
├── TEMPLATE.md                        # This file (don't edit, copy it)
├── 2026-03-18_summary-stats-table.md  # Completed task
├── 2026-03-19_iv-regression.md        # Completed task
└── 2026-03-20_robustness-checks.md    # In progress
```

### Lifecycle

```
DRAFT  →  Claude reads + executes  →  Acceptance criteria checked  →  DONE
```

Tasks stay in the folder as a record of what was done and why. Delete only if they add noise.

---

# Task: [Short descriptive title]

## Objective
[One sentence: what should be true when this task is done?]

## Context
[Why this task exists. Link to the issue, prior conversation, or decision that motivated it. Include enough background that Claude can act without asking clarifying questions.]

## Scope

### In scope
- [Specific thing to do]
- [Another specific thing]

### Out of scope
- [Thing that might seem related but should NOT be touched]

## Inputs
[What already exists that Claude should read/use before starting.]

| Input | Path / Location | Notes |
|-------|----------------|-------|
| [Data file, script, doc] | `path/to/file` | [Brief description] |

## Expected Outputs
[What Claude should produce. Be specific about file paths, formats, and naming.]

| Output | Path | Format |
|--------|------|--------|
| [Script, table, figure, etc.] | `path/to/output` | [.R, .tex, .png, etc.] |

## Constraints
- [Technical constraints: packages to use, patterns to follow, coding style]
- [Data constraints: sample restrictions, variable definitions]
- [Do NOT: explicit anti-patterns or things to avoid]

## Acceptance Criteria
- [ ] [Observable, verifiable condition that must be true]
- [ ] [Another condition]
- [ ] Code runs without errors inside `nix-shell`
- [ ] Output files exist at specified paths

## Verification
[How to confirm the task is done correctly. Provide a command, a test, or a check.]

```bash
# Example: run the script and check output
nix-shell --run "Rscript code/analysis/01_main/run.R"
ls -la output/01_main/tables/
```

## Priority
[HIGH / MEDIUM / LOW] — [One line justification if not obvious]

## Notes
[Anything else: edge cases, known pitfalls, references, related tasks.]

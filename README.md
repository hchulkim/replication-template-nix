# Replication template with nix (rix)

# Overall summary and high-level instructions

This is a README for the replication template made by [Hyoungchul Kim](hchulkim.github.io). This README summarizes and describes how to use this template for reproducible research workflow. For a more detailed instructions on how to use this template (and benefits of using it), consult to my [blog post](https://hchulkim.github.io/posts/reproducible-template/).

If you intend to use my template, make sure you erase all the contents in the README and replace it with your own README. This README is just recommendations for certain research workflow you could follow. Normally, you would write something like [social science replication README template](https://social-science-data-editors.github.io/template_README/). For convenience, I also put my example README template in [Example template](#example-readme-template). They are based on [DCAS](https://datacodestandard.org/) and [AEA DCAS](https://www.aeaweb.org/journals/data/data-code-policy).

# Information on overall replication workflow

## 0. Workflow

When starting research, you should consider logistics between 2 or 3 components:

- GitHub repository (code)
- Dropbox folder (data + output)
- (optional) Overleaf

### GitHub repository (code only)

This is your main repository. **Only code lives here** — no data, no output. This keeps the repo lightweight and avoids accidentally committing large files.

What goes in GitHub:
- `code/build/` — data cleaning and construction scripts
- `code/analysis/` — estimation and analysis scripts
- `generate_env.R` — rix/nix environment definition
- `Makefile` — build automation
- `Dockerfile` — containerized replication

### Dropbox folder (data + output)

Data and output live on Dropbox because datasets are often too large for GitHub. You access them in your local project via **symlinks**.

What goes on Dropbox:
- `data/raw/` — original, immutable data
- `data/build/` — intermediate data products (numbered by issue)
- `data/temp/` — temporary working files
- `output/` — tables, figures, paper, slides (see structure below)

### (optional) Overleaf

Sometimes useful for collaborating on papers. Requires a premium subscription for Dropbox syncing.

### Setting up symlinks

After cloning the repo, create symlinks to your Dropbox folders:

```bash
# Link Dropbox data and output into the project
ln -s ~/Dropbox/Projects/PROJECT_NAME/data data
ln -s ~/Dropbox/Projects/PROJECT_NAME/output output
```

This lets your code reference `data/` and `output/` as if they were local folders, while the actual files live on Dropbox.

## 1. Project structure

### What's in GitHub

```
project-name/
├── code/
│   ├── build/                    # Data cleaning and construction
│   │   ├── 01_issue_name/        # Numbered by GitHub issue
│   │   │   ├── 01_clean_raw.R
│   │   │   └── 02_merge.R
│   │   └── 02_issue_name/
│   │       └── 01_construct.R
│   └── analysis/                 # Estimation and analysis
│       ├── 01_issue_name/
│       │   ├── 01_baseline.R
│       │   └── 02_robustness.R
│       └── 02_issue_name/
│           └── 01_hetero.R
├── .agents/skills/               # Local Codex skills for research workflows
├── .claude/                      # Legacy Claude Code configuration kept as reference
├── .github/workflows/            # GitHub Actions
├── AGENTS.md                     # Repo-level Codex workflow instructions
├── generate_env.R                # rix/nix environment definition
├── generate_env_python.R         # Alternative: R + Python environment
├── Dockerfile                    # Containerized replication
├── Makefile                      # Build automation
├── requirements.txt              # Python packages (if using uv)
├── .here                         # Project root marker
├── .gitignore
└── README.md
```

### What's on Dropbox (symlinked into project)

```
data/
├── raw/                          # Original, immutable data
├── build/                        # Intermediate data products
│   ├── 01_issue_name/            # Matches code/build/ numbering
│   └── 02_issue_name/
└── temp/                         # Temporary working files

output/
├── 01_issue_name/                # Matches code/analysis/ numbering
│   ├── tables/                   # Tables for this analysis
│   └── figures/                  # Figures for this analysis
├── 02_issue_name/
│   ├── tables/
│   └── figures/
├── paper/                        # LaTeX/Quarto paper (not numbered)
└── slides/                       # Beamer presentations (not numbered)
```

### Numbering convention

The numbered folders (e.g., `01_`, `02_`) correspond to **GitHub issues**. This creates a clear mapping:

| GitHub Issue | Code | Data | Output |
|---|---|---|---|
| #01 Data cleaning | `code/build/01_data_cleaning/` | `data/build/01_data_cleaning/` | — |
| #02 Main regression | `code/analysis/02_main_reg/` | — | `output/02_main_reg/tables/`, `output/02_main_reg/figures/` |

This makes it easy to trace any result back to the issue that produced it.

## 1.1 AI coding workflow

This template now includes a Codex-oriented LLM setup in addition to the older Claude configuration.

### Where the AI instructions live

- `AGENTS.md` — repo-level instructions for Codex
- `.agents/skills/` — small reusable Codex skills for common research tasks
- `.claude/` — older Claude-specific setup, kept mainly as reference material
- `CLAUDE_TO_CODEX_SKILL_MAP.md` — inventory of every legacy Claude skill and its current Codex status

### What the Codex setup can do

- Bootstrap a new project from this template
- Survey literature and draft contribution memos
- Identify and compare candidate datasets
- Design or audit identification strategies
- Implement build and analysis scripts in the numbered issue workflow
- Review research code for reproducibility and output hygiene
- Draft or revise paper sections from existing results
- Simulate referee-style paper reviews before submission
- Draft point-by-point referee responses
- Recommend target journals and submission strategy
- Check citations against bibliography entries
- Audit the replication package before sharing or submission
- Turn a paper into a seminar or conference talk outline

### Design principle for the AI setup

The Codex skills are intentionally short at the top level. Each `SKILL.md` gives the trigger and the workflow, while longer rubrics and templates live in `references/`. This keeps the agent instructions readable and avoids bloated prompt files.

### Reproducibility defaults for AI-assisted execution

- Run R work through `nix-shell`, preferably `nix-shell --run "Rscript ..."`
- Run Python work through `uv run ...`
- Keep Python dependencies reflected in `requirements.txt` or the chosen Python environment file

### Current local Codex skills

- `api-data-fetcher`
- `compile-latex`
- `context-status`
- `data-deposit`
- `deploy`
- `econometrics-julia`
- `econometrics-r`
- `find-data`
- `general-equilibrium-model-builder`
- `identification-strategy`
- `interview-me`
- `journal`
- `latex-econ-model`
- `learn`
- `replication-project-init`
- `literature-review`
- `paper-drafting`
- `quarto-papers`
- `replication-analysis`
- `replication-audit`
- `research-code-review`
- `research-ideation`
- `review-paper`
- `respond-to-referee`
- `submit`
- `talk-from-paper`
- `target-journal`
- `validate-bib`
- `visual-audit`

## 2. Requirements

This workflow requires:
- [Bash](https://www.gnu.org/software/bash/) [Free]
- [R](https://www.r-project.org/) [Free]
- [nix/rix](https://docs.ropensci.org/rix/articles/a-getting-started.html) [Free]

Other great languages and softwares may also be used.
- [Julia](https://julialang.org/) [Free]
- [Python](https://www.python.org) [Free]
- [LaTeX](https://www.latex-project.org) [Free]
- [Stata](https://www.stata.com) [Licensed]
- [Matlab](https://www.mathworks.com/products/matlab) [Licensed]

For now, it is only adapted for Linux or OSX (Apple) environments. But feel free to adapt it to Windows.

#### Dependency management

It is important to set up dependency management for the programming languages we use for replication and reproducibility. I mainly use `rix` R package that leverage `nix` package manager which focuses on reproducible builds. `nix` allows you to create project-specific environments and ensures full reproducibility.

If you want to know more about `rix/nix`, start from here: [https://docs.ropensci.org/rix/index.html](https://docs.ropensci.org/rix/index.html).

**TIP**: After following installation instructions on [https://docs.ropensci.org/rix/index.html](https://docs.ropensci.org/rix/index.html), add this into your `/etc/nix/nix.custom.conf` before installing `cachix` client and configuring `rstats-on-nix` cache:

```
trusted-users = root [NAME OF THE USER FOR YOUR COMPUTER]
```

After that, run this command in the terminal and then do the `cachix` installation and configuration for `rstats-on-nix` cache.

```
sudo systemctl restart nix-daemon
```

This will prevent some warnings from popping up when you use `nix-shell`.

## 3. Leveraging on GitHub capabilities

- Use GitHub wiki as a document for overall project information, project goals, milestones, and anything that should be permanently documented.
- Use issues as tasks. Number your code/data/output folders to match issue numbers.
- Use branches to ensure your main research workflow is not corrupted. Also modify files via pull requests.

## Things to note for reproducibility

Some sections in this template may need to be updated in the future. I'll periodically handle the updates, but if any issues arise, please check whether they are related to these sections.

1. `Dockerfile`: You can run the `Dockerfile` to create a container for your project.
2. `.github/workflows/`: You can use GitHub actions to automate your project build process.

For more information on some trials and errors related to the `Dockerfile`, check this [blog post](https://hchulkim.github.io/posts/dockerfile-trial/)

# Example README template

When you are creating your own research project based on this GitHub template, only keep the format below and erase all the contents above. Also erase the [README documentation and checklist section](#readme-documentation-and-checklist) below.

## README documentation and checklist

This part should contain following information:

1. Documentation: A README document is included, containing a Data Availability Statement, listing all software and hardware dependencies and requirements (including the expected run time), and explaining how to reproduce the research results. The README follows the schema provided by the Social Science Data Editors' template README
2. Data availability statement: A Data Availability Statement is provided with detailed enough information such that an independent researcher can replicate the steps needed to access the original data, including any limitations and the expected monetary and time cost of data access.
3. Location: Data and programs are archived by the authors in the repositories deemed acceptable by the journal.
4. Citation: All data used in the paper are cited.
5. License: A license specifies the terms of use of code and data in the replication package. The license allows for replication by researchers unconnected to the original parties.
6. Omissions: The README clearly indicates any omission of the required parts of the package due to legal requirements or limitations or other approved agreements.

For a more detailed instructions, click this [link](https://aeadataeditor.github.io/aea-de-guidance/preparing-for-data-deposit.html).

- [ ] Data Availability and Provenance Statements
  - [ ] Statement about Rights
  - [ ] License for Data (optional, but recommended)
  - [ ] Details on each Data Source
- [ ] Dataset list
- [ ] Computational requirements
  - [ ] Software Requirements
  - [ ] Controlled Randomness (as necessary)
  - [ ] Memory, Runtime, and Storage Requirements
- [ ] Description of programs/code
  - [ ] License for Code (Optional, but recommended)
- [ ] Instructions to Replicators
  - [ ] Details (as necessary)
- [ ] List of tables and programs
- [ ] References (Optional, but recommended)

## Citation

You can cite our repo using following notation:

```
Hyoungchul Kim (2025). "Replication template with nix" https://github.com/hchulkim/replication-template-nix
```

## Data Availability and Provenance Statements

**IMPORTANT**: Note that this GitHub repo does not provide the `data/` folder due to the large size of the datasets. They are provided [HERE].

| Data.Name | Data.Files | Location | Provided | Availability statement |
| -- | -- | -- | -- | -- |
| "Example Data" | `example.csv` | `data/raw/` | TRUE | [Description of data source, access method, and citation] |

## Replication package expected run-time

This replication package's expected run-time is 000.

## Computational requirements

We strongly suggest following the requirements to install and set up the environment to run the analysis.

### Memory, storage and hardware Requirements

The code was last run on a **Intel-based laptop with Linux Ubuntu 22.04.5 LTS (Jammy Jellyfish) with 1TB of total storage and 64GB of RAM**. Information on number of CPUs and cores is posted below:

- CPU(s):                                22
- Thread(s) per core:                   2
- Core(s) per socket:                   16
- Socket(s):                            1

The project takes up around 000GB of storage.

### OS-Specific Considerations

- Linux (Ubuntu, Fedora (asahi linux), etc) is highly recommended; MacOS is supported.
- Windows is not officially supported. Users may encounter issues with file path formats and parallel processing.

### Bash (terminal)

Portions of the code use bash scripting, which may require Linux or Unix-like terminal

### Reproducible environments (system dependencies)

- The project uses the [`rix`](https://docs.ropensci.org/rix/index.html) package to manage and isolate package dependencies. Follow the instructions in the link to install and run `nix` and `rix`.

To initialize the environment run this in the terminal:

```bash
# Restore the project environment
nix-build

# Start the project environment nix shell
nix-shell
```

## Description of programs/code

> INSTRUCTIONS: Give a high-level overview of the program files and their purpose. Remove redundant/obsolete files from the Replication archive.

- Programs in `code/build/` will extract and reformat all datasets referenced above. Each subfolder is numbered to match the corresponding GitHub issue.
- Programs in `code/analysis/` generate all tables and figures. Each subfolder is numbered to match the corresponding GitHub issue and output subfolder.
- Output from each analysis step is stored in the corresponding `output/NN_description/tables/` and `output/NN_description/figures/` folder.

## Instructions to Replicators

**IMPORTANT**: Note that this GitHub repo does not provide the `data/` or `output/` folders. Data is provided [HERE].

### Using Docker

Assuming that you've met the "Computational requirements" above, you can use `git clone` to download this repository.

### Not using Docker

Assuming that you've met the "Computational requirements" above, you can use `git clone` to download this repository. Install `nix` and `rix`. Then open the terminal and use `nix-build` to restore the project environment. Finally type `nix-shell` in the terminal to open the project environment.

The entire pipeline now can be executed using the **`Makefile`** master script:

```bash
make
```

> **Important:** The `Makefile` must be placed in the top-level project directory — parallel to the `code/` and `data/` folders — for the paths to resolve properly.

On Windows, users may need to install [GNU Make](https://www.gnu.org/software/make/) manually. macOS and Linux users typically have it pre-installed.

If preferred, users can run the R scripts manually in sequence by navigating to each numbered subfolder in `code/`. Each subfolder is prefixed with a number (`01_`, `02_`, etc.) that indicates its order of execution.

### Details

- `Makefile`: will run the entire pipeline to ensure reproducibility. All the dependencies between the code scripts are written in the file.

## List of tables, figures and programs

All table results are in `output/NN_description/tables/` and all figure results are in `output/NN_description/figures/`.

| Figure/Table # | Program | Output file | Note |
|---|---|---|---|
| Table 1 | `code/analysis/01_example/lorem.R` | `output/01_example/tables/example_output.csv` | |

## References

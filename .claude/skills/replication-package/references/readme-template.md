# README Template for Replication Package

## Overview

**Title:** [Paper Title]  
**Authors:** [Author Names]  
**Date:** [Date]

This repository contains the code and data required to replicate the findings in "[Paper Title]".

## Data Availability and Provenance Statements

### Statement about Rights
- [ ] I certify that the author(s) of the manuscript have legitimate access to and permission to use the data used in this manuscript.

### Summary of Availability
- [ ] All data **are** publicly available.
- [ ] Some data **cannot be made** publicly available.
- [ ] **No data can be made** publicly available.

### Details on Each Data Source

| Data Name | Files | Location | Provided | Citation |
|-----------|-------|----------|----------|----------|
| [Dataset 1] | `file1.csv` | `data/raw/` | Yes | [Citation] |
| [Dataset 2] | `file2.dta` | `data/raw/` | No | [Citation] |

**[Dataset 1]**: [Description of data, how to access, any restrictions]

**[Dataset 2]**: [Description, access requirements, why not provided if applicable]

## Computational Requirements

### Software Requirements

- R 4.3.2
  - `data.table` (version X.X.X)
  - `fixest` (version X.X.X)
  - [other packages as listed in generate_env.R]
- nix package manager (for reproducible environment)
- Quarto (version X.X) [if applicable]

All R package dependencies are managed through `rix` and can be installed automatically.

### Memory, Runtime, and Storage Requirements

#### Summary

| Category | Requirement |
|----------|-------------|
| Memory | XX GB RAM |
| Storage | XX GB disk space |
| Runtime | Approximately X hours |

#### Details

The code was last run on:
- **OS:** [Ubuntu 22.04 / macOS 14.x]
- **Processor:** [Intel i7-XXXX / Apple M2]
- **Memory:** XX GB RAM
- **Runtime:** [X hours total]

Approximate time breakdown:
- Data construction: X minutes
- Main analysis: X minutes
- Appendix: X minutes

### Controlled Randomness

- Random seed is set at line [X] of `code/analysis/01-main.R`
- [Describe any other stochastic elements and how they are controlled]

## Description of Programs

### Code Structure

```
code/
├── build/
│   ├── 01-clean-data.R      # Cleans raw data
│   ├── 02-merge-data.R      # Merges datasets
│   └── 03-construct-vars.R  # Creates analysis variables
└── analysis/
    ├── 01-main-regressions.R  # Tables 1-3
    ├── 02-event-study.R       # Figure 1
    ├── 03-robustness.R        # Appendix Tables A1-A3
    └── 04-heterogeneity.R     # Tables 4-5
```

### License for Code

The code is licensed under a [MIT License]. See `LICENSE.txt` for details.

## Instructions to Replicators

### Setup (One-Time)

1. Install nix package manager:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/[username]/[repo].git
   cd [repo]
   ```

3. Build the reproducible environment:
   ```bash
   nix-build
   ```

4. [If applicable] Obtain restricted data and place in `data/raw/`

### Replication

Run all analyses:
```bash
nix-shell --run "make all"
```

Or run specific components:
```bash
nix-shell --run "make data"      # Data construction only
nix-shell --run "make analysis"  # Analysis only
nix-shell --run "make paper"     # Compile paper
```

### Verifying Outputs

After running, compare:
- `output/tables/` with tables in the paper
- `output/figures/` with figures in the paper

## List of Tables and Programs

| Table/Figure | Program | Output File |
|--------------|---------|-------------|
| Table 1 | `code/analysis/01-main-regressions.R` | `output/tables/tab1.tex` |
| Table 2 | `code/analysis/01-main-regressions.R` | `output/tables/tab2.tex` |
| Figure 1 | `code/analysis/02-event-study.R` | `output/figures/fig1.pdf` |
| Figure 2 | `code/analysis/02-event-study.R` | `output/figures/fig2.pdf` |
| Table A.1 | `code/analysis/03-robustness.R` | `output/tables/tab_a1.tex` |

## References

[Include data citations here]

---

## Acknowledgements

This README follows the [Social Science Data Editors' template](https://social-science-data-editors.github.io/template_README/) and [DCAS standards](https://datacodestandard.org/).

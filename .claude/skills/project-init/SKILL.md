---
name: project-init
description: Initialize new economics research projects with standardized structure. Use when starting a new research project to create folder structure, configuration files, and boilerplate code. Sets up git, rix environment, Makefile, and connects to Dropbox/Overleaf.
---

# Project Initialization

## Quick Start
Run the initialization script:
```bash
bash code/init_project.sh "project-name" "/path/to/projects"
```

Or manually create structure following the template below.

## Standard Project Structure

**GitHub** holds only `code/` and config files. **Dropbox** holds `data/` and `output/`, symlinked into the project.

```
project-name/                   # ── GitHub repo ──
├── .git/
├── .gitignore
├── .here
├── CLAUDE.md
├── Makefile
├── README.md
├── generate_env.R
│
├── code/
│   ├── build/
│   │   └── 01_issue_name/     # Numbered by GitHub issue
│   │       └── 01_clean.R
│   └── analysis/
│       └── 01_issue_name/
│           └── 01_baseline.R
│
├── data/ → ~/Dropbox/.../data  # ── Symlink to Dropbox ──
│   ├── raw/                    # Original, immutable data
│   └── build/
│       └── 01_issue_name/      # Mirrors code/ numbering
│
└── output/ → ~/Dropbox/.../output  # ── Symlink to Dropbox ──
    ├── 01_issue_name/          # Numbered — mirrors code/
    │   ├── tables/
    │   └── figures/
    ├── paper/                  # NOT numbered — main output
    └── slides/                 # NOT numbered — main output
```

## Configuration Files

### .gitignore
```gitignore
# Data and output live on Dropbox, not in git
data/
output/

# Nix
result
result-*
default.nix
.direnv/

# R
.Rhistory
.RData
.Rproj.user/
*.Rproj

# Python
__pycache__/
*.pyc
.ipynb_checkpoints/

# Julia
*.jl.cov
*.jl.mem

# LaTeX
*.aux
*.log
*.out
*.bbl
*.blg
*.fls
*.fdb_latexmk
*.synctex.gz

# OS
.DS_Store
Thumbs.db

# Editor
*.swp
*.swo
*~
.vscode/
.idea/
```

### generate_env.R (starter template)
```r
library(rix)

rix(
  r_ver = "4.3.2",
  r_pkgs = c(
    # Core
    "data.table",
    "here",
    
    # Econometrics
    "fixest",
    
    # Output
    "modelsummary",
    "ggplot2"
  ),
  system_pkgs = NULL,
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
```

### Makefile (starter template)
```makefile
.PHONY: all clean data analysis paper

codedir   = code/
builddir  = code/build/
analysdir = code/analysis/
datadir   = data/
outputdir = output/

all: analysis

# ============== DATA ==============
$(datadir)build/01_clean_data/analysis.rds: $(builddir)01_clean_data/01_clean.R
	nix-shell --run "Rscript $<"

data: $(datadir)build/01_clean_data/analysis.rds

# ============== ANALYSIS ==============
$(outputdir)01_main_reg/tables/main.tex: $(analysdir)01_main_reg/01_baseline.R $(datadir)build/01_clean_data/analysis.rds
	nix-shell --run "Rscript $<"

analysis: $(outputdir)01_main_reg/tables/main.tex

# ============== PAPER ==============
paper: $(outputdir)paper/paper.pdf

$(outputdir)paper/paper.pdf: $(outputdir)paper/paper.qmd analysis
	nix-shell --run "quarto render $<"

# ============== CLEAN ==============
clean:
	rm -f $(datadir)build/*/*.rds
	rm -f $(outputdir)*/tables/*.tex
	rm -f $(outputdir)*/figures/*.pdf
```

## Dropbox Integration

### Symlink data and output from Dropbox
```bash
# Link Dropbox data and output to project
ln -s ~/Dropbox/Projects/project-name/data data
ln -s ~/Dropbox/Projects/project-name/output output
```

### Create Dropbox directory structure
```bash
# On Dropbox, create the initial structure
mkdir -p ~/Dropbox/Projects/project-name/data/{raw,build}
mkdir -p ~/Dropbox/Projects/project-name/output/paper
mkdir -p ~/Dropbox/Projects/project-name/output/slides
```

## Git Setup
```bash
cd project-name
git init
git add .
git commit -m "Initial project structure"

# Add remote
git remote add origin git@github.com:username/project-name.git
git push -u origin main
```

## Starting New Scripts

### R Script Header
```r
# ============================================================
# Script: 01-build-data.R
# Purpose: [Brief description]
# Author: [Name]
# Date: [Date]
# Inputs: data/raw/[files]
# Outputs: data/build/01_issue_name/[files]
# ============================================================

# Setup
library(data.table)
library(here)

# Paths
raw_dir   <- here("data", "raw")
build_dir <- here("data", "build", "01_clean_data")

# [Code here]
```

### Julia Script Header
```julia
#=
Script: 01-estimation.jl
Purpose: [Brief description]
Author: [Name]
Date: [Date]
Inputs: data/build/01_issue_name/[files]
Outputs: output/01_issue_name/[files]
=#

using DataFrames, CSV
using FixedEffectModels
using Optim

# Paths
const DATA_DIR = joinpath(@__DIR__, "..", "..", "data", "build", "01_issue_name")
const OUT_DIR = joinpath(@__DIR__, "..", "..", "output", "01_issue_name")

# [Code here]
```

### Python Notebook First Cell
```python
"""
Notebook: 01_analysis.ipynb
Author: [Name]
Email: [Email]
Date Modified: [Date]
Description: [Brief description]
Inputs: [List inputs]
Outputs: [List outputs]
"""

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Directories
TOP_DIR     = os.path.join(os.path.expanduser("~"), "Dropbox/Projects/project-name")
DATA_DIR    = os.path.join(TOP_DIR, "data", "build", "01_issue_name")
OUTPUT_DIR  = os.path.join(TOP_DIR, "output", "01_issue_name")
```

## Checklist for New Projects
- [ ] Create folder structure
- [ ] Initialize git repository
- [ ] Set up .gitignore
- [ ] Create .here file
- [ ] Set up generate_env.R with required packages
- [ ] Run `nix-build` to test environment
- [ ] Create initial Makefile
- [ ] Set up Dropbox symlinks (if applicable)
- [ ] Add project-specific CLAUDE.md

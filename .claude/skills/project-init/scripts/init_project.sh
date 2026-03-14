#!/bin/bash
# Initialize an economics research project in the current directory.
# Existing files are never overwritten -- only missing pieces are created.

set -e

PROJECT_PATH="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_PATH")"

echo "Initializing project in: $PROJECT_PATH"

# ---- helper: write a file only if it does not already exist ----
write_if_missing() {
    local filepath="$1"
    if [ -f "$filepath" ]; then
        echo "  SKIP  $filepath (already exists)"
        return 1
    fi
    echo "  CREATE $filepath"
    return 0
}

# ---- directory structure ----
# Only code/ lives in GitHub. data/ and output/ live on Dropbox (symlinked).
mkdir -p "$PROJECT_PATH"/code/{build,analysis}

# .gitkeep files (safe: touch won't alter existing files)
for dir in code/build code/analysis; do
    touch "$PROJECT_PATH/$dir/.gitkeep"
done

# .here marker
touch "$PROJECT_PATH/.here"

# ---- .gitignore ----
if write_if_missing "$PROJECT_PATH/.gitignore"; then
cat > "$PROJECT_PATH/.gitignore" << 'EOF'
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
EOF
fi

# ---- generate_env.R ----
if write_if_missing "$PROJECT_PATH/generate_env.R"; then
cat > "$PROJECT_PATH/generate_env.R" << 'EOF'
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
  ide = "other",
  project_path = ".",
  overwrite = TRUE
)
EOF
fi

# ---- Dockerfile ----
if write_if_missing "$PROJECT_PATH/Dockerfile"; then
cat > "$PROJECT_PATH/Dockerfile" << 'EOF'
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
EOF
fi

# ---- Makefile ----
if write_if_missing "$PROJECT_PATH/Makefile"; then
cat > "$PROJECT_PATH/Makefile" << 'EOF'
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
EOF
fi

# ---- README.md ----
if write_if_missing "$PROJECT_PATH/README.md"; then
cat > "$PROJECT_PATH/README.md" << EOF
# $PROJECT_NAME

## Overview

[Brief description of the project]

## Requirements

- Docker (for full replication), or
- Nix package manager (for local development)

## Setup (Local)

\`\`\`bash
# Build environment
nix-build

# Enter environment
nix-shell
\`\`\`

## Replication (Docker)

\`\`\`bash
docker build -t $PROJECT_NAME .
docker run -v \$(pwd)/results:/shared_folder $PROJECT_NAME
\`\`\`

## Replication (Local)

\`\`\`bash
nix-shell --run "make all"
\`\`\`

## Structure

\`\`\`
├── code/               # In GitHub
│   ├── build/          # Data construction (numbered by issue)
│   └── analysis/       # Analysis scripts (numbered by issue)
├── data/               # On Dropbox (symlinked)
│   ├── raw/            # Original data
│   └── build/          # Intermediate (numbered by issue)
└── output/             # On Dropbox (symlinked)
    ├── 01_issue_name/  # Numbered (tables/ + figures/)
    ├── paper/          # NOT numbered
    └── slides/         # NOT numbered
\`\`\`
EOF
fi

# ---- CLAUDE.md ----
if write_if_missing "$PROJECT_PATH/CLAUDE.md"; then
cat > "$PROJECT_PATH/CLAUDE.md" << 'EOF'
# Project-Specific Claude Instructions

## This Project
[Add project-specific instructions here]

## Data Sources
[Document data sources and how to access them]

## Key Variables
[Document key variable definitions]
EOF
fi

echo ""
echo "Project initialized successfully!"
echo ""
echo "Next steps:"
echo "  # Edit generate_env.R to add required packages"
echo "  Rscript generate_env.R"
echo "  nix-build"
echo "  nix-shell"
echo ""

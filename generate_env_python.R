# -----------------------------------------------------------------------------
# Initial date: 2026-02-25
# Modified date: 2026-03-14
# Maintainer: Hyoungchul Kim
# Task: R script that creates nix/rix environment with Python (via uv).
#       You need to have here and rix R packages to run this. You can actually
#       run it without having any R related packages and even R. If interested,
#       read the vignettes of rix R package.
# -----------------------------------------------------------------------------

# when using local machine with here R package
if (require("here")) {
    library(here)
    path_default_nix <- here()
} else {
    # when using Docker
    path_default_nix <- "."
}

library(rix)

rix(date = "2025-11-24", # use `available_dates()` to get the snapshot date you want to use.
    # list R packages to install:
    r_pkgs = c("rix", "languageserver", "pacman", "here", "data.table"),
    # list system packages to install (uv for python environment):
    system_pkgs = c("uv"),
    git_pkgs = NULL,
    # list julia packages to install:
    jl_conf = list(
        jl_version = "1.11",
        jl_pkgs = c("CSV", "DataFrames")
    ),
    ide = "none",
    project_path = path_default_nix,
    overwrite = TRUE,
    print = TRUE,
    # this shell_hook is for installing python packages
    shell_hook = "
      if [ ! -f pyproject.toml ]; then
        uv init --python 3.13
      fi
      uv add --requirements requirements.txt
      # Create alias so python uses uv's environment
      alias python='uv run python'
    ")

# -----------------------------------------------------------------------------
# Initial date:
# Modified date:
# Maintainer: Hyoungchul Kim
# Task: Example analysis script — produces tables and figures
# Issue: #01
# Input: data/build/01_example/
# Output: output/01_example/tables/, output/01_example/figures/
# -----------------------------------------------------------------------------

# load packages
pacman::p_load(here, data.table)

# read intermediate data
dt <- fread(here("data", "build", "01_example", "iris_clean.csv"))

# save example output
fwrite(dt, here("output", "01_example", "tables", "example_output.csv"))

# -----------------------------------------------------------------------------
# Initial date:
# Modified date:
# Maintainer: Hyoungchul Kim
# Task: Example build script — creates intermediate data
# Issue: #01
# Input: data/raw/
# Output: data/build/01_example/
# -----------------------------------------------------------------------------

# load packages
pacman::p_load(here, data.table)

# load shared helpers
source(here("R", "clean.R"))

# read raw data (example: iris)
dt <- as.data.table(iris)

# standardize column names to snake_case
dt <- standardize_names(dt)

# save intermediate dataset
fwrite(dt, here("data", "build", "01_example", "iris_clean.csv"))

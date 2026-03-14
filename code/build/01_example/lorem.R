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

# read raw data (example: iris)
dt <- as.data.table(iris)

# save intermediate dataset
fwrite(dt, here("data", "build", "01_example", "iris_clean.csv"))

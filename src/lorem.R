# -----------------------------------------------------------------------------
# Initial date: 
# Modified date: 
# Maintainer: Hyoungchul Kim
# Task: Example R script
# -----------------------------------------------------------------------------

# download/load necessary packages
pacman::p_load(here, data.table)

# save example output dataset
iris |> fwrite(here("output", "tables", "example_output.csv"))

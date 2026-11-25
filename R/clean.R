# -----------------------------------------------------------------------------
# Initial date:
# Modified date:
# Maintainer: Hyoungchul Kim
# Task: Shared helper functions (placeholder examples)
# Description: Pure, reusable functions sourced by build/analysis scripts.
#   Helpers take all inputs as arguments, return new objects, and never
#   modify global options, the working directory, or their inputs.
# Input: none (functions only)
# Output: none (functions only)
# -----------------------------------------------------------------------------

# Convert column names to snake_case and return a new data.table.
standardize_names <- function(dt) {
  stopifnot(data.table::is.data.table(dt))

  out <- data.table::copy(dt)
  new_names <- tolower(gsub("[^A-Za-z0-9]+", "_", names(out)))
  data.table::setnames(out, new_names)

  out
}


# Element-wise ratio that returns NA where the denominator is zero or missing.
safe_ratio <- function(num, den) {
  stopifnot(is.numeric(num), is.numeric(den))
  stopifnot(length(num) == length(den))

  out <- num / den
  out[is.na(den) | den == 0] <- NA_real_

  out
}

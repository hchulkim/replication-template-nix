# -----------------------------------------------------------------------------
# Initial date:
# Modified date:
# Maintainer: Hyoungchul Kim
# Task: Unit tests for R/clean.R (placeholder examples)
# Input: tests/fixtures/iris_raw_head.csv, tests/fixtures/iris_clean_head.csv
# Output: none (test results only)
# Note: fixtures are oracles. Fix the code, not the fixture, when a test fails.
# -----------------------------------------------------------------------------

pacman::p_load(here, data.table, testthat)

source(here("R", "clean.R"))

fixture_dir <- here("tests", "fixtures")


test_that("standardize_names matches the golden snapshot", {
  # raw fixture: first five rows of iris with original column names
  raw <- fread(file.path(fixture_dir, "iris_raw_head.csv"), check.names = FALSE)

  # reference fixture: expected cleaned output
  expected <- fread(file.path(fixture_dir, "iris_clean_head.csv"))

  result <- standardize_names(raw)

  expect_equal(result, expected)  # expect_equal compares numbers with tolerance
})


test_that("standardize_names does not modify its input", {
  raw <- data.table(`Sepal.Length` = 1)
  standardize_names(raw)

  expect_identical(names(raw), "Sepal.Length")
})


test_that("safe_ratio handles zero, missing, and mismatched inputs", {
  result <- safe_ratio(c(1, 2, 3), c(3, 0, NA))

  expect_equal(result[1], 1 / 3)
  expect_true(all(is.na(result[2:3])))
  expect_error(safe_ratio(c(1, 2), c(1, 2, 3)))
})

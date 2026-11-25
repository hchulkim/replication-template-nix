# Agent Guide: Polyglot Data Pipeline Project

This document provides mandatory operational context, constraints, and coding standards
for AI agents and human contributors working in this repository.

---

- **Read-Only Data**: The `data/` directory is strictly immutable. Never attempt to write,
  delete, or overwrite files in `data/`. 

---

## 3. Language Semantic Guardrails (Mandatory)

### Python Standards
- **Immutability**: Do NOT use `inplace=True` on pandas objects. Return new DataFrames via
  `.assign()`, `.copy()`, or functional transformations.
- **No Mutable Defaults**: Never define functions with mutable default arguments (e.g., `def f(x=[])`).
- **Strict Scoping**: Helper functions must be pure. Do not reference variables from outer/global
  scope; pass all inputs explicitly as arguments.
- **Fail Loudly**: Never use broad `try: ... except Exception:` blocks that return `None`. If an
  unexpected error occurs, allow it to raise.
- **Numerical Tolerance**: Never assert direct float equality (`==`). Use `pytest.approx()`
  or `np.isclose()`.

### R Standards
- **Pure Functions**: Write modular functions inside `R/`. Avoid modifying global options (`options()`)
  or working directories (`setwd()`).
- **Explicit Length Checks**: Guard against vector recycling bugs by verifying vector lengths before
  element-wise operations (`stopifnot(length(a) == length(b))`).
- **Defensive Missingness**: Explicitly account for `NA` and `NULL` values. Never assume a vector
  is non-empty without checking.

---

## 4. Verification Protocol & Oracles

- **Integrity of Oracles**: You are STRICTLY FORBIDDEN from modifying test assertions or golden
  datasets in `tests/` to make failing code pass. If a test fails against an oracle, the bug is
  in your implementation.
- **Golden Snapshots**: When refactoring data wrangling nodes, verify output equivalence against
  the verified reference datasets in `tests/fixtures/`.

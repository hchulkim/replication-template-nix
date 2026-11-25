---
paths:
  - "**/*.py"
  - "**/*.ipynb"
---

# Python script conventions

Loaded when working with Python files or notebooks. Research-integrity rules (data
boundaries, estimation changes, test oracles) stay in the root `CLAUDE.md`. Python
scripts follow the same task layout, header, and Make-registration rules as R scripts.

## Python scripts

- **Immutability**: Do not use `inplace=True` on pandas objects. Return new DataFrames
  via `.assign()`, `.copy()`, or other functional transformations.
- **No mutable defaults**: Never define functions with mutable default arguments (e.g.,
  `def f(x=[])`); use `None` and create the object inside the function.
- **Strict scoping**: Keep helper functions pure. Do not reference variables from
  outer or global scope; pass all inputs explicitly as arguments.
- **Fail loudly**: Never use broad `try: ... except Exception:` blocks that return
  `None` or otherwise hide failures. Catch only specific, expected exceptions; let
  unexpected errors raise.
- **Numerical tolerance**: Never assert direct float equality (`==`). Use
  `pytest.approx()` or `np.isclose()`.

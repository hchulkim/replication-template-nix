# Audit Checklist

## Standard audit

1. compile the manuscript or slide deck
2. run the relevant scripts
3. verify referenced files exist
4. check outputs are not stale relative to code edits

Execution defaults:

- R scripts through `nix-shell --run "Rscript ..."`
- Python scripts through `uv run ...`

## Submission-level audit

5. confirm a master run order exists
6. confirm dependencies are documented
7. confirm data provenance and access notes exist
8. run the end-to-end pipeline when feasible
9. trace each manuscript table or figure to a generating script
10. review README completeness for replication

## Reporting

- list each failed check explicitly
- include the exact missing file or failing command
- separate blocking failures from warnings

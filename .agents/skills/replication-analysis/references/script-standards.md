# Script Standards

## Folder mapping

- build scripts: `code/build/NN_issue_name/`
- analysis scripts: `code/analysis/NN_issue_name/`
- build outputs: `data/build/NN_issue_name/`
- analysis outputs: `output/NN_issue_name/{tables,figures}/`

## Script expectations

- use relative paths only
- keep a clear section order
- document sample restrictions and merge rates
- save reusable intermediate objects when downstream scripts depend on them
- create output directories before writing

## Recommended workflow

1. build or clean data
2. run the main specification
3. generate tables and figures
4. write a short result note if the task asks for it

## Verification

- prefer `nix-shell --run ...` for R commands
- prefer `uv run ...` for Python commands
- verify the exact target script, not the entire repo, unless the task is broad
- mention missing data, unavailable software, or restricted dependencies explicitly

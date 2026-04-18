# Setup Checklist

## Read first

- `README.md`
- `WORKFLOW.md`
- `generate_env.R`
- `generate_env_python.R`
- `Makefile`

## Bootstrap steps

1. Replace template-facing project names, URLs, and README placeholders.
2. Verify the expected symlink targets:
   - `data/`
   - `output/`
3. Check whether the user wants:
   - R only via `generate_env.R`
   - R plus Python via `generate_env_python.R`
4. Confirm the issue-numbered folder convention will be used for new work.
5. Avoid editing `.claude/` unless the task is explicitly about migrating or archiving it.

## Handoff artifacts

- repo-specific `README.md` or setup note
- environment manifest updated if needed
- confirmed symlink instructions
- first issue folder scaffold if requested

## Minimal verification

- `ls -l data output` after symlink setup
- `Rscript generate_env.R` or the chosen environment command
- `nix-build` or `nix-shell --run ...` only if the user asks for full environment verification

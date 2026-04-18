---
name: context-status
description: "Summarize current session state and preserved project context. Use when Codex needs to report what files and plans capture the current state, identify what will survive a long session boundary, or point the user to the latest durable artifacts on disk."
---

# Context Status

## Workflow

1. Identify durable state on disk first.
2. Report the latest relevant files:
   - plans
   - session notes
   - edited outputs
3. Prefer concrete file paths over vague session summaries.

## Load references as needed

- Read `references/session-artifacts.md` for the usual places to check.

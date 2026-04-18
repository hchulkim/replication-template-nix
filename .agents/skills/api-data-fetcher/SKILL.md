---
name: api-data-fetcher
description: "Fetch structured data from external APIs for research workflows. Use when Codex needs to query a documented API, save raw responses reproducibly, transform them into project-ready tables, or document authentication and rate-limit constraints for later reruns."
---

# Api Data Fetcher

## Workflow

1. Identify the API, endpoint, auth method, and rate limits.
2. Save raw pulls separately from cleaned outputs.
3. For Python clients, prefer `uv run ...` and document env vars.
4. Record request parameters so the pull is reproducible.

## Load references as needed

- Read `references/api-fetch-checklist.md` for fetch and storage conventions.

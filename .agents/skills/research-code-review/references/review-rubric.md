# Review Rubric

## Severity order

1. result-changing bugs
2. reproducibility failures
3. output-generation failures
4. maintainability and style

## Review checklist

- estimators, FE, clustering, and samples match the stated design
- no absolute paths or machine-local assumptions
- seeds or randomness controls are explicit when needed
- outputs are written where the paper expects them
- comments explain non-obvious choices
- dead code and stale outputs are flagged

## Review format

```markdown
1. [Severity] file:line - finding
2. [Severity] file:line - finding

Open questions
- ...
```

Keep the summary short. Findings come first.

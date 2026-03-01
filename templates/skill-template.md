# Skill Creation Template

**Use this template to create domain-specific skills for your academic workflow.**

---

## When to Create a Custom Skill

Create a skill when you find yourself:
- Repeatedly explaining the same 3+ step workflow to Claude
- Needing domain-specific quality checks (citation style, notation consistency, lab protocols)
- Enforcing field-specific output formats (thesis structure, journal templates, lab notebooks)
- Coordinating multi-tool workflows (Figma -> R -> LaTeX, data -> analysis -> manuscript)

**Don't create a skill for:**
- One-time tasks
- Workflows that change frequently
- Simple 1-2 step operations

---

## Template Structure

Copy the structure below to `.claude/skills/[your-skill-name]/SKILL.md`:

```markdown
---
name: your-skill-name
description: [What it does] + [When to use it] + [Key capabilities]. Use when user asks for "[trigger phrase 1]", "[trigger phrase 2]", or "[context]".
argument-hint: "[brief hint for user]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
disable-model-invocation: true
---

# [Skill Name]

[One sentence: what this skill accomplishes and why it exists]

## Instructions

Step 1: [First major action with clear explanation]
   - Detail: [Important consideration]
   - Example: [Concrete example]

Step 2: [Second major action]
   - Detail: [Important consideration]

Step 3: [Final action and verification]
   - Verify: [What to check]
   - Output: [What user receives]

## Examples

### Example 1: [Common Scenario Name]
**Context:** [When this occurs]
**User says:** "[Typical user request]"
**Actions:**
1. [What skill does first]
2. [What skill does second]
3. [Final output]
**Result:** [What user receives]

### Example 2: [Another Common Scenario]
**Context:** [Different situation]
**User says:** "[Alternative phrasing]"
**Actions:**
1. [Different path through the skill]
**Result:** [Expected outcome]

## Troubleshooting

**Error:** [Common error message or symptom]
**Cause:** [Why this happens]
**Solution:** [How to fix it]

**Error:** [Another common issue]
**Cause:** [Root cause]
**Solution:** [Fix steps]
```

---

## Writing Effective Descriptions

The `description` field determines when Claude loads your skill. Use this structure:

```
[What it does] + [When to use it] + [Key capabilities]
```

### Good Examples (Field-Specific)

**Citation Style Enforcement (APA Psychology):**
```yaml
description: Enforces APA 7th edition citation format in manuscripts. Use when user asks to "check citations", "fix references", "apply APA style", or when reviewing .tex or .qmd files with bibliography. Checks author-year format, DOI formatting, and reference list completeness.
```

**Econometric Specification Review (Economics):**
```yaml
description: Reviews econometric specifications for common errors. Use when user shares regression code in R or Stata, or asks to "check model spec", "review estimation". Validates: standard error clustering, fixed effects structure, missing covariates, and replication commands.
```

---

## Testing Your Skill

### Step 1: Manual Test
1. Create skill directory: `mkdir -p .claude/skills/your-skill-name`
2. Copy SKILL.md template and customize
3. Restart Claude Code or run `/reload` if available
4. Trigger skill: Use one of your trigger phrases
5. Verify: Skill loads, instructions are clear, output is correct

### Step 2: Iteration
- **If skill doesn't trigger:** Revise description with more specific trigger phrases
- **If instructions unclear:** Add more examples and detail to Steps
- **If output wrong:** Add validation steps, troubleshooting section

### Step 3: Success Criteria
- Skill triggers on 90%+ of relevant queries
- Complete workflow in expected number of steps
- Zero API errors during normal operation
- Same task yields consistent outputs across sessions

---

## Allowed Tools Reference

| Tool | Use For |
|------|---------|
| `Read` | Reading file contents (scripts, manuscripts, data) |
| `Write` | Creating new files (reports, tables, outputs) |
| `Edit` | Modifying existing files in place |
| `Grep` | Searching file contents (citations, function names) |
| `Glob` | Finding files by pattern (*.R, *.tex, *.csv) |
| `Bash` | Running commands (R scripts, LaTeX compilation, git) |
| `Task` | Launching subagents (for complex multi-step workflows) |

**Security note:** Only grant `Bash` access if your skill needs to execute code or compile documents. For read-only validation skills, omit it.

---

## Where This Template Lives

- **File:** `templates/skill-template.md`
- **Purpose:** Starter for domain-specific skills
- **Usage:** Copy to `.claude/skills/[name]/SKILL.md`, customize for your field

For existing skills examples, see `.claude/skills/` directory.

---
name: quarto-papers
description: Academic paper writing using Quarto with AEA-style formatting. Use when creating, editing, or rendering economics papers in Quarto (.qmd). Covers the hchulkim/econ-paper-template, citations, cross-references, figure/table embedding, and LaTeX output.
---

# Quarto Academic Papers

## Setup
Install the AEA-style template:
```bash
quarto use template hchulkim/econ-paper-template
```

Or add to existing project:
```bash
quarto add hchulkim/econ-paper-template
```

## YAML Front Matter
```yaml
---
title: "Paper Title"
author:
  - name: First Author
    affiliations: University Name
    email: author@university.edu
    acknowledgements: "Thanks to..."
  - name: Second Author
    affiliations: Another University
title-footnote: "Draft. Please do not cite without permission."
abstract: |
  This paper studies...
keywords: [keyword1, keyword2, keyword3]
date: last-modified
bibliography: bibliography.bib
format:
  aea-pdf:
    keep-tex: true
  aea-html: default
---
```

## Rendering
```bash
# PDF (primary)
quarto render paper.qmd --to aea-pdf

# HTML (for web viewing)
quarto render paper.qmd --to aea-html

# Both formats
quarto render paper.qmd
```

## Citations and References
```markdown
Single citation: @autor2003  
Parenthetical: [@autor2003]
Multiple: [@autor2003; @dix-carneiro2017]
With page: [@autor2003, p. 123]
In-text: As shown by @autor2003, the effect...
```

BibTeX entry example (`bibliography.bib`):
```bibtex
@article{autor2003,
  author  = {Autor, David H. and Dorn, David and Hanson, Gordon H.},
  title   = {The China Syndrome},
  journal = {American Economic Review},
  year    = {2013},
  volume  = {103},
  number  = {6},
  pages   = {2121--2168}
}
```

## Cross-References

### Figures
```markdown
@fig-results shows the main findings.

![Main Results](output/figures/main.pdf){#fig-results}
```

Or with code chunks:
````markdown
```{r}
#| label: fig-timeseries
#| fig-cap: "Treatment effects over time"
#| fig-width: 8
#| fig-height: 5

ggplot(...) + ...
```

As shown in @fig-timeseries, the effect...
````

### Tables
```markdown
@tbl-summary presents summary statistics.

| Variable | Mean | SD |
|----------|------|-----|
| Y        | 10.5 | 2.3 |
| X        | 5.2  | 1.1 |

: Summary Statistics {#tbl-summary}
```

For LaTeX tables:
```markdown
{{< include output/tables/main_results.tex >}}

See @tbl-main for regression results.
```

### Equations
```markdown
The model is:
$$
Y_{it} = \alpha + \beta D_{it} + \gamma X_{it} + \epsilon_{it}
$$ {#eq-main}

Equation @eq-main shows...
```

### Sections
```markdown
## Data {#sec-data}

As discussed in @sec-data...
```

## Including External Content

### Figures from files
```markdown
![Caption](output/figures/figure1.pdf){#fig-label width=80%}
```

### Tables from LaTeX files
```markdown
{{< include output/tables/table1.tex >}}
```

### Raw LaTeX (when needed)
```markdown
```{=latex}
\begin{landscape}
... wide table ...
\end{landscape}
```
```

## Common Formatting

### Footnotes
```markdown
This is a statement.^[This is the footnote text.]
```

### Block quotes
```markdown
> This is a block quote from another paper.
```

### Lists in papers
```markdown
The main contributions are:

1. First contribution
2. Second contribution  
3. Third contribution
```

## Code Chunks (for computational appendix)
````markdown
```{r}
#| echo: true
#| eval: true
#| code-fold: true

# Show code in appendix
model <- feols(y ~ x | id + year, data = df)
summary(model)
```
````

## Customization

### Modify title page (`_extensions/aea/partials/before-body.tex`)
Edit for custom title page formatting.

### Modify header (`_extensions/aea/partials/_include-header.tex`)
Add custom LaTeX packages:
```latex
\usepackage{booktabs}
\usepackage{siunitx}
```

### Colors
```yaml
format:
  aea-pdf:
    linkcolor: blue
    citecolor: blue
    urlcolor: blue
```

## Workflow Tips
1. Write in `.qmd`, render frequently to catch errors
2. Keep `bibliography.bib` in project root
3. Use relative paths for figures/tables
4. For collaboration: sync with Overleaf via Dropbox
5. Enable render-on-save in VS Code for live preview

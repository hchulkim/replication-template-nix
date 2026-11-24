## References related to replication and reproducibility

- [How much RAM does your replication package actually needs?](https://jpedataeditor.github.io/posts/20261001-ram-usage/).

### Measuring in Linux

two-step logic: find the PID, then either ask the OS for its peak directly, or poll it over time.

The Linux equivalent of `/usr/bin/time -l` is `/usr/bin/time -v`, which reports Maximum resident set size (kbytes). Linux also tracks a running process’s peak RSS for you automatically, in `/proc/<PID>/status`, under `VmHWM` (“high water mark”) - handy if you forgot to wrap the launch command and the job is already running.

```
# peak RAM for the whole run
/usr/bin/time -v Rscript myscript.R 2>&1 | tee run.log
# -> look for "Maximum resident set size (kbytes)" near the bottom of run.log

# RAM over time
PID=$(pgrep -n Rscript)
while kill -0 "$PID" 2>/dev/null; do
  echo "$(date +%s) $(ps -o rss= -p "$PID")"
  sleep 5
done > mem_trace.log

# with parallel/future workers, sum across the worker tree:
pstree -p "$PID"
```

If your job runs inside a container or a cgroup-managed scheduler (Slurm, PBS, Docker), the cgroup itself tracks a true peak for you - no polling, no race against process exit - via `memory.peak` (cgroup v2) or `memory.max_usage_in_bytes` (cgroup v1) under `/sys/fs/cgroup/`.... This is often the most reliable number on a shared cluster, since it reflects exactly what the scheduler enforced against.

- [No hard-coded in-text numbers!](https://jpedataeditor.github.io/posts/20260910-latex-macros/)

### R-Latex using Macros

```
# --- Policy A: a toy "run" of counterfactual A ---
# In a real project this would be your full analysis,
# as complex and lengthy as you prefer. This is a trivial
# example that just outputs the numeric results.
run_policy_A <- function() {
  baseline_welfare <- 100                          # welfare under the status quo
  new_welfare      <- 102.3                        # welfare after applying policy A
  pct_change       <- (new_welfare / baseline_welfare - 1) * 100  # % change
  list(pct = pct_change, n_units_reassigned = 64)  # a % AND a count, bundled
}

# --- Policy B: a second, independent counterfactual ---
run_policy_B <- function() {
  baseline_welfare <- 100
  new_welfare      <- 101.1
  pct_change       <- (new_welfare / baseline_welfare - 1) * 100
  list(pct = pct_change, n_units_reassigned = 12)
}

resA <- run_policy_A()   # named list: % welfare change + a reassignment count
resB <- run_policy_B()

resA
```

```
# a latex macro creator function
# it needs a name, and a value:
mac <- function(name, val) sprintf("\\newcommand{\\%s}{%s}", name, val)
# you can see, this just wraps both parts in a latex command, that will have the `name` you gave above.

# Which policy "wins" is a STRING, not a number, and it belongs in the same
# file for the same reason the percentages do: it should never be typed by
# hand into the paper ("policy A is preferred...").
winner <- if (resA$pct > resB$pct) "A" else "B"

# this creates a vector of strings
lines <- c(
  "% Auto-generated -- do not edit by hand.",
  sprintf("%% Generated: %s", format(Sys.time(), "%Y-%m-%d %H:%M")),
  "",
  "% ---- percentages (one decimal, LaTeX percent sign baked in) ----",
  mac("WelfareA", sprintf("%.1f\\%%", resA$pct)),
  mac("WelfareB", sprintf("%.1f\\%%", resB$pct)),
  "",
  "% ---- integer counts (no decimals, no percent sign) ----",
  mac("NReassA", resA$n_units_reassigned),
  mac("NReassB", resB$n_units_reassigned),
  "",
  "% ---- a text label -- not a number at all ----",
  mac("PreferredPolicy", winner)
)

# we write this vector to a file
writeLines(lines, "results_macros.tex")
# let's print it to screen
cat(lines, sep = "\n")
```

```
\input{outputs/results_macros.tex}
```

```
In our experiment, welfare increases by \WelfareA{} under policy A
(reassigning \NReassA{} units), while it increases by \WelfareB{} under
policy B (reassigning \NReassB{} units). Policy \PreferredPolicy{} is
therefore preferred.
```

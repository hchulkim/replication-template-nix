# Making R.nvim work inside a `rix`-managed nix-shell

This note records what we changed in `~/Documents/test` to get
[R.nvim](https://github.com/R-nvim/R.nvim) working with an R that lives
entirely in the nix store (no global R, no writable user library), while
still letting [`rix`](https://docs.ropensci.org/rix/) own the
`default.nix`.

---

## The original problem

Opening an `.R` file in Neovim while inside `nix-shell` produced:

```
"/home/himakun/R/x86_64-pc-linux-gnu-library/4.4" is not writable.
Create it now? [y/n]

nvim.schedule callback: .../R.nvim/lua/r/server.lua:34:
Invalid 'chunk': expected Array, got String
```

Three distinct issues stacked on top of each other:

1. **R.nvim wants to install its companion R package `nvimcom`** into
   a writable R library on first use. Under `nix-shell`:
   - the system library is `/nix/store/...` (read-only),
   - the user library `~/R/x86_64-pc-linux-gnu-library/<R-ver>` does
     not exist,
   - R.nvim is driving R non-interactively so the "Create it now?"
     prompt can never be answered,
   - **and** the `.Rprofile` that `rix::rix_init()` generates actively
     overrides `install.packages()` to `stop()` with an error telling
     you to add packages to `default.nix` instead — so even if the
     directory existed, the install would be blocked for purity.

2. **rix's generated `.Rprofile` contains a latent R footgun** that,
   on the exact configuration above, silently wipes `.libPaths()`
   to `character(0)`. The offending block (from `rix::rix_init()`):

   ```r
   current_paths <- .libPaths()
   userlib_paths <- Sys.getenv("R_LIBS_USER")
   user_dir <- grep(paste(userlib_paths, collapse = "|"), current_paths, fixed = TRUE)
   new_paths <- current_paths[-user_dir]
   .libPaths(new_paths)
   ```

   The intent is reasonable — strip the user-wide library so nothing
   leaks in from outside nix. The bug is in the last two lines:

   - R auto-defaults `R_LIBS_USER` at startup to
     `~/R/x86_64-pc-linux-gnu-library/<R-ver>`, **even when the user
     never sets it**.
   - If that directory does not exist, R does not add it to
     `.libPaths()`.
   - `grep(...)` then returns `integer(0)`.
   - `current_paths[-integer(0)]` is a well-known R footgun: negative
     indexing with an empty integer vector returns `character(0)`,
     wiping **every** path, including our carefully-injected
     project-local library and every nix-store package directory.
   - `.libPaths(character(0))` then resets to R's bare defaults, so
     the project library our `shellHook` just added has vanished
     by the time R.nvim (or anything else) starts looking for
     packages.

   This is the real reason the "not writable, create it now?" prompt
   ever fires: after the wipe, **no** writable library path remains
   for R.nvim to target, so it falls back to the system default user
   path which doesn't exist.

3. **R.nvim has a latent bug at `server.lua:34`**: when it tries to
   *report* the failure from (1) it calls
   `vim.api.nvim_echo({ "\n" }, ...)` — passing an array containing a
   string where recent Neovim requires an array of
   `{text, hlgroup}` chunks. So the error reporter itself crashes,
   which is the `expected Array, got String` traceback. Fixing (1)
   and (2) avoids triggering this code path; the underlying bug is
   still worth reporting upstream.

---

## What we actually changed

Only two files in the project were touched:

### 1. `generate_env.R`

Added a `shell_hook` argument to the `rix()` call so that every
regenerated `default.nix` carries the env-var tweak we need:

```r
library(rix)

rix(
  r_ver = "4.4.2",
  r_pkgs = c("dplyr", "ggplot2"),
  system_pkgs = NULL,
  git_pkgs = NULL,
  ide = "none",
  project_path = ".",
  overwrite = TRUE,
  shell_hook = "
    export R_LIBS_SITE=\"$PWD/.Rlib:$R_LIBS_SITE\"
    mkdir -p \"$PWD/.Rlib\"
    mkdir -p \"$HOME/R/x86_64-pc-linux-gnu-library/4.4\"
    R CMD INSTALL --library=\"$PWD/.Rlib\" ~/.local/share/nvim/lazy/R.nvim/nvimcom
  "
)
```

What each line does and why:

- **`export R_LIBS_SITE=...`** — **Prepending, not overwriting**,
  `R_LIBS_SITE`. Nix's R wrapper already sets `R_LIBS_SITE` to a long
  colon-separated list of every package's store path (that's literally
  how `dplyr`, `ggplot2`, and their dependencies become visible to R
  under nix). A bare `export R_LIBS_SITE=$PWD/.Rlib` clobbers that
  list and all nix-built packages disappear from `.libPaths()`. We had
  to learn this the hard way. We use `R_LIBS_SITE` rather than
  `R_LIBS_USER` because the `.Rprofile` that `rix::rix_init()` writes
  explicitly strips any entry matching `R_LIBS_USER` out of
  `.libPaths()` for purity. It does *not* touch `R_LIBS_SITE`, so
  that's the channel we use. (`R_LIBS` also works as an alternative.)

- **`mkdir -p "$PWD/.Rlib"`** — Ensures the project-local library
  directory exists before `R CMD INSTALL` tries to write into it.

- **`mkdir -p "$HOME/R/x86_64-pc-linux-gnu-library/4.4"`** — **This
  is the critical line that defuses the `.Rprofile` footgun** (issue
  #2 above). By creating the default `R_LIBS_USER` directory, R
  includes it in `.libPaths()` at startup. This means rix's `grep()`
  call finds a real match (index `c(N)` instead of `integer(0)`), and
  `current_paths[-c(N)]` removes *only that one path* instead of
  wiping everything via `[-integer(0)]`. Our `.Rlib` and all the nix
  store paths survive. **The R version in this path must match your
  `r_ver` argument** (e.g., `4.4` for `r_ver = "4.4.2"`, `4.5` for
  `r_ver = "4.5.1"`).

- **`R CMD INSTALL ...`** — Compiles and installs R.nvim's companion
  `nvimcom` package into `.Rlib` at shell entry, so R.nvim never
  needs to build it at runtime. This runs on every `nix-shell` entry;
  if nvimcom is already current it finishes in under a second.

### 2. `default.nix`

Not edited by hand — regenerated by running `generate_env.R`. After
regeneration `rix` writes a `shellHook` into the `mkShell` call that
contains the `export` line above. Because `default.nix` is rewritten
on every `rix()` call (`overwrite = TRUE`), any manual edit here would
be lost on the next regeneration; keep the customisation in
`generate_env.R`.

### 3. Project-local R library `./.Rlib`

The `shell_hook` above handles everything automatically: it creates
`.Rlib`, installs `nvimcom` into it, and exports the path. On every
`nix-shell` entry, `R CMD INSTALL` re-runs — if `nvimcom` is already
current this finishes in under a second.

Why `R CMD INSTALL` works even though `rix`'s `.Rprofile` overrides
`install.packages()`: `R CMD INSTALL` is a separate subcommand that
does not go through `install.packages()`, so the override does not
intercept it. `nvimcom` is a self-contained R package (`DESCRIPTION`,
`R/`, `src/`, `NAMESPACE`, `man/`) vendored inside the R.nvim plugin
directory, so we can hand that directory to `R CMD INSTALL` directly.

You can safely `.gitignore` (or not commit) the `.Rlib/` directory;
it is local build output, not source.

---

## How to verify it's wired up

From `~/Documents/test`:

```sh
nix-shell default.nix -A shell --run \
  'R --no-save -e "suppressMessages({library(dplyr); library(ggplot2); library(nvimcom)}); cat(\"ALL OK\\n\")"'
```

Expected tail of the output:

```
> suppressMessages({library(dplyr); library(ggplot2); library(nvimcom)}); cat("ALL OK\n")
ALL OK
```

And `.libPaths()` inside that shell should look roughly like:

```
[1] "/home/himakun/Documents/test/.Rlib"
[2] "/nix/store/.../r-dplyr-.../library"
[3] "/nix/store/.../r-ggplot2-.../library"
...
[N] "/nix/store/.../R-4.4.2/lib/R/library"
```

`.Rlib` comes first (that's where `nvimcom` lives), followed by the
nix-built CRAN packages, ending at R's own base library.

---

## Reproducibility caveats

This setup is **mostly** reproducible but has a few sharp edges worth
knowing about.

### 1. `.Rlib` is imperative state outside the nix store

The whole point of `rix` is that `default.nix` pins everything, so
`nix-shell` on another machine rebuilds an identical environment. The
`.Rlib` directory breaks that guarantee: its contents come from a
plain `R CMD INSTALL` of whatever version of `nvimcom` happens to be
vendored in your local R.nvim checkout at the moment you ran the
command. It is **not** pinned by `default.nix`, **not** tracked by
nix, and **not** rebuilt when `default.nix` changes.

Practical implication: `.Rlib` is per-machine scratch. Don't commit
it; regenerate it on each machine. If you need a truly reproducible
`nvimcom`, see the "Going fully pure" section at the bottom.

### 2. You have to rebuild `.Rlib` when things change

Because the `shell_hook` runs `R CMD INSTALL` on every `nix-shell`
entry, most of these are handled automatically — a new shell session
recompiles `nvimcom` against the current R. You may still need to
`rm -rf .Rlib/nvimcom` and re-enter `nix-shell` if:

- **You bump R (e.g. `r_ver = "4.4.2"` → `"4.5.0"`).** Remember to
  also update the `mkdir` path in the shell_hook to match the new
  minor version (e.g., `4.4` → `4.5`).
- **R.nvim updates `nvimcom`** and the stale compiled artifacts in
  `.Rlib` confuse the install. A clean rebuild fixes this.
- **You move the project directory** and cached compiled artifacts
  contain stale absolute paths (rare).

### 3. `.Rlib` is path-sensitive

`R_LIBS_SITE="$PWD/.Rlib:$R_LIBS_SITE"` resolves `$PWD` at the moment
you enter `nix-shell`. If you `cd` elsewhere inside the shell and then
start R from that other directory, `$PWD` has already been captured
into the exported env var, so it keeps pointing at the original
project — that part is fine. But if you *move the project directory*
while inside a running shell, the exported value becomes stale. Exit
and re-enter `nix-shell` after moving the project.

### 4. `rix::rix()` with `overwrite = TRUE` rewrites `default.nix`

Every future regeneration of `default.nix` must go through
`generate_env.R` (or a `rix()` call with the same `shell_hook`
argument). If someone edits `generate_env.R` and drops the
`shell_hook` argument, the next regeneration will silently produce a
`default.nix` with no `shellHook`, `R_LIBS_SITE` will only contain
the nix store paths, `nvimcom` will vanish from `.libPaths()`, and
R.nvim will be back to square one. The `shell_hook` string is the
single source of truth for this fix — keep it in `generate_env.R`.

Note also that `rix::rix_init()` (a *different* function) is what
generated the project's `.Rprofile`. Running it again will overwrite
`.Rprofile`. We currently don't depend on any customisation in that
file, but if you ever add one, be aware it lives in a regenerated file.

### 5. `install.packages()` is still blocked inside the nix-shell

The `.Rprofile` override applies unchanged. This fix does not re-enable
`install.packages()` — it deliberately sidesteps it by using
`R CMD INSTALL`. If you later try `install.packages("somepkg")` from
inside R because you forgot, you'll get the rix stop() message. That's
the intended rix behaviour; the right response is still to add the
package to `r_pkgs` in `generate_env.R` and regenerate.

### 6. The rix `.Rprofile` footgun should be reported upstream

The `current_paths[-integer(0)]` bug in `rix::rix_init()`'s generated
`.Rprofile` is worth reporting to https://github.com/ropensci/rix.
The one-line fix on their end would be:

```r
# before
new_paths <- current_paths[-user_dir]

# after
new_paths <- if (length(user_dir)) current_paths[-user_dir] else current_paths
```

Until that lands, the `mkdir` workaround in the shell_hook is the
least-invasive local fix.

### 7. R.nvim's `nvim_echo` bug is unfixed upstream (as of writing)

The traceback at `server.lua:34` is a real R.nvim bug (wrong arg shape
for `vim.api.nvim_echo`). With `nvimcom` now installed correctly,
R.nvim shouldn't hit the code path that triggers it, so in practice
you won't see it. But if you ever do see it again, it likely means
something else went wrong earlier in `init_stdout` and R.nvim is
failing to *report* that failure. Check the messages before the
traceback, not the traceback itself. Consider filing / upvoting an
issue on `R-nvim/R.nvim`.

### 7. This is Linux-specific in detail, not in spirit

All the paths and the `x86_64-pc-linux-gnu-library` string in the
original error message are Linux-specific. The same approach works on
macOS — only the `R_LIBS_USER` default path changes. The logic
(`R_LIBS_SITE` survives `rix`'s strip; `R CMD INSTALL` bypasses the
profile override; nvimcom is vendored in the plugin) is
platform-independent.

---

## Going fully pure (optional, more work)

If the caveats above bother you, the next step up is building
`nvimcom` as a proper nix derivation so that it lives in the nix store
alongside `dplyr` and `ggplot2`. Sketch:

1. In `default.nix` (or a small overlay), use
   `pkgs.rPackages.buildRPackage` to build `nvimcom` from source. The
   source can be either:
   - `pkgs.fetchFromGitHub { owner = "R-nvim"; repo = "R.nvim"; rev = ...; sha256 = ...; }` followed by `postUnpack = "sourceRoot=\"$sourceRoot/nvimcom\"";`, or
   - a local path, if you're fine with the build being tied to your
     R.nvim checkout.
2. Add the resulting derivation to `rpkgs`.
3. Delete `.Rlib`, delete the `shellHook`, and delete the `R CMD
   INSTALL` step from your mental workflow.

The cost: you have to hand-write a nix expression that `rix` doesn't
know about, so you lose the "everything is in `generate_env.R`"
property. It becomes a hybrid — `rix`-managed for CRAN packages, plus
a small amount of hand-written nix for the one plugin helper. For a
single-user, single-project setup, the `shellHook` + `R CMD INSTALL`
approach in this doc is usually the better trade-off. For a shared
team setup where everyone expects `nix-shell` to Just Work, the
derivation approach is worth the effort.

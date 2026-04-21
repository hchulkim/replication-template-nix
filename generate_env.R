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
    # Make R.nvim's vendored nvimcom package available without writing
    # to a global R library. rix's .Rprofile strips R_LIBS_USER but
    # leaves R_LIBS_SITE alone.
    export R_LIBS_SITE=\"$PWD/.Rlib:$R_LIBS_SITE\"
    mkdir -p \"$PWD/.Rlib\"
    # Force make to rebuild rnvimserver on every shell entry so its ELF
    # interpreter matches the current shell's glibc (prevents breakage
    # after nix-store --gc if the old glibc path is no longer present).
    rm -f ~/.local/share/nvim/lazy/R.nvim/nvimcom/src/apps/rnvimserver
    R CMD INSTALL --library=\"$PWD/.Rlib\" ~/.local/share/nvim/lazy/R.nvim/nvimcom
  "
)

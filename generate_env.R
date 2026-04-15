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
    # to a global R library. One-time install:
    #   R CMD INSTALL --library=.Rlib \\
    #     ~/.local/share/nvim/lazy/R.nvim/nvimcom
    # rix's .Rprofile strips R_LIBS_USER but leaves R_LIBS_SITE alone.
    export R_LIBS_SITE=\"$PWD/.Rlib:$R_LIBS_SITE\"
  "
)

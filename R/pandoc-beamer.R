#' Function to run pandoc commands from R
#' TODO: allow user to input path to pandoc executable
pandoc <- function(...){
  xargs <- list(...)
  nxargs <- names(xargs)
  nxargs <-ifelse(nxargs == "", "", sprintf("--%s=", nxargs))
  xcmd  <- paste(sprintf('%s%s', nxargs, xargs), collapse = " ")
  system(sprintf('~/.cabal/bin/pandoc %s', xcmd))
}

#' Function to render Rmd file as beamer pdf using pandoc
rmd2beamer <- function(source, ...){
  src <- gsub("^---.*$", '---', readLines(source))
  tf  <- tempfile()
  writeLines(src, tf)
  render_markdown()
  knit_hooks$set(plot = knitr:::hook_plot_tex)
  opts_chunk$set(dev = 'pdf')
  out <- gsub("Rmd", 'md', source)
  knit(tf, out)
  pandoc(out, to = 'beamer', output = gsub("md", 'pdf', out), ...)
}

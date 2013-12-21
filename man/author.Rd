\name{author}
\alias{author}
\title{Author a slide deck}
\usage{
  author(deckdir, use_git = TRUE, open_rmd = TRUE,
    scaffold = system.file("skeleton", package = "slidify"))
}
\arguments{
  \item{deckdir}{path to new slide directory}

  \item{use_git}{whether to initialize directory as git
  repo}

  \item{open_rmd}{whether to open the rmd file created}

  \item{scaffold}{path to directory containing scaffold for
  deck}
}
\description{
  This function creates a slide directory, initializes it
  as a git repo and opens index.Rmd for users to edit.
}


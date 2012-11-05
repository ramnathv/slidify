\name{publish}
\alias{publish}
\title{Publish slide deck}
\usage{
  publish(..., host = "github")
}
\arguments{
  \item{host}{where to publish presentation, Github, RPubs
  or Dropbox}

  \item{...}{parameters to be passed to
  \code{\link{publish_github}}, \code{\link{publish_rpubs}}
  or \code{\link{publish_dropbox}}}
}
\description{
  This function makes it easy to publish your presentation.
  Currently supported hosts include Github, RPubs and
  Dropbox.
}
\seealso{
  Other publish: \code{\link{publish_dropbox}},
  \code{\link{publish_github}}
}


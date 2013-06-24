\name{publish_github}
\alias{publish_github}
\title{Publish slide deck to Github}
\usage{
  publish_github(repo, username = getOption("github.user"))
}
\arguments{
  \item{repo}{github reponame}

  \item{username}{github username}
}
\description{
  You will need \code{git} installed on your computer and a
  \code{github} account. In addition, you will \code{SSH}
  access to \code{github}. See
  \url{https://help.github.com/articles/generating-ssh-keys}
  on how to set up \code{SSH} access
}
\details{
  Login with your github account and create a new
  repository
  \url{https://help.github.com/articles/creating-a-new-repository}.
  Note that Github will prompt you to add a README file,
  but just use the defaults so that your repo is empty. You
  will need to have \code{git} installed on your computer
  and be able to push to \code{github} using SSH
}
\seealso{
  Other publish: \code{\link{publish}},
  \code{\link{publish_dropbox}}
}


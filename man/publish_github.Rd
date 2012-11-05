\name{publish_github}
\alias{publish_github}
\title{Publish slide deck to Github}
\usage{
  publish_github(user, repo)
}
\arguments{
  \item{user}{github username}

  \item{repo}{github reponame}
}
\description{
  \enumerate{
    \item Install \code{git}
    \item Create a \code{github} account
    \item Set up \code{SSH} access. See
  \url{https://help.github.com/articles/generating-ssh-keys}
  }
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


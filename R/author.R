#' Author a slide deck
#'
#' This function creates a slide directory, initializes it as a git repo and
#' opens index.Rmd for users to edit.
#' @param deckdir path to new slide directory
#' @param use_git whether to initialize directory as git repo
#' @param open_rmd whether to open the rmd file created
#' @param scaffold path to directory containing scaffold for deck
#' @export
author <- function(deckdir, use_git = TRUE, open_rmd = TRUE,
    scaffold = system.file('skeleton', package = 'slidify')){
  message('Creating slide directory at ', deckdir, '...')
  #   if (file.exists(deckdir)){
  #     return('Directory already exists. Please choose a different name.')
  #   }
  copy_dir(scaffold, deckdir)
  message('Finished creating slide directory...')
  message('Switching to slide directory...')
  setwd(deckdir)
  if (use_git && Sys.which('git') != ""){
    init_repo()
  }
  if (open_rmd){
    message('Opening slide deck...')
    file.edit('index.Rmd')
  }
}

#' Initialize a git repository, create and switch to gh-pages branch.
#'
#' @keywords internal
#' @noRd
init_repo <- function(){
  message('Initializing Git Repo')
  system("git init")
  system("git commit --allow-empty -m \"Initial Commit\"")
  message("Checking out gh-pages branch...")
  system('git checkout -b gh-pages')
  message('Adding .nojekyll to repo')
  file.create('.nojekyll')
}
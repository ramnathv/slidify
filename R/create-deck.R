#' Initialize a deck given slide directory
#' 
#' @param deck_dir path to presentation directory
create_deck <- function(deck_dir, git = F){
  message('Creating presentation directory ', deck_dir, '...')
  dir.create(deck_dir)
  message('Creating directory assets...')
  assets = file.path(deck_dir, 'assets')
  dir.create(assets, showWarnings = F)
  dir.create(file.path(assets, 'stylesheets'), showWarnings = F)
  dir.create(file.path(assets, 'scripts'), showWarnings = F)
  dir.create(file.path(assets, 'media'), showWarnings = F)
  file.create(file.path(deck_dir, 'index.Rmd'))
  if (git) {
    cwd <- getwd()
    setwd(deck_dir)
    init_repo()
    on.exit(setwd(cwd))
  }
}

#' Initializes a Git Repo in a Directory
#' 
#' @param deck_dir path to presentation directory
init_repo <- function(deck_dir = "."){
  message('Initializing git repository')
  system('git init')
  message('Adding all files')
  system('git add .')
  message('Commiting files to repo')
  system('git commit -m "initial commit"')
}
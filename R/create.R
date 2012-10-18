#' Initialize a slide deck as a git repository
#' 
create_deck <- function(deckdir, git = F){
  message('Creating slide directory at ', deckdir, '...')
  if (file.exists(deckdir)){
  	return('Directory already exists. Please choose a different name.')
  }
  scaffold = system.file('scaffold', package = 'slidify2')
  system(sprintf('cp -r %s %s', scaffold, deckdir))
  if (git == T){
    system("git init")
    system("git commit --allow-empty -m 'Initial Commit'")
    message('Checking out gh-pages branch...')
    system('git checkout -b gh-pages')
  }
  message('Finished creating slide directory')
}

#' Initialize a git repository, create and switch to gh-pages branch.
init_repo <- function(){
	system("git init")
	system("git commit --allow-empty -m 'Initial Commit'")
	message("Checking out gh-pages branch...")
	system('git checkout -b gh-pages')
}
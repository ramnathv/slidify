#' Create skeleton for slide deck
#'
#' The structure of the slides directory is
#' |- assets
#' |---stylesheets
#' |---scripts
#' |---media
#' |- libraries
#' |- slides.Rmd
# TODO: could have a scaffolds directory which can just be copied.
create_skeleton <- function(framework){
  dir.create('assets', showWarnings = F)
  dir.create(file.path('assets', 'stylesheets'), showWarnings = F)
  dir.create(file.path('assets', 'scripts'), showWarnings = F)
  dir.create(file.path('assets', 'media'), showWarnings = F)
  dir.create(file.path('assets', 'templates'), showWarnings = F)
  tpl_files <- list.files(pattern = '*.tpl', full = TRUE, 
    system.file('libraries', framework, package = 'slidify'))
  file.copy(tpl_files, file.path('assets', 'templates'), overwrite = TRUE)
}

#' Copy libraries to slide directory
#' TODO: copy only the required theme and not the entire styles folder
copy_libraries <- function(framework, highlighter, histyle){
  dir.create('libraries', showWarnings = F)
  fr_file <- system.file('libraries', framework, package = 'slidify')
  if (file.exists(fr_file)) {
    file.copy(fr_file, 'libraries', recursive = TRUE)
  }
  hi_file <- system.file('libraries', highlighter, package = 'slidify')
  if (file.exists(hi_file)){
    file.copy(hi_file, 'libraries', recursive = TRUE)
  }  
}

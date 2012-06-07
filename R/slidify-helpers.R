#' Read template based on the framework specified
#'
#' @keywords internal
get_template <- function(framework){
  template <- sprintf("%s.html", framework)
  tfile <- system.file('templates', template, package = 'slidify')
  readLines(tfile)
}

#' Gets content of partials to use in templates
#'
#' @keywords internal
get_partials <- function(){
	pfiles  <- dir(system.file('partials', package = 'slidify'), full = T)
	partials <- llply(pfiles, readLines)
	names(partials) <-  sub(".html", "",  basename(pfiles))
	return(partials)
}

#' Gets user stylesheets and scripts to link
#'
#' @keywords internal
get_user_files <- function(){
  user_css <- dir(file.path('assets', 'stylesheets'), full = T)
  user_js  <- dir(file.path('assets', 'scripts'), full = T)
  list(user_css = user_css, user_js = user_js)
}


#' Create skeleton for slide deck
#'
#' The structure of the slides directory is
#' |- assets
#' |---stylesheets
#' |---scripts
#' |---media
#' |- libraries
#' |- slides.Rmd
create_skeleton <- function(){
  dir.create('assets', showWarnings = F)
  dir.create(file.path('assets', 'stylesheets'), showWarnings = F)
  dir.create(file.path('assets', 'scripts'), showWarnings = F)
  dir.create(file.path('assets', 'media'), showWarnings = F)
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

get_contents <- function(files){
  contents = llply(files, readLines)
  capture.output(do.call('cat', contents))
}

#' Remove hidden slides marked with the class "hidden"
#' Thanks to Kohske
remove_hidden_slides <- function(slides){
	slide_classes = lapply(slides, function(x) x$classes)
	hidden_slides = grep('hidden', slide_classes)
	if (length(hidden_slides) > 0){
	  slides[-hidden_slides]
	} else {
	  slides
	}
}

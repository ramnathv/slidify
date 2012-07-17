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
	partials <- lapply(pfiles, readLines)
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

get_contents <- function(files){
  contents = lapply(files, readLines)
  capture.output(do.call('cat', contents))
}

#' Function to get configuration for slide generation
get_deck_options <- function(options){
  deck <- slidifyDefaults()
  if (!is.null(options)){
    if (is.list(options)){
      deck <- modifyList(deck, options)
    } else if(file.exists(options)){
      deck <- modifyList(deck, yaml::yaml.load_file(options))
    } else if(file.exists('slidify.yml')){
      deck <- modifyList(deck, yaml::yaml.load_file('slidify.yml'))
    }
  }
  return(deck)
}
#' Create skeleton for slide deck
#'
#' The structure of the slides directory is
#' |- assets
#' |---css
#' |---img
#' |---js
#' |- layouts
#' |- libraries
#' |- slides.Rmd
# TODO: could have a scaffolds directory which can just be copied.
# TODO: How should overwriting be handled? NEVER!
create_skeleton <- function(framework, show_w = F){
	dir.create('assets', showWarnings = show_w)
	dir.create(file.path('assets', 'css'), showWarnings = show_w)
	dir.create(file.path('assets', 'js'), showWarnings = show_w)
	dir.create(file.path('assets', 'img'), showWarnings = show_w)
	dir.create('layouts', showWarnings = F)
}
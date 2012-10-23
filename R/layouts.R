#' Read layout files 
#' 
#' @param path path to directory containing layout files
#' @return named list of layouts
#' @keywords internal
read_layouts <- function(path){
  files = dir(path, pattern = '*.html', full = T)
  setNames(
    lapply(files, read_file),
    gsub(".html", '', basename(files), fixed = TRUE)
  )
}

#' Expand child layouts
#'
#' @param layouts layout to be expanded
#' @return named list of expanded layouts
#' @keywords internal
expand_layouts <- function(layouts){
  #' Expand a child layout 
  expand_layout <- function(layout){
    mpat <- "^---\nlayout\\s*: ([[:alnum:]]+)\n---\n(.*)$"
    has_parent <- grepl(mpat, layout)
    if (has_parent){
       main <- layouts[[gsub(mpat, '\\1', layout)]]
       content <- gsub(mpat, "\\2", layout)
       layout <- sub("{{{ content }}}", content, main, fixed = TRUE)
     }
    return(layout)
  }
  lapply(layouts, expand_layout)
}

#' Get layouts from list of paths provided
#'
#' @paths list of paths to directories containing layout files
get_layouts <- function(paths){
  layouts = Reduce('modifyList', lapply(paths, read_layouts))
  for (i in 1:3) {
    layouts = expand_layouts(layouts)
  }
  layouts
}

#' Get default slide layout for a framework
get_slide_layout <- function(framework){
	l_file = system.file('libraries', 'frameworks', framework, 'layouts', 
											 'slide.html', package = 'slidify')
	cat(slidify:::read_file(l_file))
}

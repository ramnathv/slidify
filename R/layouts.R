#' Read layout files 
#' 
#' @param path path to directory containing layout files
#' @return named list of layouts
#' @keywords internal
#' @noRd
read_layouts <- function(path){
  files = dir(path, pattern = '*.html', full.names = T)
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
#' @noRd
expand_layouts <- function(layouts){
  #' Expand a child layout 
  expand_layout <- function(layout){
    mpat <- "^---\nlayout\\s*: ([[:alnum:]]+)\n---\n(.*)$"
    has_parent <- grepl(mpat, layout)
    if (has_parent){
       main <- layouts[[gsub(mpat, '\\1', layout)]]
       content <- gsub(mpat, "\\2", layout)
       layout <- sub("{{{ slide.content }}}", content, main, fixed = TRUE)
     }
    return(layout)
  }
  lapply(layouts, expand_layout)
}

#' Expand child layouts
#'
#' Provides more control over what element to replace inside the parent layout.
#' @param layouts layout to be expanded
#' @return named list of expanded layouts
#' @keywords internal
#' @noRd
expand_layout2 <- function(layout, layouts){
  has_parent <- grepl("^---", layout)
  if (has_parent){
    txt = str_split_fixed(layout, '\n---', 2)
    meta = yaml.load(gsub("^---\n+", '', txt[1]))
    pattern = paste("{{{", meta$replace, '}}}')
    replacement = layouts[meta$layout]
    layout <- sub(pattern, replacement, txt[2], fixed = TRUE)
  }
  return(layout)
}

#' Get layouts from list of paths provided
#'
#' @param paths list of paths to directories containing layout files
#' @keywords internal
#' @noRd
get_layouts <- function(paths){
  layouts = Reduce('modifyList', lapply(paths, read_layouts))
  for (i in 1:3) {
    layouts = expand_layouts(layouts)
  }
  layouts
}

#' Get default slide layout for a framework
#' 
#' @noRd
# TODO: Move this to slidifyLibraries
get_slide_layout <- function(framework){
  l_file = system.file('libraries', 'frameworks', framework, 'layouts', 
   'slide.html', package = 'slidifyLibraries')
  cat(slidify:::read_file(l_file))
}

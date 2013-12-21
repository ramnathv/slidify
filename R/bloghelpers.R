#' Get pages by tags
#' 
#' @noRd
get_tags <- function(pages){
  get_pages_by_groups(pages, gby = 'tags')
}

#' Get pages by categoris
#' 
#' @noRd
get_categories <- function(pages){
  get_pages_by_groups(pages, gby = 'categories')
}

#' Get pages by group
#'
#' @noRd
get_pages_by_groups <- function(pages, gby = 'tags'){
  get_pages_by_group = function(g){
    p = pages[sapply(pages, function(page) g %in% page[[gby]])]
    p = lapply(p, '[', c('title', 'file', 'date', 'link'))
    list(pages = p, name = g, count = length(p))
  }
  get_all_groups <- function(){
    g = lapply(pages, '[[', gby)
    Reduce('union', g)
  }
  x  = lapply(get_all_groups(), get_pages_by_group)
  y = setNames(x, lapply(x, pluck('name')))
  y$all = x
  y
}

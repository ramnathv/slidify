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

sort_posts_on_date <- function(posts){
  dates = sapply(posts, '[[', 'date')
  idx = rev(sort(dates, index.return = TRUE)$ix)
  return(posts[idx])
}

add_next_post <- function(posts){
  posts_ = list()
  for (i in 1:(length(posts) - 1)){
    post_ = posts[[i]]
    post_[['next']] = posts[[i + 1]][c('title', 'link', 'image', 'quote')]
    post_[['next']]['image'] = paste(
      "", dirname(post_[['next']]$link), post_[['next']]$image, sep = '/'
    )
    post_[['next']]$link = paste0("/", post_[['next']]$link)
    posts_[[i]] = post_
  }
  return(c(posts_, posts[length(posts)]))
}

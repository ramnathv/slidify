pagify <- function(postFile){
  if (file.exists('site.yml')){
    site = yaml.load_file('site.yml')
  } else {
    site = list(x = 10)
  }
  page = parse_page(postFile)
  in_dir(dirname(postFile), {
    render_page(page, payload = list(site = site))
  })
}

blogify <- function(blogDir = "."){
  site = yaml.load_file('site.yml')
  cwd   = getwd(); on.exit(setwd(cwd))
  setwd(blogDir)
  rmdFiles = dir(".", recursive = TRUE, pattern = '*.Rmd')
  pages = parse_pages(rmdFiles)
  tags = get_tags(pages)
  render_pages(pages, site, tags)
  message('Blogification Successful :-)')
}

parse_page <- function(postFile){
  in_dir(dirname(postFile), {
    inputFile = basename(postFile)
    opts_chunk$set(fig.path = "assets/fig/", cache.path = '.cache/', cache = TRUE)
    outputFile <- gsub(".Rmd", ".md", inputFile)
    post = knit(inputFile, outputFile) %|% parse_deck
    post$file = postFile
    post$filename = tools:::file_path_sans_ext(inputFile)
    if (!is.null(post$date)) {
      post$date = as.Date(post$date, '%Y-%m-%d')
    }
    post$link = gsub("*.Rmd", ".html", post$file)
    post$raw = read_file(inputFile)
  })
  return(post)
}

parse_pages <- function(postFiles){
  lapply(postFiles, parse_page)
}

#' Get pages by tags
get_tags <- function(pages){
  get_pages_by_groups(pages, gby = 'tags')
}

get_categories <- function(pages){
  get_pages_by_groups(pages, gby = 'categories')
}

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

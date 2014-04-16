#' Convert an Rmd document into HTML5
#'
#' @param inputFile path to the Rmd file to slidify
#' @param knit_deck whether the file needs to be run through knit
#' @param return_page should the function return the payload
#' @param save_payload should the payload be saved to the slide directory
slidify <- pagify <- function(inputFile, knit_deck = TRUE,
  return_page = FALSE, save_payload = FALSE, envir = parent.frame()){

  ## REMOVE LINES AFTER KNITR IS UPDATED ------
  options('knitr.in.progress' = TRUE)
  on.exit(options('knitr.in.progress' = FALSE))
  ## -------------------------------------------

  .SLIDIFY_ENV <<- new.env()
  site = ifelse(file.exists('site.yml'), yaml.load_file('site.yml'), list())
  page = parse_page(inputFile, knit_deck, envir = envir)

  page = modifyList(page, as.list(.SLIDIFY_ENV))
  render_page(page, payload = list(site = site), return_page, save_payload)
}

#' Convert a directory of Rmd documents into HTML5
#'
#' @noRd
blogify <- function(blogDir = "."){
  site = yaml.load_file('site.yml')
  cwd   = getwd(); on.exit(setwd(cwd))
  setwd(blogDir)
  rmdFiles = dir(".", recursive = TRUE, pattern = '*.[r|R]md')
  pages = parse_pages(rmdFiles)
  tags = get_tags(pages)
  render_pages(pages, site, tags)
  message('Blogification Successful :-)')
}


#' Convert an Rmd document into HTML5 using a framework
#'
#' @param inputFile path to input Rmd document
#' @param outputFile path to output html document; default uses inputFile
#' @param knit_deck should the input file be knit?; default is TRUE
#' @return path to outputFile
#' @seealso slidify-package
#' @export
#  This function has been replaced by pagify and needs to be DEPRECATED
#  It would be good to specify slidify as an alias to maintain compatibility
# slidify <- function(inputFile, outputFile, knit_deck = TRUE){
#   if (knit_deck == TRUE){
#     inputFile = inputFile %|% knit
#   }
#   deck = inputFile %|% parse_deck
#
#   if (deck$mode == 'selfcontained'){
#     deck$url[['lib']] <- deck$url[['lib']] %||% 'libraries'
#     with(deck, copy_libraries(framework, highlighter, widgets, url$lib))
#   }
#
#   # add layouts, urls and stylesheets from frameworks, widgets and assets
#   deck = deck %|% add_urls %|% add_stylesheets %|% add_config_fr
#   layouts = get_layouts(deck$url$layouts)
#   layouts = modifyList(layouts, list(javascripts = get_javascripts(deck)))
#
#   if (missing(outputFile)){
#     outputFile = gsub("*.[R]?md$", '.html', inputFile)
#   }
#
#   cat(render_deck(deck, layouts), file = outputFile)
#
#   if (deck$mode == 'standalone'){
#     outputFile = make_standalone(deck, outputFile)
#   }
#
#   return(outputFile)
# }

check_slidifyLibraries <- function(){
  if (require('slidifyLibraries') && packageVersion('slidifyLibraries') <= 0.3){
    stop("Stop! You need to update slidifyLibraries")
  }
  return(invisible())
}

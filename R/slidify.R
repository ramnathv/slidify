#' Convert an Rmd document into HTML5 using a framework
#' 
#' @param inputFile path to input Rmd document
#' @param outputFile path to output html document; default uses inputFile
#' @param knit_deck should the input file be knit?; default is TRUE
#' @return path to outputFile
#' @seealso slidify-package
#' @export
slidify <- function(inputFile, outputFile, knit_deck = TRUE){
  if (knit_deck == TRUE){
    inputFile = inputFile %|% knit
  }
  deck = inputFile %|% parse_deck
  
  if (deck$mode == 'selfcontained'){
    deck$url[['lib']] <- deck$url[['lib']] %||% 'libraries'
    with(deck, copy_libraries(framework, highlighter, widgets, url$lib))
  }
  
  # add layouts, urls and stylesheets from frameworks, widgets and assets
  deck = deck %|% add_urls %|% add_stylesheets %|% add_config_fr
  layouts = get_layouts(deck$url$layouts)
  layouts = modifyList(layouts, list(javascripts = get_javascripts(deck)))
  
  if (missing(outputFile)){
    outputFile = gsub("*.[R]?md$", '.html', inputFile)
  }
  
  cat(render_deck(deck, layouts), file = outputFile)
  
  if (deck$mode == 'standalone'){
    outputFile = make_standalone(deck, outputFile)
  }
  
  return(outputFile)
}

#' Create a standalone version of an HTML File
#' 
#' It works by embedding all images, switching links to use Slidify's googlecode
#' repository and inlining all user assets.
#' 
#' @param deck parsed deck
#' @param html_in html file with library files linked locally
#' @noRd
#' @keywords internal
make_standalone <- function(deck, html_in){
  lib_url = paste0(deck$url$lib, '/')
  lib_cdn = 'http://slidifylibraries.googlecode.com/git/inst/libraries/'
  html = read_file(html_in, warn = FALSE) %|% markdown:::.b64EncodeImages
  html = gsub(lib_url, lib_cdn, html)
  # html_out = sprintf('%s.html', basename(getwd()))
  cat(html, file = html_in)
  return(html_in)
}

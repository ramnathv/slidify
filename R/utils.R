#' Run a slide Deck
runDeck <- function(deckDir = ".", appDir = file.path(deckDir, "apps"), 
  shiny = TRUE, ...){
  require(shiny)
  require(slidifyLibraries)
  .slidifyEnv = new.env()
  make_interactive()
  myDeckDir = file.path(deckDir, "libraries")
  if (!file.exists(myDeckDir)){
    dir.create(myDeckDir)
  }
  addResourcePath('libraries', file.path(deckDir, "libraries"))
  addResourcePath('assets', file.path(deckDir, "assets"))
  
  deckDir = normalizePath(deckDir)
  if (file.exists(appDir)){
    appDir  = normalizePath(appDir)
  }
  
  render_markdown()
  
  shiny::runApp(list(
    ui = includeDeck(file.path(deckDir, 'index.Rmd')), 
    server = function(input, output){
      apps = dir(appDir, pattern = '^app', full = T)
      for (app in apps){
        source(app, local = TRUE)
      }
      if (shiny){
        renderCodeCells(input, output, env = .slidifyEnv, deckDir)
      }
    }
  ), ...)
}

#' Include a slidify created html document in Shiny
#' @noRd
includeDeck <- function(path){
  shiny:::dependsOnFile(path)
  slidifyLibraries::make_interactive()
  slidify(path)
  html_file <- gsub('.Rmd$', '.html', path)
  lines <- c(
    readLines(html_file, warn=FALSE, encoding='UTF-8'),
    "<script type='text/javascript'>
      // snippet required to activate shiny outputs, since slides are hidden
    // thanks to @jcheng
    $('slide').on('slideenter', function(){
      $(this).trigger('shown');
    })
    </script>"
  )
  return(HTML(paste(lines, collapse='\r\n')))
  # includeHTML(html_file)
}

#' Check for equality only if variable exists
#' 
#' @noRd
`%?=%` <- function(x, y){
  if (!is.null(x) && x == y){
    TRUE
  } else {
    FALSE
  }
}

#' Embed local images using base64
#'
#' @keywords internal
#' @param html_in path to input html file
#' @param html_out path to output html file
#' @noRd
embed_images <- function(html_in){
  html <- paste(readLines(html_in, warn = F), collapse = "\n")
  html <- markdown:::.b64EncodeImages(html)
  return(html)
}

#' Enable library files to be served from CDN
#' 
#' @noRd
enable_cdn <- function(html){
  cdn  = 'http://slidifylibraries2.googlecode.com/git/inst/libraries/'
  html = gsub("libraries/", cdn, html, fixed = TRUE)
}

#' Zip vectors into a single list
#' 
#' @noRd
zip_vectors <- function(...){
  x = list(...)
  lapply(seq_along(x[[1]]), function(i) lapply(x, pluck(i)))
}

#' Stolen from Hadley's HOF package
#' 
#' @keywords internal
#' @noRd
pluck <- function (element){
  function(x) x[[element]]
}

#' Combine stylesheets in a directory
#' 
#' @param css_dir directory containing stylesheets
#' @noRd
combine_css <- function(css_dir){
  css_files = dir(css_dir, pattern = '*.css', full.names = T)
  out_file = file.path(css_dir, 'user.css')
  css = paste(lapply(css_files, read_file), collapse = '\n')
  writeLines(css, out_file)
  return(out_file)
}

#' Minify stylesheet using YUI Compressor
#' 
#' @param css_file path to css file
#' @noRd
minify_css <- function(css_file){
  yui = system.file('libraries', 'utilities', 'yuicompressor-2.4.7.jar', 
    package = 'slidifyLibraries')
  min_css_file = gsub('.css', '.min.css', css_file)
  cmd = 'java -jar %s %s -o %s' 
  system(sprintf(cmd, yui, css_file, min_css_file))
  return(min_css_file)
}

#' Binary operator useful for function composition
#' 
#' @keywords internal
#' @noRd
`%|%` <- function(x, f){
  f(x)
}

#' Binary operator useful from hadley's staticdocs package
#' 
#' @keywords internal
#' @noRd
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}


#' Read a text file into a single string
#' 
#' @param doc path to text document
#' @return string with document contents
#' @keywords internal
#' @noRd
read_file <- function(doc, ...){
  paste(readLines(doc, ...), collapse = '\n')
}

#' Capture patterns matched by regular expression
#'
#' @keywords internal
#' @noRd
re_capture <- function(pattern, string, ...) {
  rex = list(src = string, names  = list(),
    result = regexpr(pattern, string, perl = TRUE, ...))
  
  for (.name in attr(rex$result, 'capture.name')) {
    rex$names[[.name]] = substr(rex$src, 
      attr(rex$result, 'capture.start')[,.name], 
      attr(rex$result, 'capture.start')[,.name]
      + attr(rex$result, 'capture.length')[,.name]
      - 1)
   }
  return(rex)
}

#' Convert markdown document into html
#' 
#' @import markdown
#' @keywords internal
#' @noRd
md2html <- function(md){
  renderMarkdown(text = md, renderer.options = markdownExtensions())
}

#' Merge two lists by name
#'
#' This is a method that merges the contents of one list with another by 
#' adding the named elements in the second that are not in the first. 
#' In other words, the first list is the target template, and the second 
#' one adds any extra elements that it has
#'
#' @param x the list to which elements will be added
#' @param y the list from which elements will be added to x, if they are not 
#'    already there by name
#' @keywords internal
#' @noRd
merge_list <- function (x, y, ...){
  if (length(x) == 0) 
    return(y)
  if (length(y) == 0) 
    return(x)
  i = match(names(y), names(x))
  i = is.na(i)
  if (any(i)) 
    x[names(y)[which(i)]] = y[which(i)]
  return(x)
}

#' Filter blanks 
#' 
#' @keywords internal
#' @noRd
filter_blank <- function(x){
  Filter(function(y) y != '', x)
}

#' Check if a package is installed
#' 
#' @noRd
is_installed <- function(mypkg) {
  is.element(mypkg, installed.packages()[,1]) 
}

#' Execute code in  specified directory
#' 
#' @noRd
in_dir <- function(dir, expr) {
  if (is.null(getOption('slidify.changedir'))){
     owd = setwd(dir); on.exit(setwd(owd))
  }
  force(expr)
}

#' Multiple substitutions using gsub
#' 
#' @noRd
#' @keywords internal
mgsub <- function(myrepl, mystring){
  gsub_ <- function(l, x){
    do.call('gsub', list(x = x, pattern = l[1], replacement = l[2]))
  }
  Reduce(gsub_, myrepl, init = mystring, right = T) 
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
  lib_cdn = paste0(deck$lib_cdn %||% 'http://slidifylibraries2.googlecode.com/git/inst/libraries', '/')
  lib_url = paste0(deck$url$lib, '/')
  html = read_file(html_in, warn = FALSE) %|% markdown:::.b64EncodeImages
  html = gsub(lib_url, lib_cdn, html)
  # html_out = sprintf('%s.html', basename(getwd()))
  cat(html, file = html_in)
  return(html_in)
}


#' Get the rmd source for each slide
#' 
#' @keywords internal
#' @noRd
#  Still repeats code and is hence not DRY
get_slide_rmd <- function(doc){
  paste('---', (doc %|% to_deck)$slides %|% split_slides)
}

#' Combine two lists, component by component
#' 
#' @keywords internal
#' @noRd
combine_lists <- function(x, y){
  nms = union(names(x), names(y))
  lapply(nms, function(nm){c(x[[nm]], y[[nm]])
  })
}

view_deck <- function(dir = "."){
  td <- file.path(tempdir(), basename(tempfile(pattern = 'slidify')))
  suppressMessages(copy_dir(".", td))
  tf <- file.path(td, 'index.html')
  rstudio::viewer(tf)
}

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
	cdn  = 'http://slidify.googlecode.com/git/inst/libraries/'
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
	css_files = dir(css_dir, pattern = '*.css', full = T)
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
		package = 'slidify2')
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
read_file <- function(doc){
	paste(readLines(doc), collapse = '\n')
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
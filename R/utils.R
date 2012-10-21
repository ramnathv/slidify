#' Zip vectors into a single list
#' 
#' zip_vectors(name = c('John', 'Jane'), age = c(20, 30))
zip_vectors <- function(...){
  x = list(...)
  lapply(seq_along(x[[1]]), function(i) lapply(x, pluck(i)))
}

#' Stolen from Hadley's HOF package
pluck <- function (element){
  function(x) x[[element]]
}

#' Combine stylesheets in a directory
#' 
#' @param css_dir directory containing stylesheets
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
minify_css <- function(css_file){
	yui = system.file('libraries', 'utilities', 'yuicompressor-2.4.7.jar', 
		package = 'slidify2')
	min_css_file = gsub('.css', '.min.css', css_file)
	cmd = 'java -jar %s %s -o %s' 
	system(sprintf(cmd, yui, css_file, min_css_file))
}

#' Binary operator useful for function composition
#'
`%|%` <- function(x, f){
	f(x)
}

#' Binary operator useful from hadley's staticdocs package
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}

#'
#  from hadley's httr package
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}

#' Read a text file into a single string
#' 
#' @param doc path to text document
#' @return string with document contents
#' @keywords internal
read_file <- function(doc){
	paste(readLines(doc), collapse = '\n')
}

#' Capture patterns matched by regular expression
#'
#' @keywords internal
#  TODO: Add reference to blog from which this was copied
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
#  TODO: Use config file to override markdown options
#  EXAMPLE:
#  markdown:
#    hardwrap: true
#  BUG: renderer.options are incorrectly specified.
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
filter_blank <- function(x){
	Filter(function(y) y != '', x)
}
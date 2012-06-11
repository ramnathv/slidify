embed_images <- function(html_in, html_out){
  html <- paste(readLines(html_in), collapse = "\n")
  html <- markdown:::.b64EncodeImages(html)
  writeLines(html, html_out)
}

# @TODO: Add attribution to original author.
make_id <- function(n = 1, length = 4){
	randomString <- c(1:n)            
	for (i in 1:n){
		randomString[i] <- paste(sample(c(0:9, letters, LETTERS),
		 length, replace=TRUE), collapse="")
	}
	return(randomString)
}

slidifyOptions <- function(){
  list(framework = 'html5slides', highlighter = 'highlight', theme = 'web-2.0', 
    transition = 'horizontal-slide', histyle = 'acid', copy_libraries = FALSE, 
    lib_path = system.file('libraries', package = 'slidify'), 
    layout = 'layout-regular', template = 'template-default', mathjax = TRUE,
    embed = FALSE, title = NULL)
}


# .onLoad <- function(libname, pkgname){
#   if (is.null(getOption('slidify.options'))){
#     options(slidify.options = slidifyOptions())
#   }
# }

add_theme <- function(theme){
  css_file <- system.file('themes', sprintf('%s.css', theme), package = 'knitr')
  css_doc  <- highlight::css.parser(css_file)
  bgcol    <- css_doc$background$color
  fgcol    <- css_doc$prompt$color
  tem_file <- 'inst/templates/highlight.css'
  template <- readLines(tem_file)
  theme_file <- sprintf("inst/libraries/highlight/styles/%s.css", theme)
  file.copy(css_file, theme_file)
  cat(whisker.render(template), file = theme_file, append = TRUE)
}

# TODO: Add attribtion
re.capture <- function(pattern, string, ...) {
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

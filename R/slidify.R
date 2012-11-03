#' Convert an Rmd document into HTML5 using a framework
#' 
#' @param inputFile path to input Rmd document
#' @param outputFile path to output html document; default uses inputFile
#' @param knit_deck should the input file be knit?; default is TRUE
#' @return path to outputFile
#' @export
slidify <- function(inputFile, outputFile, knit_deck = TRUE){
	if (knit_deck == TRUE){
		inputFile = inputFile %|% knit
	}
	deck = inputFile %|% parse_deck
	
	if (deck$mode == 'selfcontained'){
		with(deck, copy_libraries(framework, highlighter, widgets))
		deck$url[['lib']] <- 'libraries'
	}
	
	# add layouts, urls and stylesheets from frameworks, widgets and assets
	deck = deck %|% add_urls %|% add_stylesheets
	layouts = get_layouts(deck$url$layouts)
	layouts = modifyList(layouts, list(javascripts = get_javascripts(deck)))
	
	if (missing(outputFile)){
		outputFile = gsub("*.[R]?md$", '.html', inputFile)
	}
	
	if (deck$mode == 'standalone'){
		deck$url[['lib']] = 'http://slidify.googlecode.com/git/inst/libraries'
		deck = deck %|% add_urls 
		tfile = tempfile(pattern = '.html')
		cat(render_deck(deck, layouts), file = tfile)
		cat(tfile %|% embed_images, file = outputFile)
	} else {
		cat(render_deck(deck, layouts), file = outputFile)
	}

	return(outputFile)
}

.onLoad <- function(libname, pkgname){
	options(rstudio.markdownToHTML = 
		function(inputFile, outputFile) {      
		  require(slidify)
			slidify(inputFile, outputFile, knit_deck = FALSE)
	})
}
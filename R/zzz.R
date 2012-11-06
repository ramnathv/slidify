.onLoad <- function(libname, pkgname){
	options(rstudio.markdownToHTML = 
		function(inputFile, outputFile) {      
			slidify(inputFile, outputFile, knit_deck = FALSE)
	})
}
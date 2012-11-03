.onLoad <- function(libname, pkgname){
	options(rstudio.markdownToHTML = 
		function(inputFile, outputFile) {      
		  require(slidify)
			slidifyRpubs(inputFile, outputFile)
	})
}
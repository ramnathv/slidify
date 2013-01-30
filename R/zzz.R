.onLoad <- function(libname, pkgname){
  options(rstudio.markdownToHTML =    
    function(inputFile, outputFile) {      
      if (readLines(inputFile)[1] == '---'){
        slidify(inputFile, outputFile, knit_deck = FALSE)
      } else {
        require(markdown)
        markdownToHTML(inputFile, outputFile)   
      }
  })
}

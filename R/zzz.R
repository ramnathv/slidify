.onLoad <- function(libname, pkgname){
  options(rstudio.markdownToHTML = function(inputFile, outputFile){
    if (readLines(inputFile)[1] == '---'){
      slidify(inputFile, knit_deck = FALSE)
    } else {
      markdownToHTML(inputFile, outputFile)
    }
  })
}

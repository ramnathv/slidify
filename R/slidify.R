slidify <- function(inputFile, outputFile, knit_deck = T){
	# knit input file if knit_deck is TRUE
  if (knit_deck){
    inputFile = inputFile %|% knit
  }
  
  # split deck into metadata and slides, copying libraries if indicated
  deck = inputFile %|% to_deck 
  if (deck$copy_libraries){
  	with(deck, copy_libraries(framework, highlighter, widgets))
  }
  
  # split slides, parse into elements and add slide numbers and ids
  deck$slides = deck$slides %|% split_slides %|% parse_slides 
  deck$slides = deck$slides %|% add_slide_numbers %|% add_missing_id
  
  # add layouts, urls and stylesheets from frameworks, widgets and assets
  deck = deck %|% add_urls %|% add_stylesheets
  layouts = get_layouts(deck$url$layouts)
  layouts = modifyList(layouts, list(javascripts = get_javascripts(deck)))
  
 
  
  if (missing(outputFile)){
    outputFile = gsub("*.[R]?md$", '.html', inputFile)
  }
  
  cat(render_deck(deck, layouts), file = outputFile)
  return(outputFile)
}

  
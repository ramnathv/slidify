slidify <- function(inputFile, outputFile, knit_deck = T){
  if (knit_deck){
    inputFile = inputFile %|% knit
  }
  deck = inputFile %|% to_deck 
  if (deck$copy_libraries){
  	with(deck, copy_libraries(framework, highlighter, widgets))
  }
  deck = deck %|% add_urls %|% add_stylesheets
  deck$slides = deck$slides %|% split_slides %|% parse_slides 
  layouts = get_layouts(deck$url$layouts)
  layouts = modifyList(layouts, list(javascripts = get_javascripts(deck)))
  if (missing(outputFile)){
    outputFile = gsub("*.[R]?md$", '.html', inputFile)
  }
  deck$slides = deck$slides %|% add_slide_numbers %|% add_missing_id
  cat(render_deck(deck, layouts), file = outputFile)
  return(outputFile)
}

  
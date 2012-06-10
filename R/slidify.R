slidify2 <- function(config_file){
	require(yaml)
	config <- yaml.load_file(config_file)
	do.call('slidify', config)
}

#' Generate Reproducible HTML5 Slides from R Markdown Files
#'
#' @export
#' @import knitr 
#' @import whisker
#' @importFrom plyr llply
slidify <- function(source, destination, options = slidifyOptions()){
	deck <- as.list(options)
  # CREATE SKELETON AND COPY LIBRARIES IF COPY_LIBRARIES IS TRUE
  create_skeleton()
  if (deck$copy_libraries){
    with(deck, copy_libraries(framework, highlighter, histyle))
    deck$lib_path <- 'libraries'
  }
  
	if (deck$highlighter == 'highlight'){
	  render_html()
	} else {
	  render_markdown(strict = TRUE)
	}
  
  # KNIT SOURCE FILE AND PARSE SLIDES  
  md_file  <- knit(source)                              
  slides   <- llply(doc_to_slides(md_file), parse_slide)
  slides   <- remove_hidden_slides(slides)           
  slides   <- add_slide_numbers(slides)
  slides   <- add_raw_rmd(slides, source)
  
  deck$num_slides <- length(slides)
  
  deck <- modifyList(deck, get_user_files())
  deck <- modifyList(deck, list(slides = slides))
  deck <- modifyList(deck, 
	  list(highlight_js = (deck$highlighter == 'highlight.js')))
	  
	if (deck$embed){
	  deck$user_css = get_contents(deck$user_css)
	  deck$lib_path = 'http://slidify.googlecode.com/git/inst/libraries'
	}
	
  # GET PARTIALS AND TEMPLATES
	partials <- get_partials()
	template <- get_template(deck$framework)
	html_file <- if (missing(destination)) {
	  destination = gsub("\\.Rmd", "\\.html", source)
	}
	writeLines(whisker.render(template, deck, partials = partials), destination)
	if (deck$embed){
	  embed_images(destination, destination)
	}
	return(invisible(deck))
}











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
slidify <- function(source, destination, options = NULL){
  deck <- get_deck_options(options)
  # CREATE SKELETON AND COPY LIBRARIES IF COPY_LIBRARIES IS TRUE
  create_skeleton(deck$framework)
  if (deck$copy_libraries){
    with(deck, copy_libraries(framework, highlighter, histyle))
    deck$lib_path <- 'libraries'
  }
  
  if (deck$highlighter == 'highlight'){
    render_html()
    pat_md()
    opts_knit$set(out.format = 'html')
    opts_chunk$set(highlight = TRUE)
  } else {
    render_markdown(strict = TRUE)
    knit_hooks$set(plot = knitr:::hook_plot_html)
  }
  
  # KNIT SOURCE FILE AND PARSE SLIDES  
  md_file  <- knit(source)                              
  slides   <- lapply(doc2slides(md_file), parse_slide)
  slides   <- remove_hidden_slides(slides)           
  slides   <- add_slide_numbers(slides)
  slides   <- add_missing_id(slides)
  slides   <- add_raw_rmd(slides, source)
  slides   <- lapply(slides, render_slide)
  
  deck$num_slides <- length(slides)
  
  deck <- modifyList(deck, get_user_files())
  deck <- modifyList(deck, list(slides = slides))
  deck$highlight_js = (deck$highlighter == 'highlight.js')
  deck$google_prettify = (deck$highlighter == 'google_prettify')
    
  if (deck$embed){
    deck$user_css = get_contents(deck$user_css)
    deck$lib_path = 'http://slidify.googlecode.com/git/inst/libraries'
  }
  
  # if no title has been specified, use the first slide as title
  if (is.null(deck$title)){
    deck$title = deck$slides[[1]]$title
  }
  
  # GET PARTIALS AND TEMPLATES
  partials <- get_partials()
  # template <- get_template(deck$framework)
  template <- readLines(file.path('assets', 'templates', 'deck.tpl'))
  html_file <- if (missing(destination)) {
    destination = gsub("\\.Rmd", "\\.html", source)
  }
  writeLines(whisker.render(template, deck, partials = partials), destination)
  if (deck$embed){
    embed_images(destination, destination)
  }
  return(invisible(deck))
}

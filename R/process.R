#' Knit deck to markdown
#'
#' @keywords internal
knit_deck <- function(deck){
  render_markdown(strict = TRUE)
  knit_hooks$set(plot = knitr:::hook_plot_html)
  deck$slides = knit(text = deck$slides)
  return(invisible(deck))
}

#' Split document into metadata and slides
#' 
#' @param doc path to source file
#' @return list with metadata and slides
#' @keywords internal
to_deck <- function(doc){
  txt = str_split_fixed(read_file(doc), '\n---', 2)
  meta = yaml.load(gsub("^---\n+", '', txt[1]))
  deck = modifyList(slidifyDefaults(), c(meta, slides = txt[2]))
  if (deck$copy_libraries){
  	opts$url[['lib']] <- 'libraries'
  }
  return(deck)
}

#' Split slides into individual slides
#'
#' Slides are separated by a newline followed by three horizontal dashes.
#' An empty new line SHOULD precede the three horizontal dashes, otherwise
#' it will not be treated as a slide separator
#' @keywords internal
split_slides <- function(slides, pat = '\n\n---'){
  str_split(slides, pattern = pat)[[1]]
}

#' Parse slides into constitutent elements
#'
#' @keywords internal
parse_slides <- function(slides){
  lapply(slides, parse_slide)
}

#' Get the rmd source for each slide
#' TODO: Still repeats code and is hence not DRY
get_slide_rmd <- function(doc){
  paste('---', (doc %|% to_deck)$slides %|% split_slides)
}



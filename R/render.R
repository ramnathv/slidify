#' Render deck using layouts
#  TODO: Consider renaming tpl to layout. Check for conflicts.
render_deck <- function(deck, layouts){
  #' Render a slide based on specified layout
  render_slide <- function(slide){
    tpl <- slide$tpl %||% 'slide'
    slide$rendered = whisker.render(layouts[tpl], slide) %|% update_classes
    return(slide)
  }
  #' Render slides based on specified layouts
  render_slides <- function(slides){
    lapply(slides, render_slide)
  }
  #' Render deck
  deck$slides = deck$slides %|% render_slides
  main = deck$layout %||% 'deck'
  whisker.render(layouts[[main]], deck, partials = layouts)
}

#' Parse deck into metdata and slide elements
parse_deck <- function(inputFile){
	deck = inputFile %|% to_deck 
	deck$slides = deck$slides %|% split_slides %|% parse_slides  
	deck$slides = deck$slides %|% add_slide_numbers %|% add_missing_id
	return(deck)
}

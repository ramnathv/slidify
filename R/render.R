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


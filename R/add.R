#' Add slide numbers to the slides
#'
#' @keywords internal
#' @noRd
add_slide_numbers <- function(slides){
  for (i in seq_along(slides)){
    slides[[i]]['num'] <- i
  }
  return(slides)
}

#' Add ids for slides with no defaults
#'
#' @keywords internal
#' @noRd
add_missing_id <- function(slides){
  for (i in seq_along(slides)){
    if (length(slides[[i]]$id) == 0){
      slides[[i]]['id'] = sprintf("slide-%s", i)
    }
  }
  return(slides)
}

add_slide_rmd <- function(slides, slide_rmd){
  for (i in seq_along(slides)){
      slides[[i]]['raw'] = slide_rmd[i] 
  }
  return(slides)
}

# Add raw R markdown source to slide vars
# 
# @noRd
#  Remove preceding newlines to optimize display of source code.
# add_raw_rmd <- function(slides, source){
#   raw_rmd <- doc2slides(source)
#   for (i in seq_along(slides)){
#     slides[[i]]['raw'] <- paste(raw_rmd[[i]][-1], collapse = "\n")
#   }
#   return(slides)
# }

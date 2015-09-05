#' Update lists with build classes
#' 
#' @keywords internal
#' @noRd
update_classes <- function(content){
  update_ul_classes <- function(content){
    content = gsub('<blockquote>\n*<ul>', '<ul class = "build incremental">', content)
    content = gsub('</ul>\n*</blockquote>', "</ul>", content)
    return(content)
  }
  update_ol_classes <- function(content){
    content = gsub('<blockquote>\n*<ol>', '<ol class = "build incremental">', content)
    content = gsub('</ol>\n*</blockquote>', "</ol>", content)
    return(content)
  }
  content <- content %|% update_ul_classes %|% update_ol_classes %|% update_p_classes
  content <- content %|% update_li_classes
  return(content)
}

#' Update <*> classes by adding class specifier
#'
#' @keywords internal
#' @noRd
# It should convert <p>.build some text </p> to
# <p class = "build"> some text </p>
update_p_classes <- function(content){
  content = gsub("<p>\\.(.*?) ", "<p class='\\1'>", content)
  gsub("<p class='build'>([^>.]*)</p>", "<p class='build'><span>\\1</span></p>", content)
}

#' Update <*> classes by adding class specifier
#'
#' @keywords internal
#' @noRd
# It should convert <p>~ some text </p> to
# <p class = "build"> some text </p>
update_p_classes2 <- function(content){
  gsub('<p>([^p>.]*)~</p>', "<span class='build incremental'><p>//1</p></span>", content)
}

update_li_classes <- function(content){
  gsub("<li>\\.(.*?) ", "<li class = '\\1'>", content)
}

update_li_classes <- function(content){
  y = str_replace(content, regex("<ul>\n<li>\\.{2}(.*)\\.{2}"), 
    "<ul class='\\1'>\n<li>")
  y = str_replace_all(y, regex("<li>\\s*\\.([^\\s]*)\\s+"), "<li class='\\1'>")
  return(y)
}


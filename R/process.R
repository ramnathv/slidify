#' Split document into metadata and slides
#' 
#' @param doc path to source file
#' @return list with metadata and slides
#' @keywords internal
#' @noRd
to_deck <- function(doc){
  txt = str_split_fixed(read_file(doc), '\n---', 2)
  meta = yaml.load(gsub("^---\n+", '', txt[1]))
  meta = lapply(meta,function(x){
    if(length(x)!=1) return(x)
    return(iconv(x,"UTF-8","UTF-8"))
  })
  cfile = ifelse(is.null(meta$config), 'config.yml', meta$config)
  deck = modifyList(get_config(cfile), c(meta, slides = txt[2]))
  deck$standalone = ifelse(deck$mode == "standalone", TRUE, FALSE)
  return(deck)
}

#' Split slides into individual slides
#'
#' Slides are separated by a newline followed by three horizontal dashes.
#' An empty new line SHOULD precede the three horizontal dashes, otherwise
#' it will not be treated as a slide separator
#' @keywords internal
#' @noRd
split_slides <- function(slides, pat = '\n\n---'){
  str_split(slides, pattern = pat)[[1]]
}

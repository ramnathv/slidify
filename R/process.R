#' Split document into metadata and slides
#' 
#' @param doc path to source file
#' @return list with metadata and slides
#' @keywords internal
#' @noRd
to_deck <- function(doc){
  # @kohske
  # read_file cares encoding and return native.enc char.
  # txt should also be native.enc.
  txt = str_split_fixed(read_file(doc), '\n---', 2)

  # @kohske
  # Here txt is native.enc. Probably yaml.load accepts only UTF8 (and ascii?).
  # In MBCS locale, gsub/sub sometimes returns char marked as UTF8
  # (when fixed = FALSE), but sometimes not (if there is no match).
  # So just in case, convert it into utf8 before yaml.load.
  meta = yaml.load(enc2utf8(gsub("^---\n+", '', txt[1])))
  # Then mark meta as UTF8 (because yaml.load doesn't this)
  # and convert it to native.enc.
  meta = rapply(meta, function(x) {
    if (is.character(x)) {
      Encoding(x) <- "UTF-8"
      enc2native(x)
    } else {
      x
    }
  }, how = "replace")

  # custom config also care encoding
  # Note that if custom config is MBCS, it MUST be same encoding
  # as input Rmd.
  cfile = ifelse(is.null(meta$config), 'config.yml', meta$config)
  
  # Now all texts are native.enc
  
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

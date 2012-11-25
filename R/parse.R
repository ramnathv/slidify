#' Parse slide into metadata and body
#'
#' @keywords internal
#' @noRd
parse_slide <- function(slide){
  slide <- str_split(slide, "\n\\*{3}\\s*")[[1]] # slide to blocks   
  slide <- str_split_fixed(slide, '\n', 2)       # blocks to metadata
  slide <- apply(slide, 1, function(x){
    c(parse_meta(x[1]), parse_body(x[2]))
  })
  if (length(slide) > 1){
    slide = c(slide[[1]], list(blocks = slide[-1]))
  } else {
    slide = slide[[1]]
  }
  return(slide)
}


#' Parse slide metadata into list
#'
#' Arbitrary metadata can be added to slide header as key:value pairs 
#' Slide classes, id and layouts can also be defined using prefixes
#' class = ., id = #, layouts = &
#' @keywords internal
#' @noRd
# 1. Refactor this function so that it is more elegant.
# 2. One limitation is that key/values cannot contain any spaces.
# 3. Rename tpl to layout to maintain consistency.
parse_meta <- function(meta){
  x <- strsplit(meta, ' ')[[1]]
  x <- sub('^#', 'id:', x)
  x <- sub('&', 'tpl:', x, fixed = T)
  x <- sub('^\\.', 'class:', x)
  x <- sub('^=', 'name:', x)
  y <- str_split_fixed(x[grep(":", x)], ":", 2)
  y1 = y[,1]; y2 = y[,2]
  meta  = as.list(y2[y1 != 'class'])
  names(meta) = y1[y1 != 'class']
  meta$class = paste(y2[y1 == 'class'], collapse = ' ')
  filter_blank(meta)
}

#' Parse slide body into list
#'
#' @param body slide contents without the metadata header
#' @keywords internal
#' @noRd
parse_body <- function(body){
  html = ifelse(body != '', md2html(body), '')
  pat = '^(<h([0-9])>([^\n]*)</h[0-9]>)?\n*(.*)$'
  body = setNames(as.list(str_match(html, pat)),
   c('html', 'header', 'level', 'title', 'content'))
  body = modifyList(body, parse_content(body$content))
  # HACK: So that landslide h1's with no content are centered
  if (body$content == ""){
  	body$content = NULL
  }
  return(body)
}

#' Split slide content into blocks 
#'
#' Content blocks are specified by a line starting with three stars followed
#' by the block name. If no content blocks are specified, the entire slide
#' is treated as a single block named "content"
#' @param content slide content 
#' @return list of named content blocks
#' @keywords internal
#' @noRd
parse_content <- function(content){
  blocks <- strsplit(content, "<p>\\*{3}\\s*")[[1]]
  bpat   <- "^([a-zA-Z0-9]+)\\s*</p>\n*(.*)$"
  bnames <- ifelse(grepl(bpat, blocks), gsub(bpat, "\\1", blocks), 'content')
  bcont  <- gsub(bpat, "\\2", blocks)
  bcont  <- setNames(as.list(bcont), bnames)
  # HACK: Strip html tags from help contents 
  # I think this was done for RGoogleForms
  if ('help' %in% names(bcont)){
    bcont$help = gsub("<p>(.+?)</p>", "\\1", bcont$help)
  }
  bcont
}

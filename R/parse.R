#' Parse slide into metadata and body
#'
parse_slide <- function(slide){
  slide = str_split_fixed(slide, '\n', 2)
  slide = setNames(as.list(slide), c('meta', 'body'))
  meta = parse_meta(slide$meta)
  body = parse_body(slide$body)
  merge_list(meta, body)
}


#' Parse slide metadata into list
#'
#' Arbitrary metadata can be added to slide header as key:value pairs 
#' Slide classes, id and layouts can also be defined using prefixes
#' class = ., id = #, layouts = &
#' @keywords internal
# TODO: Refactor this function so that it is more elegant.
# TODO: One limitation is that key/values cannot contain any spaces.
parse_meta <- function(meta){
  x <- strsplit(meta, ' ')[[1]]
  x <- sub('^#', 'id:', x)
  x <- sub('&', 'tpl:', x, fixed = T)
  x <- sub('^\\.', 'class:', x)
  y <- str_split_fixed(x[grep(":", x)], ":", 2)
  y1 = y[,1]; y2 = y[,2]
  meta  = as.list(y2[y1 != 'class'])
  names(meta) = y1[y1 != 'class']
  meta$class = paste(y2[y1 == 'class'], collapse = ' ')
  filter_blank(meta)
}

#' Parse slide body into list
#'
#' @body slide contents without the metadata header
#' @keywords internal
parse_body <- function(body){
  html = ifelse(body != '', md2html(body), '')
  pat = '^(<h([0-9])>([^\n]*)</h[0-9]>)?\n*(.*)$'
  body = setNames(as.list(str_match(html, pat)),
   c('html', 'header', 'level', 'title', 'content'))
  modifyList(body, parse_content(body$content))
}

#' Split slide content into blocks 
#'
#' Content blocks are specified by a line starting with three stars followed
#' by the block name. If no content blocks are specified, the entire slide
#' is treated as a single block named "content"
#' @param content slide content 
#' @return list of named content blocks
#' @keywords internal
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

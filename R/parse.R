#' Parse slide into metadata and body
#'
#' @keywords internal
#' @noRd
parse_slide <- function(slide){
  slide <- str_split(slide, "\n\\*{3}\\s*")[[1]] # slide to blocks   
  slide <- str_split_fixed(slide, '\n', 2)       # blocks to metadata
  slide <- apply(slide, 1, function(x){
    y_meta = parse_meta(x[1])
    # FIXME: figure out why the ifelse does not work correctly.
    # y_body = ifelse(y_meta$class %?=% 'YAML', yaml.load(x[2]), parse_body(x[2]))
    if (y_meta$class %?=% 'YAML'){
     y_body = yaml.load(x[2])
    } else {
     y_body = parse_body(x[2])
    }
    y = c(y_meta, y_body)
  })
  if (length(slide) > 1){
    main  = slide[[1]]
    named = Filter(function(z) !is.null(z$name), slide[-1])
    names(named) = lapply(named, '[[', "name")
    blocks = Filter(function(z) is.null(z$name), slide[-1])
    slide  = c(main, named, list(blocks = blocks))
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
  # body = modifyList(body, parse_content(body$content))
  # HACK: So that landslide h1's with no content are centered
  if (body$content == ""){
  	body$content = NULL
  }
  return(body)
}

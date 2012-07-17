#' Split a markdown document into slides
#' 
#' Slides are separated by lines that start with --- 
#' @param md_file path to markdown file containing the slides
#' @return list of slides
#' @keywords internal
doc2slides <- function(md_file){
  spat <- "^(?<sep><?(?<comm>!--)?\\s?---\\s?(?<attribs>.*)>?$)"
  doc  <- readLines(md_file)
  begin  <- grep(spat, doc, perl = TRUE)
  end    <- c(begin[-1] - 1, length(doc))
  slides <- mapply(function(i, j) doc[i:j], begin, end) 
}

#' Parse slide into its constituent elements
#' 
#' This function takes a slide as input and extracts its 
#' constitutent elements returning them as a list. 
#' Contents are rendered as HTML.
#'
#' @param slide 
#' @importFrom markdown renderMarkdown
#' @keywords internal
parse_slide <- function(slide){
  attribs  <- extract_slide_attribs(slide[1])
  vars     <- extract_slide_vars(slide[-1])
  modifyList(vars, attribs)
}

#' Extract slide attributes from header
#'
#' --- class1 class2 #id &tpl
#' list(classes = 'class1 class2', id = 'id', tpl = 'tpl')
#' @keywords internal
extract_slide_attribs <- function(header){
  attribs <- strsplit(gsub("^---\\s*", "", header), " ")[[1]]
  classes = gsub('(^[#|&].*$)', '', attribs)
  classes = paste(classes[classes != ""], collapse = " ")
  id  = gsub('^#(.*)$', "\\1", grep('#', attribs, value = T))
  tpl = gsub('^&(.*)$', "\\1", grep('&', attribs, value = T))
  list(classes = classes, id = id, tpl = tpl)
}

#' Extract slide variables from slide
#'
#' title, header, content, level, sub
#' @keywords internal
extract_slide_vars <- function(slide){
  raw_md  <- paste(slide, collapse = "\n")
  content <- renderMarkdown(text = raw_md, 
    renderer.options = markdownExtensions())
  hpat <- '(?<header><h(?<level>[0-9])>(?<title>.*)</h[0-9]>)\n+'
  vars <- re.capture(hpat, content)$name
  if (nchar(vars$header) > 0) {
    vars$content <- sub(vars$header, "", content, fixed = TRUE)
  } else {
    vars$content <- content
  }
  vars$content <- update_ul_classes(vars$content)
  vars$content <- update_ol_classes(vars$content)
  blocks <- content_to_blocks(vars$content)
  vars   <- modifyList(vars, blocks)
  vars$sub <- ifelse(vars$level == 1, FALSE, TRUE)
  vars$num <- ""
  return(vars)
}

#' Add slide separator to presentations using standard markdown
#'
#' This function adds a slide separator to presentations that don't use  
#' an explicit separator
#' 
#' @keywords internal
#  TODO: identify slide level to add separator
add_slide_separator <- function(doc){
  if (!any(grep('^---', doc))){
    doc = gsub("^###", "---\n###", doc)
  }
  return(doc)
}

#' Split HTML content into blocks based on a regex pattern
content_to_blocks <- function(content){
  blocks <- strsplit(content, "<p>\\*{3}\\s*")[[1]]
  bpat   <- "^([[:alpha:]]+)</p>\n*(.*)$"
  bnames <- ifelse(grepl(bpat, blocks), gsub(bpat, "\\1", blocks), 'content')
  bcont  <- gsub(bpat, "\\2", blocks)
  setNames(as.list(bcont), bnames)
}

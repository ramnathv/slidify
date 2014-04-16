#' Parse pages
#'
#' @noRd
parse_pages <- function(postFiles){
  lapply(postFiles, parse_page)
}

#' Parse page
#'
#' @noRd
parse_page <- function(postFile, knit_deck = TRUE, envir){
  in_dir(dirname(postFile), {
    inputFile = basename(postFile)
    opts_chunk$set(fig.path = "assets/fig/", cache.path = '.cache/', cache = TRUE)
    outputFile <- gsub(".[r|R]md", ".md", inputFile)
    deckFile <- ifelse(knit_deck,
      knit(inputFile, outputFile, envir = envir), inputFile)
    post <- deckFile %|% parse_deck
    post$file = postFile
    post$filename = tools:::file_path_sans_ext(inputFile)
    if (!is.null(post$date)) {
      post$date = as.Date(post$date, '%Y-%m-%d')
    }
    post$link = gsub("*.[r|R]md", ".html", post$file)
    post$raw = read_file(inputFile)
    # saveRDS(post, file = "_payload.rds")
  })
  return(post)
}

#' Parse deck into metdata and slide elements
#'
#' @param inputFile path to markdown file to parse
#' @noRd
parse_deck <- function(inputFile){
  # Determine path to original Rmd
  rmd_filepath = sub(".md", ".Rmd", inputFile)
  if (!file.exists(rmd_filepath)) {
      rmd_filepath = sub(".md", ".rmd", inputFile)
  }
  deck = inputFile %|% to_deck
  deck$slides = deck$slides %|% split_slides %|% parse_slides
  deck$slides = deck$slides %|% add_slide_numbers %|% add_missing_id
  slide_rmd <- get_slide_rmd(rmd_filepath)
  deck$slides = add_slide_rmd(deck$slides, slide_rmd)
  return(deck)
}

#' Parse slides into constitutent elements
#'
#' @keywords internal
#' @noRd
parse_slides <- function(slides){
  lapply(slides, parse_slide)
}

#' Parse slide into metadata and body
#'
#' @keywords internal
#' @noRd
parse_slide <- function(slide){
  slide <- str_split(slide, "\n\\*{3}")[[1]] %|% split_meta
  # slide <- str_split(slide, "\n\\*{3}")[[1]] # slide to blocks
  # slide <- str_split_fixed(slide, '\n', 2)   # blocks to metadata
  slide <- apply(slide, 1, function(x){
    y_meta <- if(grepl("{", x[1], fixed = TRUE)) {
      parse_meta3(x[1])
    } else {
      parse_meta(x[1])
    }
    # FIXME: figure out why the ifelse does not work correctly.
    # y_body = ifelse(y_meta$class %?=% 'YAML', yaml.load(x[2]), parse_body(x[2]))
    if (y_meta$class %?=% 'YAML'){
      y_body = yaml.load(x[2])
    } else {
      y_body = parse_body(x[2])
    }
      y = modifyList(y_body, y_meta)
  })
  if (length(slide) > 1){
    main  = slide[[1]]
    named = Filter(function(z) !is.null(z$name), slide[-1])
    names(named) = lapply(named, '[[', "name")
    blocks = Filter(function(z) is.null(z$name), slide[-1])
    blocks = lapply(seq_along(blocks), function(i){
      modifyList(blocks[[i]], list(num = i))
    })
    slide  = c(main, named, list(blocks = blocks))
  } else {
    slide = slide[[1]]
  }
  return(slide)
}


split_meta <- function(blocks){
  split_block <- function(block){
    if (grepl("^\\s*\\{", block)){
      block <- str_split_fixed(block, "}\n", 2)
      block[1] <- paste(block[1], "}")
    } else {
      block <- str_split_fixed(block, "\n", 2)
    }
    return(block)
  }
  t(sapply(blocks, split_block, USE.NAMES = F))
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

#' Parse slide metadata into list
#'
#' @noRd
#' Metadata is enclosed within a pair of curly braces and is required to
#' be valid YAML. Commonly used metadata keys have predefined shortcuts.
#' So . expands to class: , # expands to id: and & expands to layout:
#' IDEA: Use options, so that user can customize further shortcuts.
parse_meta2 <- function(x){
  myrepl = list(c('\\.', 'class: '), c('\\#', 'id: '), c('\\&', 'tpl: '))
  x1 = mgsub(myrepl, gsub("^\\{(.*)\\}$", "\\1", x))
  x2 = str_split_fixed(x1, "\n", 2)
  y1 = yaml.load(sprintf("{%s}", x2[1]))
  if (x2[2] != ""){
    y1 = modifyList(y1, y2)
  }
  if (!is.null(y1$class)){
    y1$class = paste(y1$class, collapse = " ")
  }
  return(y1)
}

#' @noRd
parse_meta3 <- function(x){
  myrepl = list(c('\\.', 'class: '), c('\\#', 'id: '), c('\\&', 'tpl: '))
  # y1 = yaml.load(mgsub(myrepl, x))
  y1 = yaml.load(x)
  if (!is.null(y1$class)){
    y1$class = paste(y1$class, collapse = " ")
  }
  return(y1)
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
  if (body$header == ""){
    body$header = NULL
  }
  return(body)
}

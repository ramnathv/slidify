#' Split a markdown document into slides
#' 
#' Slides are separated by lines that start with the keyword !SLIDE followed by #' optional slide classes.
#' @param md_file path to markdown file containing the slides
#' @return list of slides
#' @keywords internal
doc_to_slides <- function(md_file){
	doc <- readLines(md_file)
	
	# if there are no !SLIDE markers, add explicity separatorsy
	if (!any(grepl('^<?!SLIDE', doc))){
		doc = add_slide_separator(doc)
	}
	
	begin  <- grep("^<?!SLIDE(.*)>?", doc) 
	end    <- c(begin[-1] - 1, length(doc))
	slides <- mapply(function(i, j) doc[i:j], begin, end)
}

#' Add !SLIDE separator to presentations using standard markdown
#'
#' This function adds a !SLIDE separator to presentations that don't use  
#' an explicit separator, or are using the older format of separating slides #' with `---`.
#' 
#' @keywords internal
#  TODO: add !SLIDE to top of presentation
add_slide_separator <- function(doc){
  if (any(grep('^---', doc))){
    doc = gsub("^---", "!SLIDE", doc)
  } else {
    doc = gsub("^### ", "<!SLIDE>\n###", doc)
  }
  return(doc)
}


#' Extract slide attributes from header
#'
get_slide_attribs <- function(header){
	attribs <- strsplit(sub("^<?!SLIDE\\s*(.*)>?", "\\1", header), "\\s+")[[1]]
	id = NULL; classes = NULL
	if (length(attribs) > 0){
	  classes <- grep('^[^#]', attribs, value = TRUE)
	  id      <- gsub("#", "", grep('^#', attribs, value = TRUE))
	}
	# if no id is specified, generate a random id
	if (length(id) == 0) {
		id = make_id()
	}
	list(classes = classes, id = id)
}

#' Update <*> classes by adding class specifier
#'
# It should convert <p>.build some text </p> to
# <p class = "build"> some text </p>
update_p_classes <- function(content){
	gsub("<p>\\.(.*?) ", "<p class = '\\1'>", content)
}

# #' Update <p> classes by adding the class specifier.
# update_p_classes <- function(content){
#   gsub("<p>\\.(.*?) ", "<p class = '\\1'>", content)
# }

update_ul_classes <- function(content){
	gsub("<ul>", "<ul class = 'build'>", content)
}

update_classes <- function(content, classes){
	content <- update_p_classes(content)
	if ('build' %in% classes){
		content <- update_ul_classes(content)
	}
	return(content)
}

#' Get slide variables from slide
get_slide_vars <- function(slide){
	content <- renderMarkdown(text = paste(slide[-1], collapse = "\n"))
	hpat <- '(?<header><h(?<level>[0-9])>(?<title>.*)</h[0-9]>)\n+'
	vars <- re.capture(hpat, content)$name
	vars$content = sub(vars$header, "", content)
	return(vars)
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
	attribs  <- get_slide_attribs(slide[1])
	vars     <- get_slide_vars(slide[-1])
	vars$sub <- ifelse(vars$level == 1, FALSE, TRUE)
	vars$id  <- attribs$id
	vars$num <- ""
	vars$classes <- paste(attribs$classes, collapse = " ")
	return(vars)
}

# parse_slide <- function(slide){
#   content <- renderMarkdown(text = paste(slide[-1], collapse = "\n"))
#   attribs <- get_slide_attribs(slide[1])
#   content <- update_classes(content, attribs$classes)
#   modifyList(attribs, list(content = content, 
#      classes = paste(attribs$classes, collapse = " ")))
# }





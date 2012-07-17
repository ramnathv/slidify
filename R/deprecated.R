# Save deprecated functions. To be deleted eventually.

doc_to_slides <- function(md_file){
  doc <- readLines(md_file)
  
  # if there are no !SLIDE markers, add explicity separators
  if (!any(grepl('^<?!SLIDE', doc))){
    doc = add_slide_separator(doc)
  }
  
  begin  <- grep("^<?!SLIDE(.*)>?", doc) 
  end    <- c(begin[-1] - 1, length(doc))
  slides <- mapply(function(i, j) doc[i:j], begin, end)
}

doc_to_slides2 <- function(md_file){
  spat <- "^(?<sep><?(?<comm>!--)?\\s?---\\s?(?<attribs>.*)>?$)"
  doc  <- readLines(md_file)
  if (!any(grepl(spat, doc))){
    doc = add_slide_separator2(doc)
  }
  begin  <- grep(spat, doc)
  end    <- c(begin[-1] - 1, length(doc))
  slides <- mapply(function(i, j) doc[i:j], begin, end) 
}


get_slide_attribs_old <- function(header){
  attribs <- strsplit(sub("^<?!SLIDE\\s*(.*)>?", "\\1", header), "\\s+")[[1]]
  id = ""; classes = NULL
  if (length(attribs) > 0){
    classes <- grep('^[^#]', attribs, value = TRUE)
    id <- grep('^#', attribs, value = TRUE)
    if (length(id) > 0){
      id <- gsub("#", "", id)
    } else {
      id <- ""
    }
  }
  # if no id is specified, generate a random id
  # if (length(id) == 0) {
  #    id = make_id()
  #  }
  list(classes = classes, id = id)
}

#' Make a random string id
#' 
# @TODO: Add attribution to original author.
make_id <- function(n = 1, length = 4){
  randomString <- c(1:n)            
  for (i in 1:n){
    randomString[i] <- paste(sample(c(0:9, letters, LETTERS),
     length, replace=TRUE), collapse="")
  }
  return(randomString)
}


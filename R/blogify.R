#' Render a slide
#' 
#' @param slide list containing elements of the parsed slide
#' @param layouts list of layouts
#' @param payload list containing site and page, useful for blogs
#  TOTHINK: Should partials also be passed along?
render_slide <- function(slide, layouts, payload){
  layout  = layouts[[slide$tpl %||% 'slide']]
  payload = modifyList(payload, list(slide = slide))
  slide$rendered = whisker.render(layout, payload) %|% update_classes
  
  if (!(slide$class %?=% 'RAW')){
    slide$rendered = whisker.render(slide$rendered, payload)
  }

  return(slide)
}

#' Render slides
render_slides <- function(slides, layouts, payload){
  lapply(slides, render_slide, layouts = layouts, payload = payload)
}


#' Render page
#' 
#' @param page list containing the parsed page
#' @param payload list containing site and pages
#  TODO: Refactor by splitting code into smaller manageable chunks
render_page <- function(page, payload){
  if (page$mode == 'selfcontained'){
    page$url[['lib']] <- page$url[['lib']] %||% 'libraries'
    with(page, copy_libraries(framework, highlighter, widgets, url$lib))
  }
  
  # add layouts, urls and stylesheets from frameworks, widgets and assets
  page = page %|% add_urls %|% add_stylesheets %|% add_config_fr
  layouts = get_layouts(page$url$layouts)
  partials = get_layouts(file.path(page$url$framework, 'partials'))
  partials = modifyList(partials, list(javascripts = get_javascripts(page)))
  
  payload = modifyList(payload, list(page = page))
  
  
  page$slides = render_slides(page$slides, layouts, payload)
  page$content = paste(lapply(page$slides, pluck('rendered')), collapse = '\n')
  payload$page = page
 
  
  # outputFile = gsub("*.[R]?md$", '.html', page$file)
  outputFile = sprintf("%s.html", page$filename)
  layout = layouts[[page$layout %||% 'deck']]
  cat(whisker.render(layout, payload, partials = partials), file = outputFile)
  
  # Extract R Code from Page if purl = TRUE
  if (page$purl %?=% TRUE) purl(page$file)
}


#' Render pages
render_pages <- function(pages, site, tags){
  payload = list(site = site, pages = pages, tags = tags)
  invisible(lapply(pages, function(page){in_dir(dirname(page$file), 
    render_page(page = page, payload = payload))
  }))
}

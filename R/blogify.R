#' Render a slide
render_slide <- function(slide, layouts, payload){
  tpl <- slide$tpl %||% 'slide'
  payload = modifyList(payload, list(slide = slide))
  slide$rendered = whisker.render(layouts[[tpl]], payload) %|% update_classes
  
  # HACK. Figure out a more elegant solution for this.
  if (is.null(slide$class) || slide$class != 'RAW'){
    slide$rendered = whisker.render(slide$rendered, payload)
  }
  return(slide)
}

#' Render slides
render_slides <- function(slides, layouts, payload){
  lapply(slides, render_slide, layouts = layouts, payload = payload)
}


#' Render page
render_page <- function(page, payload){
  if (page$mode == 'selfcontained'){
    page$url[['lib']] <- page$url[['lib']] %||% 'libraries'
    with(page, copy_libraries(framework, highlighter, widgets, url$lib))
  }
  
  # add layouts, urls and stylesheets from frameworks, widgets and assets
  page = page %|% add_urls %|% add_stylesheets %|% add_config_fr
  layouts = get_layouts(page$url$layouts)
  layouts = modifyList(layouts, list(javascripts = get_javascripts(page)))
  
  payload = modifyList(payload, list(page = page))
  
  # HACK ALERT. REALLY REALLY UGLY CODE TO FIX -----
  page$slides = render_slides(page$slides, layouts, payload)
  payload$page$slides = page$slides
  
  paste_all = function(...) paste(..., collapse = "\n")
  page$content = do.call(paste_all, lapply(page$slides, pluck('rendered')))
  payload$page$content = page$content
  # HACK ALERT. REALLY REALLY UGLY CODE TO FIX -----
  
  outputFile = gsub("*.[R]?md$", '.html', page$file)
  main = page$layout %||% 'deck'
  cat(whisker.render(layouts[[main]], payload, partials = layouts), file = outputFile)
}

#' Render pages
render_pages <- function(pages, site, tags){
  payload = list(site = site, pages = pages, tags = tags)
  invisible(lapply(pages, render_page, payload = payload))
}

#' Render post
render_post <- function(post){
  if (post$mode == 'selfcontained'){
    post$url[['lib']] <- post$url[['lib']] %||% 'libraries'
    with(post, copy_libraries(framework, highlighter, widgets, url$lib))
  }
  
  # add layouts, urls and stylesheets from frameworks, widgets and assets
  post = post %|% add_urls %|% add_stylesheets %|% add_config_fr
  layouts = get_layouts(post$url$layouts)
  layouts = modifyList(layouts, list(javascripts = get_javascripts(post)))
  outputFile = gsub("*.[R]?md$", '.html', post$file)
  cat(render_deck(post, layouts), file = outputFile)
}

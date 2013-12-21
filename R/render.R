#' Render a slide
#' 
#' @param slide list containing elements of the parsed slide
#' @param layouts list of layouts
#' @param payload list containing site and page, useful for blogs
#' @noRd
#  TOTHINK: Should partials also be passed along?
render_slide <- function(slide, layouts, payload){
  default = "{{{slide.header}}}\n{{{slide.content}}}"
  layout  = layouts[[slide$tpl %||% 'slide']] %||% default
  payload = modifyList(payload, list(slide = slide))
  slide$rendered = whisker.render(layout, payload, partials = layouts) %|% update_classes
  raw_slide = !is.null(slide$class) && grepl('RAW', slide$class)
  if (!(raw_slide)){
    slide$rendered = whisker.render(slide$rendered, payload, partials = layouts)
  }
  
  return(slide)
}

#' Render slides
#' @noRd
render_slides <- function(slides, layouts, payload){
  lapply(slides, render_slide, layouts = layouts, payload = payload)
}


#' Render page
#' 
#' @param page list containing the parsed page
#' @param payload list containing site and pages
#  TODO: Refactor by splitting code into smaller manageable chunks
render_page <- function(page, payload, return_page = FALSE, save_payload = FALSE){
  in_dir(dirname(page$file), {
    if (page$mode == 'selfcontained'){
      page$url[['lib']] <- page$url[['lib']] %||% 'libraries'
      with(page, copy_libraries(framework, highlighter, widgets, url$lib))
      if (!is.null(page$ext_widgets)){
        copy_external_widgets(page$ext_widgets, page$url$lib)
      }
    }
    
    # add layouts, urls and stylesheets from frameworks, widgets and assets
    page = page %|% add_urls %|% add_stylesheets %|% add_config_fr
    if (!is.null(page$ext_widgets)){
      page$widgets = c(page$widgets, basename(unlist(page$ext_widgets)))
    }
    widget_configs = read_configs(page$widgets, page$url$widgets)
    widget_configs = modifyList(widget_configs, read_config('assets', "."))
    widget_configs = modifyList(widget_configs, list(custom = page$assets))
    
    page$assets = as.list(sapply(c('css', 'js', 'jshead'), get_assets, widget_configs))
    
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
    if (save_payload){
      save(layout, payload, partials, file = "payload.RData")
    }
    cat(whisker.render(layout, payload, partials = partials), file = outputFile)
    
    # create standalone deck if page mode is standalone
    if (page$mode == 'standalone'){
      outputFile = make_standalone(page, outputFile)
    }
    
    # Extract R Code from Page if purl = TRUE
    if (page$purl %?=% TRUE) purl(page$file)
  })
  if (return_page){ return(page) }
}


#' Render pages
#' 
#' @noRd
render_pages <- function(pages, site, tags){
  payload = list(site = site, pages = pages, tags = tags)
  invisible(lapply(pages, render_page, payload = payload)) 
}

#' Render deck using layouts
#' 
#' @keywords internal
#' @noRd
#  This function has been replaced by render_page and needs to be DEPRECATED
render_deck <- function(deck, layouts, partials){
  #' Render a slide based on specified layout
  render_slide <- function(slide){
    tpl <- slide$tpl %||% 'slide'
    slide2 <- modifyList(slide, list(deck = deck[names(deck) != 'slides']))
    slide$rendered = whisker.render(layouts[tpl], slide) %|% update_classes
    slide$rendered = whisker.render(slide$rendered, slide2)
    return(slide)
  }
  #' Render slides based on specified layouts
  render_slides <- function(slides){
    lapply(slides, render_slide)
  }
  #' Render stylesheets based on mode
  render_stylesheets <- function(){
  	tpl = '{{# css }}<link rel="stylesheet" href = "{{.}}">\n{{/ css}}'
  	whisker.render(tpl)
  }
  #' Render deck
  deck$slides = deck$slides %|% render_slides
  main = deck$layout %||% 'deck'
  whisker.render(layouts[[main]], deck, partials = layouts)
}

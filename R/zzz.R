.onLoad <- function(libname, pkgname){
  options(rstudio.markdownToHTML =    
    function(inputFile, outputFile) {      
      if (readLines(inputFile)[1] == '---'){
        slidify(inputFile, outputFile, knit_deck = FALSE)
      } else {
        require(markdown)
        markdownToHTML(inputFile, outputFile)   
      }
  })
}

### FUNCTIONS TO DELETE AFTER CHECKING

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

url_defaults <- function(deck){
  urls = deck$url
  # Framework and Theme URL Defaults -------
  urls$frameworks   = file.path(urls$lib, 'libraries', 'frameworks')
  urls$framework    = file.path(urls$frameworks, deck$framework)
  urls$theme        = file.path(urls$framework, deck$theme)
  # Highlighter URL Defaults ---------------
  urls$highlighters = file.path(urls$lib, 'highlighters')
  urls$highlighter  = file.path(urls$highlighters, deck$highlighter)
  # Widgets and Assets URL Defaults --------
  urls$widgets      = file.path(urls$lib, 'widgets')
  urls$assets       = 'assets'
  # Layout URL Defaults
  urls$layouts = with(urls, c(
    file.path(theme, 'layouts'),
    file.path(assets, 'layouts'),
    file.path(widgets, deck$widgets, 'layouts')
  ))
}

set_urls <- function(deck){
  urls = deck$url
  # Framework and Theme URL Defaults -------
  urls$frameworks   = file.path(urls$lib, 'libraries', 'frameworks')
  urls$framework    = file.path(urls$frameworks, deck$framework)
  urls$theme        = file.path(urls$framework, deck$theme)
  # Highlighter URL Defaults ---------------
  urls$highlighters = file.path(urls$lib, 'highlighters')
  urls$highlighter  = file.path(urls$highlighters, deck$highlighter)
  # Widgets and Assets URL Defaults --------
  urls$widgets      = file.path(urls$lib, 'widgets')
  urls$assets       = 'assets'
  # Layout URL Defaults
  urls$layouts = with(urls, c(
    file.path(theme, 'layouts'),
    file.path(assets, 'layouts'),
    file.path(widgets, deck$widgets, 'layouts')
  ))
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

#' Knit deck to markdown
#'
#' @keywords internal
#' @noRd
knit_deck <- function(deck){
  render_markdown(strict = TRUE)
  knit_hooks$set(plot = knitr:::hook_plot_html)
  deck$slides = knit(text = deck$slides)
  return(invisible(deck))
}

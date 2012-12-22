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
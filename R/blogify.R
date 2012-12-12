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

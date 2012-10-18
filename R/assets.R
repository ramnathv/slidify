get_javascripts <- function(deck){
  make_path <- function(asset, url){
    file.path(url, asset, sprintf("%s.html", asset))
  }
  widget_js = with(deck, make_path(widgets, url$widgets))
  hilite_js = with(deck, make_path(highlighter, url$highlighters))
  javascripts = lapply(c(widget_js, hilite_js), read_file)
  paste(javascripts, collapse = '\n')
}

add_stylesheets <- function(deck){
  asset_css  = dir(file.path(deck$url$assets, 'css'), full = T)
  widget_css = lapply(file.path(deck$url$widgets, deck$widgets, 'css'), 
    dir, full = T)
  css = c(unlist(widget_css), asset_css)
  tpl = '{{# css }}<link rel="stylesheet" href = "{{.}}">\n{{/ css}}'
  deck$stylesheets = whisker.render(tpl)
  return(deck)
}
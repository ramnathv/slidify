#' Get javascripts
#' 
#' @keywords internal
#' @noRd
get_javascripts <- function(deck){
  make_path <- function(asset, url){
    html_file = file.path(url, asset, sprintf("%s.html", asset))
    file_there = file.exists(html_file)
    return(html_file[file_there])
  }
  asset_js  = dir(file.path(deck$url$assets, 'js'), full.names = T, pattern = '.js$')
  widget_js = with(deck, make_path(widgets, url$widgets))
  hilite_js = with(deck, make_path(highlighter, url$highlighters))
  javascripts = lapply(c(widget_js, hilite_js), read_file)
  # javascripts = c(javascripts, sprintf("<script src='%s'></script", asset_js))
  paste(paste(javascripts, collapse = '\n'), "\n")
}

#' Add stylesheets
#' 
#' @keywords internal
#' @noRd
add_stylesheets <- function(deck){
  asset_css  = dir(file.path(deck$url$assets, 'css'), full.names = T)
  widget_css = lapply(file.path(deck$url$widgets, deck$widgets, 'css'), 
    dir, full = T)
  css = c(unlist(widget_css), asset_css)
  tpl = '{{# css }}<link rel="stylesheet" href = "{{.}}">\n{{/ css}}'
  deck$stylesheets = whisker.render(tpl)
  return(deck)
}

# Get user and widget stylesheets 
get_stylesheets <- function(deck){
  asset_css  = dir(file.path(deck$url$assets, 'css'), full.names = T)
  widget_css = lapply(file.path(deck$url$widgets, deck$widgets, 'css'), 
    dir, full = T)
  c(unlist(widget_css), asset_css)
}


# Behaviors of Add Stylesheets
# 1. Simply add each of the css files as links in the HTML (draft)
# 2. Combine and Minify CSS and add single link in the HTML (production)
# 3. Combine and Minify CSS and add inline in HTML (production, standalone)

# Pseudocode
# 1. Get list of stylesheets `assets/css` and `widgets/widget/css`
# 2. 

# I can think of three modes, which can be passed directly to slidify.
# 
# 1. `draft`         -> serve from package library, add css files as links
# 2. `standalone`    -> serve from cdn, combine, minify and add css inline
# 3. `selfcontained` -> copy libraries, combine, minify and add as link
# 
# The idea is to use `draft` mode to play around with the deck, modify css and test different versions. 
# 
# For Rpubs, I can pass mode = 'standalone'
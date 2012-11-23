#' Set default options for slidify
#'
#  Figure out a better mechanism for specifying defaults
slidifyDefaults <- function(){list(
  url = list(assets = "assets"),
  framework   = 'io2012',
  theme       = "", 
  highlighter = 'highlight.js',  
  hitheme     = 'tomorrow',
  copy_libraries = TRUE,
  mode = 'standalone',
  widgets = list()
)}

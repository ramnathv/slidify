#' Read widget config information
#' 
#' @keywords internal
read_config <- function(widget, url_widgets){
  get_full_path <- function(x){
    res = wconfig[[1]][[x]]
    if (!is.null(res)){
      res <- ifelse(grepl("^http", res), res, file.path(wpath, res))
    }
    return(res)
  }
  wpath = file.path(url_widgets, widget)
  cfile = file.path(wpath, 'config.yml')
  if (file.exists(cfile)){
    wconfig <- yaml::yaml.load_file(cfile)
    w <- setNames(lapply(names(wconfig[[1]]), get_full_path), names(wconfig[[1]]))
  } else {
    css = dir(file.path(wpath, 'css'), pattern = '.css$', full = TRUE)
    js = dir(file.path(wpath, 'js'), pattern = '.js$', full = TRUE)
    w <- list(css = css, js = js)
  }
  setNames(list(w), widget)
}

# widget = "bootstrap"
# url_widgets = '../../libraries/widgets'
# wconfig = read_config(widget, url_widgets)
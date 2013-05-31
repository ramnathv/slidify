#' Read widget configuration
#' 
#' @keywords internal
read_config <- function(widget, url_widgets){
  get_full_path <- function(x){
    res = wconfig[[1]][[x]]
    if (!is.null(res) && x != 'cdn'){
      # change this so that paths with a trailing / are appended with wpath.
      # allows for specifications like shiny which uses a shared directory
      # note that this requires changes to all config.yml files.
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



#' Read widget configuration for all selected widgets
#' 
#' @keywords internal 
read_configs <- function(widgets, url_widgets){
  if (length(widgets) != 0){
    configs = lapply(widgets, read_config, url_widgets)
    Reduce('modifyList', configs)
  } else {
    return(list())
  }
}


get_assets = function(asset_type, widget_configs, custom_config = ""){
  assets = unlist(sapply(widget_configs, pluck(asset_type)), use.names = F)
  if (length(assets) > 1){
    assets = remove_duplicates(assets)
  }
  names(assets) = NULL
  if (asset_type == 'css'){
    tpl <- '{{# assets }}<link rel=stylesheet href="{{.}}"></link>\n{{/ assets }}'
  } else {
    tpl <- '{{# assets }}<script src="{{{.}}}"></script>\n{{/assets}}'
  }
  whisker.render(tpl)
}

remove_duplicates <- function(assets){
  return(assets[!duplicated(basename(assets))])
}

# widgets = c('nvd3', 'bootstrap', 'scianimator')
# url_widgets = "~/Documents/Projects/dev/slidifyLibraries/inst/libraries/widgets"
# widget_configs = read_configs(widgets, url_widgets)
# myassets = as.list(sapply(c('css', 'js', 'jshead'), get_assets, widget_configs))
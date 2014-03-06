#' Default configuration
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

#' Get configuration
#' 
#' A config.yml file in the root directory of the slide deck can be used to 
#' override the default configuration. YAML front matter in the Rmd file overrides
#' everything.
#' 
#' @param cfile path to config file
#' @return list of config options
#' @keywords internal
#' @noRd
get_config <- function(cfile = 'config.yml'){
  config = slidifyDefaults()
  if (file.exists(cfile)){
    # @kohske
    # yaml only accepts UTF8 (probably)
    # so here,
    # 1. read config in .input.enc
    # 2. convert it into UTF8
    # 3. load yaml
    # 4. back the resutls into native.enc
    txt = read_file(cfile)
    txt = enc2utf8(txt)
    config = modifyList(config, yaml_load(txt))
  }
  return(config)
}

#' Add default configuration of framework to fill up missing elements
#' 
#' @keywords internal
#' @noRd
add_config_fr <- function(deck){
  config_file <- file.path(deck$url$framework, "config.yml")
  if (file.exists(config_file)){
    config <- yaml.load_file(config_file)
    deck <- modifyList(config, deck)
  }
  return(deck)
}

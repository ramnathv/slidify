#' Set default options for slidify
#'
#  @TODO: Figure out a better mechanism for specifying defaults
slidifyDefaults <- function(){list(
	url = list(lib = system.file('libraries', package = 'slidify'), assets = "assets"),
	framework   = 'io2012',
	theme       = "", 
	highlighter = 'highlight.js',  
	hitheme     = 'tomorrow',
	copy_libraries = TRUE,
	mode = 'standalone'
)}

#' Function to get deck options
#' 
#' We first initialize the options to defaults. If a list of options is passed to
#' slidify, then it is used to override the defaults. If a config file is passed,
#' then it is used to override the defaults.
get_deck_options <- function(options){
	deck <- slidifyDefaults()
	if (!is.null(options)){
		if (is.list(options)){
			deck <- modifyList(deck, options)
		} else if(file.exists(options)){
			deck <- modifyList(deck, yaml::yaml.load_file(options))
		} else if(file.exists('slidify.yml')){
			deck <- modifyList(deck, yaml::yaml.load_file('slidify.yml'))
		}
	}
	return(deck)
}
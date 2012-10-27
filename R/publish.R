#' Publish a slide deck to github
publish_deck <- function(user, repo){
	system('git add .')
	system('git commit -a -m')
	
}

#' Generate slide deck and publish to rPubs
publish_rpubs <- function(html_file){
	html_file %|% embed_images  
}

switch_lib_url <- function(html_file){
	gurl = 'http://slidify.googlecode.com/git/inst/libraries'
}

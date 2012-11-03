#' Publish slide deck
#' 
#' @param host 
#' @export
publish <- function(..., host = 'github'){
	publish_deck <- switch(host, 
		 github = publish_github, 
		dropbox = publish_dropbox,
			rpubs = publish_rpubs
	)
	publish_deck(...)
}

#' Publish slide deck to Github
#' 
#' @param user github username
#' @param repo github reponame
#' @export
publish_github <- function(user, repo){
	if (!file.exists('libraries')){
		message('Please set mode to selfcontained and run Slidify')
		message('This would place library files in the slide folder')
		message('making it self-contained')
		invisible(return(FALSE))
	}
	# check if git repo exists, else initialize new repo with gh-pages
	if (!file.exists('.git')){
		init_repo()
	}
	message('Publishing deck to ', user, '/', repo)
	system('git add .')
	system('git commit -a -m "publishing deck"')
	system(sprintf('git push git@github.com:%s/%s gh-pages', user, repo))
	link = sprintf('http://%s.github.com/%s', user, repo)
	message('You can now view your slide deck at ', link)
	browseURL(link)
}

#' Publish slide deck to Dropbox
#' 
#' @param dirname name of directory to publish to; defaults to slide directory
#' @export
publish_dropbox <- function(dirname){
	if (missing(dirname)){
		dirname = basename(getwd())
	}
	drop_dir = file.path('~/Dropbox/Public', dirname)
	message('Creating slide directory at ', drop_dir)
	dir.create(drop_dir)
	message('Copying files to ', drop_dir)
	file.copy(".", drop_dir, overwrite = F, recursive = TRUE)
}

#' Publish slide deck to rPubs
#' 
#' @param title title of the presentation
#' @param html_file path to html file to publish; defaults to index.html
#' @export
publish_rpubs <- function(title, html_file = 'index.html'){
	html = html_file %|% embed_images %|% enable_cdn
	html_out = tempfile(fileext = '.html')
	writeLines(html, html_out)
	url = rpubsUpload(title, html_out)$continueUrl
	browseURL(url)
}




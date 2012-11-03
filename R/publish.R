#' Publish slide deck
#' 
#' @param host 
#' @export
#  TODO: Pick missing parameters from config.yml
#  TODO: Think about simplifying name to publish
publish_deck <- function(..., host = 'github'){
	publish <- switch(host, 
		 github = publish_github, 
		dropbox = publish_dropbox,
			rpubs = publish_rpubs
	)
	publish(...)
}

#' Publish slide deck to Github
#' 
#' @param user github username
#' @param repo github reponame
#' @export
#' TODO: modify link to point to *.html if slide is not named index.Rmd
publish_github <- function(user, repo){
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

#' Embed local images using base64
#'
#' @keywords internal
#' @param html_in path to input html file
#' @param html_out path to output html file
#' @return 
embed_images <- function(html_in){
	html <- paste(readLines(html_in, warn = F), collapse = "\n")
	html <- markdown:::.b64EncodeImages(html)
	return(html)
}

#' Enable library files to be served from CDN
enable_cdn <- function(html){
	cdn  = 'http://slidify.googlecode.com/git/inst/libraries/'
	html = gsub("libraries/", cdn, html, fixed = TRUE)
}

# ==== EXPERIMENTAL FUNCTIONS ====

get_x <- function(){
	cat('Enter a value of x: ')
	x <- readline()
	cat('The value you entered is ', x)
}

setup_github_pages <- function(repo_url){
	if (missing(repo_url)){
		cat('Enter the read/write url for your repository')
		cat('For example, "git@github.com:user/repo"')
		repo_url = readline()
	}
	return(repo_url)
}

#' Add remote
#' 
#' Add the correct origin remote and checkout the source branch for committing
#' changes to the source.
add_remote <- function(repo_url){
	system(sprintf('git remote add origin %s', repo_url))
	message('Added remote ', repo_url, 'as origin')
	system('git config branch.master.remote origin')
	message('Set origin as default remote')
	system('git branch -m master source')
	message('Master branch renamed to "source" for committing source files')
}

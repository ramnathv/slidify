#' Publish a slide deck to github
publish_deck <- function(user, repo){
	message('Publishing deck to ', user, '/', repo)
	system('git add .')
	system('git commit -a -m "publishing deck"')
	system(sprintf('git push git@github.com:%s/%s gh-pages', user, repo))
}

#' Generate slide deck and publish to rPubs
publish_rpubs <- function(html_file){
	html_file %|% embed_images  
}

switch_lib_url <- function(html_file){
	gurl = 'http://slidify.googlecode.com/git/inst/libraries'
}

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

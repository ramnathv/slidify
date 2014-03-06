#' Publish slide deck
#' 
#' This function makes it easy to publish your presentation. Currently supported
#' hosts include Github, RPubs and Dropbox.
#' 
#' @param host where to publish presentation, Github, RPubs or Dropbox
#' @param ... parameters to be passed to \code{\link{publish_github}}, 
#'   \code{\link{publish_rpubs}} or \code{\link{publish_dropbox}}
#' @family publish
#' @export
publish <- function(..., host = 'github'){
  publish_deck <- switch(host, 
     github = publish_github, 
    dropbox = publish_dropbox,
      rpubs = publish_rpubs,
      gist  = publish_gist
  )
  publish_deck(...)
}

#' Publish slide deck to Github
#' 
#' You will need \code{git} installed on your computer and a \code{github}
#' account. In addition, you will \code{SSH} access to \code{github}. See 
#' \url{https://help.github.com/articles/generating-ssh-keys} on how to set up
#' \code{SSH} access
#' 
#' Login with your github account and create a new repository 
#' \url{https://help.github.com/articles/creating-a-new-repository}. Note that 
#' Github will prompt you to add a README file, but just use the defaults so 
#' that your repo is empty. You will need to have \code{git} installed on your 
#' computer.  You can push to \code{github} using SSH or https.  You may
#' store your crendentials as options with \code{options(github.user="username",
#' github.password="password") or specifiy them in the function call.  Please note
#' that this method stores you password as clear text and use accordingly.}
#' 
#' 
#' @param repo github reponame
#' @param username github username
#' @param ssh logical to indicate which method to push with.  
#'            ssh=TRUE uses ssh, ssh=False uses https.
#' @family publish
#' @export
publish_github <- function(repo, username = getOption('github.user'), ssh = TRUE, 
                           password = getOption('github.password')){
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
  # check if .nojekyll exists, else add it to the repo
  if (!file.exists('.nojekyll')){
    message("Adding .nojekyll to your repo...")
    file.create(".nojekyll")
  }
  message('Publishing deck to ', username, '/', repo)
  system('git add .')
  system('git commit -a -m "publishing deck"')
  if(ssh){
    system(sprintf('git push git@github.com:%s/%s gh-pages', username, repo))
  } else {
    remote<-system('git config --get remote.origin.url',intern=TRUE)
    push<-sprintf("git remote set-url origin https://%s:%s@github.com/%s/%s.git",
                    username,password,username,repo)
    system(push)
  }
  # As of 3/6/14 Tested only on Win 7, Pro, R 3.0.2, RStudio 0.98.501
  system('git push origin gh-pages')
  #changes back to original remote so as not to store password inside of .git
  system(sprintf('git remote set-url origin %s', remote))
  
  link = sprintf('http://%s.github.com/%s', username, repo)
  message('You can now view your slide deck at ', link)
  browseURL(link)
}

#' Publish slide deck to Dropbox
#' 
#' @param dirname name of directory to publish to; defaults to slide directory
#' @family publish
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

#' Publish slide deck to gist
#' 
#' @param title title of the presentation
#' @param files list of files to publish, defaults to index.* files
#' @export
publish_gist <- function(title, 
  filenames = dir(".", pattern = "index"), public = T){
  require(httr)
  files = lapply(filenames, function(file) {
    x = list(content = paste(readLines(file, warn = F), collapse = "\n"))
  })
  names(files) = basename(filenames)
  body = list(description = title, files = files, public = public)
  
  credentials = getCredentials()
  response = POST(
    url = "https://api.github.com/gists", 
    body = rjson::toJSON(body), 
    config = c(
      authenticate(
        getOption("github.username"), 
        getOption("github.password"), 
        type = "basic"
    ), 
    add_headers(`User-Agent` = "Dummy"))
  )
  html_url = content(response)$html_url
  message("Your deck has been published")
  message("View deck at ", paste('http://bl.ocks.org',   
   getOption('github.username'), "raw", basename(html_url), sep = "/")
  )
}

#' @internal
getCredentials = function (){
  if (is.null(getOption("github.username"))){
    username <- readline("Please enter your github username: ")
    options(github.username = username)
  }
  if (is.null(getOption("github.password"))){
    password <- readline("Please enter your github password: ")
    options(github.password = password)
  }
}




#' Copy directories recursively, creating a new directory if not already there
#' 
#' @keywords internal
#' @noRd
copy_dir <- function(from, to){
  if (!(file.exists(to))){
    dir.create(to, recursive = TRUE)
    message('Copying files to ', to, '...')
    file.copy(list.files(from, full.names = T), to, recursive = TRUE)
  }
}

#' Copy libraries: framework, highlighter and widgets
#' 
#' @keywords internal
#' @noRd
copy_libraries <- function(framework, highlighter, widgets, url_lib, pkg = 'slidifyLibraries'){
  copy_resource <- function(subdir, resource){
    copy_dir(
     from = system.file('libraries', subdir, resource, package = pkg),
     to = file.path(url_lib, subdir, resource)
    )
  }
  copy_resource('frameworks', framework)
  copy_resource('highlighters', highlighter)
  invisible(lapply(widgets, copy_resource, subdir = 'widgets'))
}

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
  copy_dir(
    from = system.file('libraries', 'frameworks', framework, package = pkg),
    to = file.path(url_lib, 'frameworks', framework)
  )
  copy_dir(
    from = system.file('libraries', 'highlighters', highlighter, package = pkg),
    to = file.path(url_lib, 'highlighters', highlighter)
  )
  for (widget in widgets){
    copy_dir(
      from = system.file('libraries', 'widgets', widget, package = pkg),
      to = file.path(url_lib, 'widgets', widget)
  )}  
}

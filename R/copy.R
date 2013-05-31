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
  # stop and give an error message if slidifyLibraries is not installed
  if (!is_installed("slidifyLibraries")){
    stop("Please install slidifyLibraries");
  }
  copy_resource('frameworks', framework)
  copy_resource('highlighters', highlighter)
  invisible(lapply(widgets, copy_resource, subdir = 'widgets'))
}

#' Copy external widgets from other libraries
#' 
#' @keywords internal
#' @noRd
copy_external_widgets <- function(ext_widgets, url_lib){
  ext_widget_paths = lapply(names(ext_widgets), function(e){
    x = strsplit(ext_widgets[[e]], '/')
    y = function(...){ system.file(..., package = e) }
    sapply(x, function(z) do.call('y', as.list(z)))
  })
  invisible(lapply(unlist(ext_widget_paths), function(epath){
     copy_dir(
       from = epath,
       to = file.path(url_lib, 'widgets', basename(epath))
     )
  }))
}

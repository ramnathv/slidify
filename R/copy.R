#' Copy directories recursively, creating a new directory if not already there
copy_dir <- function(from, to){
	if (!(file.exists(to))){
		dir.create(to, recursive = TRUE)
		message('Copying files to ', to, '...')
		file.copy(list.files(from, full = T), to, recursive = TRUE)
	}
}

#' Copy libraries: framework, highlighter and widgets
copy_libraries <- function(framework, highlighter, widgets){
	copy_dir(
		from = system.file('libraries', 'frameworks', framework, package = 'slidify'),
		to = file.path('libraries', 'frameworks', framework)
	)
	copy_dir(
		from = system.file('libraries', 'highlighters', highlighter, package = 'slidify'),
		to = file.path('libraries', 'highlighters', highlighter)
	)
	for (widget in widgets){
		copy_dir(
			from = system.file('libraries', 'widgets', widget, package = 'slidify'),
			to = file.path('libraries', 'widgets', widget)
	)}	
}

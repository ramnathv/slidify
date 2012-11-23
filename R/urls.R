add_urls <- function(deck){
  urls = with(deck, modifyList(url, list(
    widgets    = file.path(url$lib, 'widgets'),
    framework = file.path(url$lib, 'frameworks', framework),
    theme = file.path(url$lib, 'frameworks', framework, theme),
    highlighters = file.path(url$lib, 'highlighters')
  )))
  urls$layouts = with(urls, c(
    file.path(framework, 'layouts'),
    file.path(assets, 'layouts'),
    file.path(widgets, deck$widgets, 'layouts')
  ))
  urls$highlighter = file.path(urls$highlighters, deck$highlighter)
  # this line should not be essential given default is set to 'assets'
  #   if (is.null(urls$assets)){
  #     urls$assets = 'assets'
  #   }
  deck$url = urls
  return(deck)
}

url_defaults <- function(deck){
  urls = deck$url
  # Framework and Theme URL Defaults -------
  urls$frameworks   = file.path(urls$lib, 'libraries', 'frameworks')
  urls$framework    = file.path(urls$frameworks, deck$framework)
  urls$theme        = file.path(urls$framework, deck$theme)
  # Highlighter URL Defaults ---------------
  urls$highlighters = file.path(urls$lib, 'highlighters')
  urls$highlighter  = file.path(urls$highlighters, deck$highlighter)
  # Widgets and Assets URL Defaults --------
  urls$widgets      = file.path(urls$lib, 'widgets')
  urls$assets       = 'assets'
  # Layout URL Defaults
  urls$layouts = with(urls, c(
    file.path(theme, 'layouts'),
    file.path(assets, 'layouts'),
    file.path(widgets, deck$widgets, 'layouts')
  ))
}

set_urls <- function(deck){
  urls = deck$url
  # Framework and Theme URL Defaults -------
  urls$frameworks   = file.path(urls$lib, 'libraries', 'frameworks')
  urls$framework    = file.path(urls$frameworks, deck$framework)
  urls$theme        = file.path(urls$framework, deck$theme)
  # Highlighter URL Defaults ---------------
  urls$highlighters = file.path(urls$lib, 'highlighters')
  urls$highlighter  = file.path(urls$highlighters, deck$highlighter)
  # Widgets and Assets URL Defaults --------
  urls$widgets      = file.path(urls$lib, 'widgets')
  urls$assets       = 'assets'
  # Layout URL Defaults
  urls$layouts = with(urls, c(
    file.path(theme, 'layouts'),
    file.path(assets, 'layouts'),
    file.path(widgets, deck$widgets, 'layouts')
  ))
}
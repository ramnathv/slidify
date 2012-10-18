# Overview #

Slidify makes it easy to create, customize and publish, reproducible HTML5 slide decks from [`R Markdown`](http://goo.gl/KKdaf). 

It is designed to make it very easy for a HTML novice to generate a crisp, visually appealing `HTML5` slide deck, while at the same time giving advanced users several options to customize their presentation.

The guiding philosophy of `slidify` is to completely separate writing of content from its rendering, so that content can be written once in `R Markdown`, and rendered as an `HTML5` presentation using any of the `HTML5` slide frameworks supported.

---

## Install Slidify ##

This package is not available on `CRAN` as yet. A development version can be installed from `github` using the `devtools` package. 

```R
library(devtools)
install_github('slidify', 'ramnathv')
```

In addition to `slidify`, you would also need to install development versions of [`knitr`](http://github.com/yihui/knitr), [`whisker`](http://github.com/edwindj/whisker) and [`markdown`](http://github.com/rstudio/knitr).

```R
install_github('knitr', 'yihui')
install_github('whisker', 'edwindj')
install_github('markdown', 'rstudio')
```

---

## Customize ##

Slidify is designed to be modular and provides a high degree of customization for the more advanced user. You can access the defaults using `slidifyDefaults()`. It is possible to override options by passing it to `slidify` as a named list or as a `yaml` file.

```text
framework      : slide generation framework to use
theme          : theme to use for styling slide content
highlighter    : tool to use for syntax highlighting
hitheme        : style to use for syntax highlighting
copy_libraries : copy library files to slide directory?
url            : paths to lib
widgets        : widgets to include
embed          : embed local images ?
```


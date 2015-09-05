![slidify_logo](https://f.cloud.github.com/assets/346288/650134/894eadd0-d455-11e2-8be5-8d463050f4ef.png) 

Slidify helps you create and publish beautiful HTML5 presentations from [RMarkdown](http://goo.gl/KKdaf)

## Getting Started


### Install ###

Slidify is still under heavy development. You can install it from `github` using the `devtools` package. You will also need `slidifyLibraries` which contains all external libraries required by `slidify`.

```r
install_github('ramnathv/slidify')
install_github('ramnathv/slidifyLibraries')
```

### Initialize ###

You can initialize a presentation by running `create`. This will create a scaffold for your presentation and open an Rmd file for you to edit. 

```r
library(slidify)
author('mydeck')
```

### Author ###

Write your presentation in RMarkdown, using a newline followed by three dashes to separate slides. You can mix markdown with code chunks to create a reproducible slide deck. 

### Generate ###

Generate your presentation by running `slidify`. This will create a static HTML5 presentation that you can open locally in your browser.

```r
slidify('index.Rmd')
```

### Publish ###

```r
# publish to github
# create an empty repo on github. replace USER and REPO with your repo details
publish(user = USER, repo = REPO) 

# publish to rpubs
publish(title = 'My Deck', 'index.html', host = 'rpubs')
```

---

## Customize ##

Slidify is designed to be modular and provides a high degree of customization for the more advanced user. You can access the defaults using `slidifyDefaults()`. It is possible to override options by passing it to `slidify` as a named list or as a `yaml` file.

```text
framework      : slide generation framework to use
theme          : theme to use for styling slide content
highlighter    : tool to use for syntax highlighting
hitheme        : style to use for syntax highlighting
mode           : selfcontained, standalone, draft
url            : paths to lib
widgets        : widgets to include
```


Slidify makes it easy to create, customize and publish, reproducible HTML5 slide decks from [`R Markdown`](http://goo.gl/KKdaf). 

It is designed to make it very easy for a HTML novice to generate a crisp, visually appealing `HTML5` slide deck, while at the same time giving advanced users several options to customize their presentation.

The guiding philosophy of `slidify` is to completely separate writing of content from its rendering, so that content can be written once in `R Markdown`, and rendered as an `HTML5` presentation using any of the `HTML5` slide frameworks supported.


---
title: Slidify
subtitle: Reproducible HTML5 Slides
author: Ramnath Vaidyanathan
job: Assistant Professor, McGill 
logo: slidify_logo.png
biglogo: slidify_logo.png
license: by-nc-sa
widgets: [mathjax, bootstrap, quiz]
github:
  user: ramnathv
  repo: slidify
mode: selfcontained
hitheme: solarized_light
--- .quote .nobackground .segue .dark

<q> Slidify is a tool that makes it easy to create, customize and publish, reproducible HTML5 slide decks using R Markdown.</q>

---

## Install Slidify

Slidify can be installed from `github`.

```
install.packages('devtools')
require(devtools)
install_github('slidify', 'ramnathv')
```

You also need to install dependencies from `github`

```
install_github('knitr', 'yihui')
install_github('whisker', 'edwindj')
install_github('markdown', 'rstudio')
```

--- .quote .segue .nobackground .dark

<q>Slidify is a tool that makes it easy to <span class = 'red'>create</span>, customize and publish, reproducible HTML5 slide decks using R Markdown.</q>

---

## Initialize Slide Deck

You can initialize a slide deck using the `create_deck` function.

```r
create_deck("mydeck")
```

It creates a directory for your slides with the appropriate scaffolding. In addition, specifying `git = TRUE` initializes the directory as a git repository and creates a gh-pages branch by default.

---

## Write Slides ##

Write in [R Markdown](http://goo.gl/KKdaf), separating slides by a blank link line followed by a horizontal rule `---`.

    ---

  	## My First Slidify Deck
  
    ---
  
    ## Slide 1
  
    This is an unordered list which is animated
  
      >	- Point 1
      >	- Point 2
      >	- Point 3
      >	- Point 4

---

## My First Slidify Deck


---

## Slide 1

This is an unordered list which is animated

> - Point 1
> - Point 2
> - Point 3
> - Point 4

---

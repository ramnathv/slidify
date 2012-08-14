# Overview #

Slidify makes it easy to create, customize and publish, reproducible HTML5 slide decks from [`R Markdown`](http://goo.gl/KKdaf). 

It is designed to make it very easy for a HTML novice to generate a crisp, visually appealing `HTML5` slide deck, while at the same time giving advanced users several options to customize their presentation.

The guiding philosophy of `slidify` is to completely separate writing of content from its rendering, so that content can be written once in `R Markdown`, and rendered as an `HTML5` presentation using any of the `HTML5` slide frameworks supported.

---

### Install Slidify ###

This package is not available on `CRAN` as yet. A development version can be installed from `github` using the `devtools` package. 

```R
library(devtools)
install_github('slidify', 'ramnathv')
```

In addition to `slidify`, you would also need to install development versions of [`knitr`](http://github.com/yihui/knitr), [`whisker`](http://github.com/edwindj/whisker) and [`markdown`](http://github.com/rstudio/markdown).

```R
install_github('knitr', 'yihui')
install_github('whisker', 'edwindj')
install_github('markdown', 'rstudio')
```

---

## Create ##

---

### Initialize Deck ###

You can initialize a slide deck using `create_deck()`. If you have `git` installed, you can passing the option `git = TRUE` to automatically initialize a git repository, which will come in handy for publishing to `gh-pages`. 

```R
create_deck('mydeck', git = TRUE)
```

This will create a skeleton for your presentation

    mydeck
      assets
        media
        stylesheets
        scripts
      index.Rmd

---

### Write Deck ###

Write your presentation in [R Markdown](http://goo.gl/KKdaf), using a blank line followed by a horizontal rule `---` to separate slides. 


```markdown
  ---
  
  # My First Slidify Deck
  by Ramnath Vaidyanathan
  
  ---
  
  ### Slide 1
  
  This is an unordered list 
  
  - Point 1
  - Point 2
  - Point 3
  - Point 4
  
  ---
```

---

### Run Slidify ###

Generate your presentation by running `slidify` 

```R
slidify('index.Rmd')
```

---

## Customize ##

Slidify is designed to be modular and provides a high degree of customization for the more advanced user. You can access the defaults using `slidifyDefaults()`. It is possible to override options by passing it to `slidify` as a named list or as a `yaml` file.

```text
framework      : slide generation framework to use
theme          : theme to use for styling slide content
highlighter    : tool to use for syntax highlighting
histyle        : style to use for syntax highlighting
copy_libraries : copy library files to slide directory?
lib_path       : path to libraries 
mathjax        : use mathjax ?
embed          : embed local images ?
```

### Add Slide Classes ###

You can add slide classes and id by appending them to the slide separator. 

```R
  --- fill #montreal
  
  ### Montreal by Night Time
  
  ![monteral](http://goo.gl/cF6W2)
  
  
  --- middle
  
  Slidify is Awesome
  
```

---

### Use Alternate Frameworks ###

Use the options `framework` and `theme` to style your deck using your favorite presentation framework. The slide generation frameworks currently supported are [html5slides](http://html5slides.googlecode.com/), [html5rocks](), [deck.js](http://imakewebthings.com/deck.js/), [dzslides](http://paulrouget.com/dzslides/), [landslide](https://github.com/adamzap/landslide), [shower](http://pepelsbey.github.com/shower/en.htm), [slidy](http://www.w3.org/Talks/Tools/Slidy2/Overview.html#)

Files in `assets/stylesheets` and `assets/scripts` are automatically included in the compiled deck, giving you additional styling options.

---

### Highlight Source Code ###

Use the options `highlighter` and `histyle` to control syntax highlighting of source code. The highlighters currently supported are `highlight`, `highlight.js` and `google_prettify`

---

## Publish ##


`slidify` is designed to make the entire process from writing your slides to publishing them online easy. You can publish your deck on `RPubs` using two lines of code.

```R
slidify('slides.Rmd', options = list(embed = TRUE))
rpubsUpload('My First Presentation', 'slides.html')
```

Development is underway to provide support for publishing to Github Pages, Dropbox and Amazon S3

---

## License ##

`slidify` is made available under the MIT License. All the `js` and `css` files are licensed under the terms specified by the respective vendor packages.

**MIT License**

Copyright (C) 2012 Ramnath Vaidyanathan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## Credits ##

`slidify` builds on HTML5 slide frameworks and syntax highlighters created by several individuals and organizations. I would like to thank the authors of these packages.


I have borrowed ideas and features from HTML5 slide converters written in other languages. I would like to acknowledge contributions of the authors of [showoff](http://github.com/schacon/showoff), [slideshow](https://github.com/geraldb/slideshow), [keydown](https://github.com/infews/keydown), [hieroglyph](https://github.com/nyergler/hieroglyph), [landslide](https://github.com/adamzap/landslide) and [pandoc](https://github.com/jgm/pandoc)


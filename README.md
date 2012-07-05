### Overview ###

The objective of `slidify` is to make it easy to create reproducible HTML5 presentations from `.Rmd` files. 

The guiding philosophy of `slidify` is to completely separate writing of content from its rendering, so that content can be written once in `R Markdown`, and rendered as an `HTML5` presentation using any of the `HTML5` slide frameworks supported.

---

### Installing Slidify ###

This package is not available on `CRAN` as yet. A development version can be installed from `github` using the `devtools` package. 

```R
library(devtools)
install_github('slidify', 'ramnathv')
```

In addition to `slidify`, you would also need to install development versions of `knitr`, `whisker` and `markdown`.

```{r eval = F}
install_github('knitr', 'yihui')
install_github('whisker', 'edwindj')
install_github('markdown', 'rstudio')
```
 
---

### Creating Your First Deck ###

`slidify` is designed to make it very easy for a HTML novice to generate a crisp, visually appealing `HTML5` slide deck. Just write your presentation using [R Markdown](http://goo.gl/KKdaf), separating your slides by a horizontal rule `---` and run `slidify`.


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

### Adding Slide Classes ###

You can add slide classes and id by appending them to the slide separator. 

```R
  --- fill #montreal
  
  ### Montreal by Night Time
  
  ![monteral](http://goo.gl/cF6W2)
  
  
  --- middle
  
  Slidify is Awesome
  
```

---

### Customize Your Presentation ###

`slidify` is designed to be modular and provides a high degree of customization for the more advanced users.

 Option         | Description
 -------------- | ------------
 framework      | slide generation framework to use
 theme          | theme to use for styling slide content
 highlighter    | tool to use for syntax highlighting
 histyle        | style to use for syntax highlighting
 copy_libraries | copy library files to slide directory?
 lib_path       | path to libraries 
 mathjax        | use mathjax ?
 embed          | embed local images ?
 
---

### Styling your Slides! ###

Use the options `framework` and `theme` to style your deck using your favorite presentation framework. Currently supported frameworks and themes are listed below. Extending `slidify` to accommodate other frameworks is pretty straightforward and the plan is to support more over time.

 framework | theme
 --------- | --------------------
 [html5slides](http://html5slides.googlecode.com/) | layout-default template-default
 [html5rocks]() |
 [deck.js](http://imakewebthings.com/deck.js/)     | web2.0, swiss, neon
 [dzslides](http://paulrouget.com/dzslides/)       | 
 [landslide](https://github.com/adamzap/landslide) | default, tango, clean
 [shower](http://pepelsbey.github.com/shower/en.htm) | ribbon
 [slidy](http://www.w3.org/Talks/Tools/Slidy2/Overview.html#) |
 [slideous]() |
 [beamer]() | 

---

### Highlighting Source Code ###

Use the options `highlighter` and `histyle` to control syntax highlighting of source code.

 highlighter     | histyle
 --------------  | ------------
 highlight       | see `knit_theme$get()`
 highlight.js    | see http://goo.gl/uEJj
 google_prettify | see http://goo.gl/yUikj


---

### Publishing Your Deck ###

`slidify` is designed to make the entire process from writing your slides to publishing them online easy. You can publish your deck on `RPubs` using two lines of code.

```
slidify('slides.Rmd', options = list(embed = TRUE))
rpubsUpload('My First Presentation', 'slides.html')
```

Development is underway to provide support for publishing to 

 * Github Pages
 * Dropbox
 * Amazon S3

---

# Credits #

---

### R Packages ###

All the heavy lifting is actually done by three awesome R packages. `slidify` is merely a wrapper around them.

 Package | Author
 ------- | ------ 
 [knitr](http://github.com/yihui/knitr) | Yihui Xie 
 [markdown](http://github.com/rstudio/knitr) | Jeffrey Horner
 [whisker](http://github.com/edwindj/whisker) | Edwin de Jonge

---

### HTML5 Slide Frameworks ###

`slidify` builds on HTML5 slide frameworks created by several individuals and organizations. I would like to acknowledge their work and efforts.

 Framework | Author  | License
 --------- | ------- | -------
 [HTML5Slides](http://code.google.com/p/html5slides/) | Luke Mah, Marcin Wichary | Apache
 [deck.js](https://github.com/imakewebthings/deck.js) | Caleb Troughton |  MIT/GPL
 [dzslides](https://github.com/paulrouget/dzslides) | Paul Roget | DWTFYW
 [html5rocks](http://slides.html5rocks.com/) | Google | Apache
 [Landslide](https://github.com/adamzap/landslide)| Adam Zapletal| Apache
 [Shower](https://github.com/pepelsbey/shower) | Vadim Makeev | MIT
 [slidy](http://www.w3.org/Talks/Tools/Slidy2/Overview.html#) | Dave Ragett  | MIT
 [slideous]() | Stefan Goessner | LGPL

---

### Syntax Highlighters ###


Syntax highlighting is powered by open source highlighters. I would like to than the authors of these tools.

  Highighter | Author  | License
 --------- | ------- | -------
 [highlight.js](https://github.com/isagalaev/highlight.js) | Software Maniacs | MIT
 [Google Prettify](http://code.google.com/p/google-code-prettify/)| Google| Apache
 [highlight](http://cran.r-project.org/web/packages/highlight/index.html)| Romain Francois | GPL

---

### Markdown-HTML5 Converters ###

I have extensively borrowed ideas and features from HTML5 slide converters written in other languages. I would like to acknowledge contributions of these authors.

 Language | Framework 
 -------- | -----------
 Ruby     | [showoff](http://github.com/schacon/showoff)   
 Ruby     | [slideshow](https://github.com/geraldb/slideshow)  
 Ruby     | [keydown](https://github.com/infews/keydown)   
 Python   | [hieroglyph](https://github.com/nyergler/hieroglyph)  
 Python   | [landslide](https://github.com/adamzap/landslide) 
 Haskell  | [pandoc](https://github.com/jgm/pandoc)

---

### License ###

`slidify` is made available under the MIT License

**MIT License**

Copyright (C) 2012 Ramnath Vaidyanathan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


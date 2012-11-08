USER     := ramnathv
REPO     := slidify
SRCFILES := $(wildcard *.Rmd)
PAGES    := $(patsubst %.Rmd, %.html, $(SRCFILES))

pages: $(PAGES) config.yml 

deploy: pages
	git add . && \
	git commit -m 'update docs'; \
	git push git@github.com:$(USER)/$(REPO) master:gh-pages

deploy0:
	git init . && \
	git add . && \
	git commit -m 'update docs'; \
	git push git@github.com:$(USER)/$(REPO) master:gh-pages --force && \
	rm -rf .git

%.html: %.Rmd config.yml
	Rscript -e "slidify::slidify('$<', '$@')"
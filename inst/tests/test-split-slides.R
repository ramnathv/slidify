context('Splitting Slides')

test_that("Slides are split on --- preceded by an empty newline", {
	deck = read_file('decks/deck1.Rmd') 
	out   = c("## Slide 1\n\nContents", "\n\n## Slide 2\n\nContents")
	expect_equal(split_slides(deck), out)
})

test_that("Slides are NOT split on --- NOT preceded by an empty newline", {
	deck = read_file('decks/deck2.Rmd') 
	out = c("## Slide 1\n\nContents", "\n\n## Slide 2\n\nSubheading\n----\n\nContents")
	expect_equal(split_slides(deck), out)
})

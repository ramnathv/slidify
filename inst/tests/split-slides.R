context('Splitting Slides')

test_that("Slides are split on \n\n---", {
	slides = '## Slide 1\n Contents\n\n--- ## Slide 2\n\n Contents'
	out   = c("## Slide 1\n Contents", " ## Slide 2\n\n Contents")
	expect_equal(split_slides(slides), out)
})

test_that("Slides are NOT split on \n---", {
	slides = '## Slide 1\n Contents\n\n--- Slide2\n---\n Contents'
	out = c("## Slide 1\n Contents", " Slide2\n---\n Contents")
	expect_equal(split_slides(slides), out)
})
		 
		 
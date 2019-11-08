context("test-check")

test_that("there's an error with non-data.frame input", {
  expect_error(altcheckr::alt_check("a string"))  # character
  expect_error(altcheckr::alt_check(1))  # numeric
  expect_error(altcheckr::alt_check(TRUE))  # logical
  expect_error(altcheckr::alt_check(bare_text))  # bare
  expect_error(altcheckr::alt_check(iris$Species))  # vector
})

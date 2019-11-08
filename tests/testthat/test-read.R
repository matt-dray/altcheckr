context("test-read")

test_that("there's an error with non-character input", {
  expect_error(altcheckr::alt_get_attr(1))  # numeric
  expect_error(altcheckr::alt_get_attr(TRUE))  # logical
  expect_error(altcheckr::alt_get_attr(bare_text))  # bare
  expect_error(altcheckr::alt_get_attr(iris))  # data.frame
  expect_error(altcheckr::alt_get_attr(iris$Species))  # vector
})

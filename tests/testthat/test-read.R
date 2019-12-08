context("test-read")

test_that("url fails with non-character value as input", {
  expect_error(altcheckr::alt_get(webpage = 1))
  expect_error(altcheckr::alt_get(webpage = TRUE))
  expect_error(altcheckr::alt_get(webpage = NA))
  expect_error(altcheckr::alt_get(webpage = NULL))
  expect_error(altcheckr::alt_get(webpage = test_vec_num))
  expect_error(altcheckr::alt_get(webpage = test_vec_char))
  expect_error(altcheckr::alt_get(webpage = test_vec_fct))
  expect_error(altcheckr::alt_get(webpage = test_vec_lgl))
  expect_error(altcheckr::alt_get(webpage = test_mat))
  expect_error(altcheckr::alt_get(webpage = test_df))
  expect_error(altcheckr::alt_get(webpage = test_list))
})

test_that("all_attributes fails with non-logical input", {
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = 1))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = NA))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = NULL))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = test_vec_num))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = test_vec_char))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = test_vec_fct))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = test_mat))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = test_df))
  expect_error(altcheckr::alt_get(webpage = test_url, all_attributes = test_list))
})

test_that("invalid URLs can't be reached", {
  expect_error(altcheckr::alt_get(webpage = "a"))
  expect_error(altcheckr::alt_get(webpage = test_url_resolve))
})

test_that("valid URL returns expected output class", {
  expect_equal(class(altcheckr::alt_get(webpage = test_url, all_attributes = FALSE)), out_get_class)
  expect_equal(class(altcheckr::alt_get(webpage = test_url, all_attributes = TRUE)), out_get_class)
})

test_that("columns in output are expected", {
  expect_equal(length(altcheckr::alt_get(webpage = test_url, all_attributes = FALSE)), 2)
  expect_true(length(altcheckr::alt_get(webpage = test_url, all_attributes = TRUE)) >= 2)
  expect_true(all(names(altcheckr::alt_get(webpage = test_url, all_attributes = FALSE)) == out_get_names))
  expect_true(any(names(altcheckr::alt_get(webpage = test_url, all_attributes = TRUE)) == out_get_names))
})
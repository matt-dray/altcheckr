context("test-check")

test_that("there's an error with non-data.frame input to attributes_df", {
  expect_error(altcheckr::alt_check(attribute_df = 1))
  expect_error(altcheckr::alt_check(attribute_df = TRUE))
  expect_error(altcheckr::alt_check(attribute_df = NA))
  expect_error(altcheckr::alt_check(attribute_df = NULL))
  expect_error(altcheckr::alt_check(attribute_df = test_vec_num))
  expect_error(altcheckr::alt_check(attribute_df = test_vec_char))
  expect_error(altcheckr::alt_check(attribute_df = test_vec_fct))
  expect_error(altcheckr::alt_check(attribute_df = test_vec_lgl))
  expect_error(altcheckr::alt_check(attribute_df = test_mat))
  expect_error(altcheckr::alt_check(attribute_df = test_list))
})

test_that("there's an error with non-numeric input to min/max_char", {
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = TRUE))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = NA))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = NULL))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_vec_num))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_vec_char))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_vec_fct))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_vec_lgl))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_df))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_mat))
  expect_error(altcheckr::alt_check(attribute_df = test_attributes_df, min_char = test_list))
})

test_that("structure of output data.frame is as expected", {
  expect_equal(class(altcheckr::alt_check(test_attributes_df)), out_get_class)
})
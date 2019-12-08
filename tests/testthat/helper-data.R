# Inputs

test_vec_num <- c(1, 2, 3)
test_vec_char <- c("a", "b", "c")
test_vec_fct <- as.factor(test_vec_char)
test_vec_lgl <- c(TRUE, FALSE, TRUE)

test_mat <- matrix(c(1:3, c(letters[1:3]), c(TRUE, FALSE, TRUE)), 3, 3)
test_df <- as.data.frame(test_mat)
test_list <- as.list(test_df)

test_url <- "https://rostrum.blog"
test_url_404 <- "https://rostrum.blog/invalidtestpage"
test_url_resolve <- "https://testrostrumdomain.blog"

test_attributes_df <- dplyr::tibble(
  src = rep("path/to/test_file.jpg", 7),
  alt = c(
    NA_character_,
    "",
    " ",
    "Short",
    "This has a terminal period.",
    "This passage of text is an example of an alt text description that is very long and exceeds 125 characters in length. It could probably be made more succinct.",
    "test_file.jpg"
  )
)

# Outputs

out_get_class <- c("tbl_df", "tbl", "data.frame")
out_get_names <- c("src", "alt")
out_check_names <- c(
  "src", "alt", "alt_exists", "nchar_count", "nchar_assess", "file_ext",
  "self_evident", "terminal_punct", "spellcheck", "not_basic"
)

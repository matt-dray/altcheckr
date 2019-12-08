## code to prepare `example_get` dataset goes here

example_get <- tibble::tibble(
  src = "source.jpg",
  alt = c(
    NA,
    "",
    " ",
    "   ",
    "Short.",
    "source.jpg",
    "This is a long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long sentence.",
    "A perfectly cromulent word?",
    "A picture of a chart.",
    "No terminal punctuation",
    "There are some speling mistaeks in this teext!"
  )
)

usethis::use_data("example_get")
# usethis::use_data(example_get, overwrite = TRUE)

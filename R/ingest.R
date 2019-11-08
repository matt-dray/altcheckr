#' Get a Web Page's Image Attributes
#'
#' @description Scrapes a web page and extracts the image tags into a data frame.
#' @param url A string describing the URL of a webpage.
#' @return A data.frame object.
#' @export

alt_get_attr <- function(url) {
  
  # Stop if not a character string
  if (!is.character(url)) {
    stop("Input to the url argument must be a character string")
  }
  
  # Read the full HTML of a page
  page_html <- xml2::read_html(url)
  
  # Just extract the img element content
  img_df <- page_html %>% 
    rvest::html_nodes("img") %>% 
    purrr::map(xml2::xml_attrs) %>% 
    purrr::map_df(~as.list(.))
  
  # Return the tibble
  return(img_df)
  
}

#' Check for Image Alt Tag Problems
#'
#' @description Infer whether an image's alt tag is missing or could be improved.
#' @param attr_df A data.frame/tibble with image attributes produced by \code{altcheckr::alt_get_attr()}.
#' @return A data.frame/tibble object.
#' @export

alt_check <- function(attr_df) {
  
  # Stop if not a data frame
  if (!is.data.frame(attr_df)) {
    stop("Input to the attr_df argument must be of class data.frame")
  }
  
  # Check for alt issues
  alt_df <- attr_df %>% 
    dplyr::mutate(
      # check for missing alt text
      missing = ifelse(is.na(alt), TRUE, FALSE),
      # check for too long or short
      length = dplyr::case_when(
        is.na(alt) ~ NA_character_,
        nchar(alt) > 200 ~ "Long",
        nchar(alt) < 50 ~ "Short",
        TRUE ~ "OK"
      ),
      # check for self-evident phrases
      self_evident = ifelse(
        stringr::str_detect(
          tolower(alt),
          "image of|picture of|image showing|picture showing"
        ), TRUE, FALSE
      ),
      # check for terminal period
      period = ifelse(stringr::str_detect(alt, ".$"), TRUE, FALSE)
    )
  
  # Return
  return(alt_df)

}
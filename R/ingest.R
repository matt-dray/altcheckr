#' Get the Image Attributes for a Given Page
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

#' Check for Alt Tag Problems
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
  
  # Check for alt
  alt_df <- attr_df %>% 
    dplyr::mutate(
      missing = ifelse(
        is.na(alt),
        "Missing",
        "Not missing"
      )
    )
  
  # Return
  return(alt_df)

}
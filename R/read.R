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

#' Get HTML Attributes from the Image Elements of a Web Page
#'
#' @description Scrape a web page's HTML and extract into a tibble the attributes
#'     from each image element. Only collects attributes if they exist.
#' @param url A character string describing the URL of a webpage.
#' @param all_attributes Logical. Do you want to return all the image attributes
#'     (\code{TRUE}), or just the \code{src} (image source) and \code{alt}
#'     (alt text) attributes (\code{FALSE})?
#' @return A tibble object with classes "tbl_df", "tbl", "data.frame").
#' @export

alt_get <- function(url, all_attributes = FALSE) {
  
  # Stop for argument input problems 
  if (!is.character(url)) {
    stop("Input to the url argument must be a character string.")
  } else if (!is.logical(all_attributes)) {
    stop("Input to the all_attributes argument must be logical (TRUE or FALSE).")
  }
  
  # Read the full HTML from the URL provided
  page_html <- xml2::read_html(url)
  
  # Extract attributes from the img HTML elements only
  img_df <- page_html %>% 
    rvest::html_nodes("img") %>% 
    purrr::map(xml2::xml_attrs) %>% 
    purrr::map_df(~as.list(.))
  
  # Create an alt column if it doesn't exist
  if (!any(names(img_df) == "alt")) img_df$alt <- NA_character_

  # Keep all attribute columns or just src and alt (user specified)
  if (all_attributes == FALSE) img_df <- img_df[, c("src", "alt")]
  
  # Return the tibble
  return(img_df)
  
}

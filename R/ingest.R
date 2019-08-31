#' Get the Image Attributes for a Given Page
#'
#' @description Scrapes a web page for the image tag and extracts the tags into a data frame.
#' @param url A string describing the URL of a webpage.
#' @return A data.frame object.
#' @export

alt_get_attr <- function(url) {
  
  page_html <- read_html(url)
  
  img_df <- page_html %>% 
    html_nodes("img") %>% 
    map(xml_attrs) %>% 
    map_df(~as.list(.))
  
  return(img_df)
  
}

#' Suggest Alt Tag Oddities
#'
#' @description Infer whether the alt tag is missing or strange.
#' @param attr_df A data.frame with image attributes produced by alt_get_attr().
#' @return A data.frame object.
#' @export

alt_check <- function(attr_df) {
  
  alt_df <- attr_df %>% 
    mutate(
      missing = ifelse(
        is.na(alt),
        "Missing",
        "Not missing"
      )
    )
  
  return(alt_df)

}
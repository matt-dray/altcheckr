#' Get the Image Attributes for a Given Page
#'
#' @description Scrapes a web page for the image tag and extracts the tags into a data frame.
#' @param url A string describing the URL of a webpage.
#' @return A data.frame object.
#' @export

alt_get_attr <- function(url) {
  
  page_html <- read_html(url)
  
  page_html %>% 
    html_nodes("img") %>% 
    map(xml_attrs) %>% 
    map_df(~as.list(.))
  
}
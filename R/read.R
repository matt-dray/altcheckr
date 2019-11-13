#' Get HTML Attributes from the Image Elements of a Web Page
#'
#' @description Scrape a web page's HTML and extract the attributes from each
#'     image element (\code{<img>}) on that page.
#' 
#' @param url A character string describing the URL of a webpage.
#' @param all_attributes Logical. Do you want to return \emph{all} the image
#'     attributes as columns or just \code{src}, \code{alt} and \code{longdesc}?
#' 
#' @return A tibble object with classes \code{tbl_df}, \code{tbl} and
#'     \code{data.frame}. One row per image element and one column per attribute,
#'     unless (\code{all_attributes = FALSE}), which returns only:
#'     \itemize{
#'         \item \code{src} The source of the image as a filepath.
#'         \item \code{alt} The alternative (alt) text for the image.
#'         \item \code{longdesc} The path to a file that contains a longer
#'         description for complex images (only returned if present).
#'     }
#' 
#' @export
#' 
#' @examples \dontrun{
#'     test_url <- "https://alphagov.github.io/accessibility-tool-audit/test-cases.html#images"
#'     alt_get(url = test_url)
#'     }

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
  
  # Reduce to only src and alt (and longdesc if it exists)
  if (all_attributes == FALSE & any(names(img_df) == "longdesc")) {
    img_df <- img_df[, c("src", "alt", "longdesc")]
  } else if (all_attributes == FALSE) {
    img_df <- img_df[, c("src", "alt")]
  }
  
  # Return the tibble
  return(img_df)
  
}

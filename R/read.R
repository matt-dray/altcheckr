#' Get HTML Attributes from the Image Elements of a Web Page
#'
#' @description Scrape (politely) a web page's HTML and extract the attributes
#'     from each image element (\code{<img>}) on that page.
#' 
#' @param webpage A character string describing the URL of a webpage. Must be a
#'     full path including \code{https://www.} where appropriate.
#' @param all_attributes Logical. Do you want to return \emph{all} the image
#'     attributes as columns or just \code{src}, \code{alt} and \code{longdesc}
#'     (if it exists)?
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
#'     test_url <- "https://www.bbc.co.uk/news"
#'     alt_get(webpage = test_url)
#'     }

alt_get <- function(webpage, all_attributes = FALSE) {
  
  # Stop for argument input problems 
  if (!is.character(webpage)) {
    stop("Input to the 'webpage' argument must be a character string.")
  } else if (!is.logical(all_attributes)) {
    stop("Input to the 'all_attributes' argument must be logical (TRUE or FALSE).")
  }
  
  # Begin {polite} session
  session <- suppressWarnings(polite::bow(webpage, force = TRUE))
  
  # Scrape page if allowed
  page_html <- polite::scrape(session)
  
  # Stop if NULL is received from session
  # Additional warnings output by {polite} if scraping isn't allowed
  if (is.null(page_html)) {
    stop("Cannot fetch content. NULL was returned from the scrape.")
  }
  
  # Extract attributes from the img HTML elements only, then make rectangular
  img_nodes <- rvest::html_nodes(page_html, "img")
  img_retrieve <- purrr::map(img_nodes, xml2::xml_attrs)
  img_df <- purrr::map_df(img_retrieve, ~as.list(.))
  
  # Create an empty alt column if it doesn't exist already
  if (!any(names(img_df) == "alt")) {
    img_df$alt <- NA_character_ 
  }
  
  # Simplify to only src and alt (and longdesc if it exists)
  if (all_attributes == FALSE & any(names(img_df) == "longdesc")) {
    img_df <- img_df[, c("src", "alt", "longdesc")]
  } else if (all_attributes == FALSE) {
    img_df <- img_df[, c("src", "alt")]
  }
  
  # Return the tibble
  return(img_df)
  
}

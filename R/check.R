#' Check for Image Alt Tag Problems
#'
#' @description Infer whether an image's alt tag is missing or could be improved.
#' @param attr_df A data.frame/tibble with image attributes produced by \code{altcheckr::alt_get_attr()}.
#' @return A data.frame/tibble object.
#' @importFrom rlang .data
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
      missing = ifelse(is.na(.data$alt), TRUE, FALSE),
      
      # check for too long or short
      length = dplyr::case_when(
        is.na(.data$alt) ~ NA_character_,
        nchar(.data$alt) > 200 ~ "Long",
        nchar(.data$alt) < 50 ~ "Short",
        TRUE ~ "OK"
      ),
      
      # check for self-evident phrases
      self_evident = ifelse(
        stringr::str_detect(
          tolower(.data$alt),
          "image of|picture of|image showing|picture showing"
        ), TRUE, FALSE
      ),
      
      # check for terminal period
      period = ifelse(stringr::str_detect(.data$alt, ".$"), TRUE, FALSE)
    )
  
  # Return
  return(alt_df)
  
}

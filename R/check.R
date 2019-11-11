#' Check for Problems with the Alt Text for Images on a Web Page
#'
#' @description Infer whether an image's alt tag is missing or could be improved.
#' @param attr_df A data.frame/tibble with image attributes, produced by
#'     \code{altcheckr::alt_get()}.
#' @param min_char A numeric value. If the number of characters in the alt
#'     text is smaller than this then it's flagged as being short.
#' @param max_char A numeric value. If the number of characters in the alt
#'     text is larger than this then it's flagged as being long
#' @param redundant_pattern A character string. Regular expression for phrase(s)
#'     to flag as being redundant in alt text ("A picture of" isn't necessary,
#'     for example).
#' @return A tibble object with classes "tbl_df", "tbl", "data.frame".
#' @importFrom rlang .data
#' @export

alt_check <- function(attr_df, max_char = 200, min_char = 50,
  redundant_pattern = "image of|picture of|photo of|image showing|picture showing"
) {
  
  # Stop if not a data frame
  if (!all(class(attr_df) %in% c("tbl_df", "tbl", "data.frame"))) {
    stop("Input to the attr_df argument must be of class tibble or data.frame.")
  } else if (!is.numeric(min_char)|!is.numeric(max_char)) {
    stop("Input to the min_char and max_char arguments must be a numeric value.")
  } else if (!is.character(redundant_pattern)) {
    stop("Input to the redundant_pattern argument must be a character string.")
  }
  
  # Check for alt issues
  alt_df <- dplyr::mutate(attr_df,
    
    # Check for missing alt text
    alt_empty = ifelse(is.na(.data$alt), TRUE, FALSE),
    
    # Check for short and long alt text
    char_length = dplyr::case_when(
      is.na(.data$alt) ~ NA_character_,
      nchar(.data$alt) < min_char ~ "Short",
      nchar(.data$alt) > max_char ~ "Long",
      TRUE ~ "OK"
    ),
    
    # Check for self-evident phrases
    self_evident = ifelse(stringr::str_detect(tolower(.data$alt), tolower(redundant_pattern)), TRUE, FALSE),
    
    # Check for terminal punctuation
    terminal_period = ifelse(stringr::str_detect(.data$alt, "\\.$"), TRUE, FALSE),
    
    # Highlight possible incorrect spellings
    spellcheck = ifelse(
      length(hunspell::hunspell(.data$alt)[[1]]) > 0,
      paste(hunspell::hunspell(.data$alt)[[1]], collapse = ", "), 
      NA
    ),
    
    # Give readability score
    readability = quanteda::textstat_readability(.data$alt)$Flesch
    
  ) %>% 
    dplyr::as_tibble()  # ensure tibble output
  
  # Return
  return(alt_df)
  
}

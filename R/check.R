#' Check for Problems with the Alt Text for Images on a Web Page
#'
#' @description Infer whether an image's alt tag is missing or could be improved.
#' @param attributes_df A data.frame/tibble with image attributes, produced by
#'     \code{altcheckr::alt_get()}.
#' @param min_char A numeric value. If the number of characters in the alt
#'     text is smaller than this then it's flagged as being short.
#' @param max_char A numeric value. If the number of characters in the alt
#'     text is larger than this then it's flagged as being long
#' @param file_ext A character string. Regular expression of image file
#'     extensions that might signify a file name has been used for the alt text.
#' @param redundant_pattern A character string. Regular expression for phrase(s)
#'     to flag as being redundant in alt text ("A picture of" isn't necessary,
#'     for example).
#' @return A tibble object with classes "tbl_df", "tbl", "data.frame".
#' @importFrom rlang .data
#' @export

alt_check <- function(
  attributes_df, max_char = 200, min_char = 50,
  file_ext = ".jpg$|.jpeg$|.png$|.svg$|.gif$",
  redundant_pattern = "image|picture|photo|graph|plot|diagram") {
  
  # Stop if not a data frame
  if (!all(class(attributes_df) %in% c("tbl_df", "tbl", "data.frame"))) {
    stop("Input to the attributes_df argument must be of class tibble or data.frame.")
  } else if (!is.numeric(min_char)|!is.numeric(max_char)) {
    stop("Input to the min_char and max_char arguments must be a numeric value.")
  } else if (!is.character(redundant_pattern)) {
    stop("Input to the redundant_pattern argument must be a character string.")
  }
  
  # Check for alt issues
  alt_df <- dplyr::mutate(attributes_df,
    
    # Check for empty/missing alt text
    alt_exists = dplyr::case_when(
      is.na(.data$alt) ~ "Missing",
      .data$alt == "" ~ "Empty",
      stringr::str_detect(.data$alt, "^[[:space:]]+$") ~ "Empty",
      TRUE ~ "Exists"
    ),
    
    # Check for short and long alt text
    char_length = dplyr::case_when(
      .data$alt_exists %in% c("Missing", "Empty") ~ NA_character_,
      nchar(.data$alt) < min_char ~ "Short",
      nchar(.data$alt) > max_char ~ "Long",
      TRUE ~ "OK"
    ),
    
    # Check for filename in alt (by virtue of an image file extension)
    file_ext = dplyr::case_when(
      .data$alt_exists %in% c("Missing", "Empty") | is.na(.data$alt_exists) ~ NA,
      stringr::str_detect(tolower(.data$alt), tolower(file_ext)) ~ TRUE,
      TRUE ~ FALSE
    ),
    
    # Check for self-evident phrases
    self_evident = dplyr::case_when(
      .data$alt_exists %in% c("Missing", "Empty") | is.na(.data$alt_exists) ~ NA,
      stringr::str_detect(tolower(.data$alt), tolower(redundant_pattern)) ~ TRUE,
      TRUE ~ FALSE
    ),
    
    # Check for terminal punctuation
    terminal_period = dplyr::case_when(
      .data$alt_exists %in% c("Missing", "Empty") | is.na(.data$alt_exists) ~ NA,
      stringr::str_detect(.data$alt, "\\.$") ~ TRUE,
      TRUE ~ FALSE
    ),
    
    # Highlight possible incorrect spellings
    spellcheck = dplyr::case_when(
      .data$alt_exists %in% c("Empty", "Missing") ~ NA_character_,
      is.na(.data$alt_exists) ~ NA_character_,
      .data$alt_exists == "Exists" &
        length(hunspell::hunspell(.data$alt)[[1]]) == 0 ~ "OK",
      .data$alt_exists == "Exists" &
        length(hunspell::hunspell(.data$alt)[[1]]) > 0 ~ paste(
          "Check: ", hunspell::hunspell(.data$alt)[[1]], collapse = ", "
        )
    ),
    
    # Give readability score
    readability = ifelse(
      .data$alt_exists == "Exists",
      quanteda::textstat_readability(.data$alt)$Flesch,
      NA_real_
    )
  ) %>% 
    dplyr::as_tibble()  # ensure tibble output
  
  # Return
  return(alt_df)
  
}

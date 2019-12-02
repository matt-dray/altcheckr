#' Check for Problems with the Alt Text for Images on a Web Page
#'
#' @description Infer whether an image's alt tag is missing or could be improved.
#' 
#' @param attributes_df A data.frame/tibble with image attributes, produced by
#'     \code{\link{alt_get}}.
#' @param min_char A numeric value. Alt text shorter than this is flagged.
#' @param max_char A numeric value. Alt text longer than this is flagged.
#' @param file_ext A character string. A regular expression of image file
#'     extensions.
#' @param redundant_pattern A character string. A regular expression of
#'     'redundant' phrases in alt text.
#' 
#' @return A tibble object with classes \code{tbl_df}, \code{tbl} and
#'     \code{data.frame}. In addition to columns provided by
#'     \code{\link{alt_get}}, also returns:
#'     \itemize{
#'         \item \code{alt_exists} "Exists", "Missing" or intentionally "Empty".
#'         \item \code{char_length} "Short", "Long" or "OK", depending on inputs
#'             to \code{min_char} and \code{max_char}.
#'         \item \code{file_ext} Logical. Does it look like the alt text might
#'             just be a filename (e.g. ends with ".jpg")?
#'         \item \code{self_evident} Logical. Is a redundant phrase used in the
#'             alt text (e.g. "a picture of")?
#'         \item \code{terminal_period} Logical. Does the alt text end with a 
#'             period to allow better parsing by screen readers?
#'         \item \code{spellcheck} Character. Words to check for spelling. These
#'             could be misread by a screenreader.
#'         \item \code{basic_words} Character list column. Words that match to
#'             the 850 words of Charles Kay Ogden's Basic English.
#'         \item \code{readability} Flesch's Reading Ease Score (Flesch 1948),
#'             provided via the {hunspell} package.
#'      }
#' 
#' @importFrom rlang .data
#' 
#' @export
#' 
#' @examples \dontrun{
#'     url <- "https://alphagov.github.io/accessibility-tool-audit/test-cases.html#images"
#'     attr_df <- alt_get(url)
#'     alt_check(attr_df)
#'     }

alt_check <- function(
  attributes_df, max_char = 125, min_char = 20,
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
  alt_df <- dplyr::mutate(
    
    attributes_df,
    
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
    spellcheck = ifelse(
      .data$alt_exists == "Exists",
      hunspell::hunspell(.data$alt),
      NA_character_
    ),
    
    # tokens
    tokens = ifelse(
      .data$alt_exists == "Exists",
      stringr::str_split(tolower(.data$alt), stringr::boundary("word")),
      NA_character_
    ),
    
    # Isolate basic English
    basic_words = ifelse(
      .data$alt_exists == "Exists",
      purrr::map(
        .data$tokens,
        stringr::str_extract_all,
        pattern = paste0("^", paste(tolower(cko_basic_words), collapse = "$|^"), "$")
      ),
      NA_character_
    ),
    
    # Unlist the basic terms
    basic_words = ifelse(
      .data$alt_exists == "Exists",
      purrr::map(.data$basic_words, unlist),
      NA_character_
    ),
    
    # Give readability score
    readability = ifelse(
      .data$alt_exists == "Exists",
      quanteda::textstat_readability(.data$alt)$Flesch,
      NA_real_
    )
    
  ) %>% 
    dplyr::as_tibble() %>%  # ensure tibble output
    dplyr::select(-.data$tokens)
    
    # Return
    return(.data$alt_df)
  
}

#' Convert kansuji character to arabic
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' Converts a given Kansuji element such as Ichi (1) and Nana (7) to an Arabic.
#' `kansuji2arabic_all()` converts only Kansuji in the string.
#' @param str Input vector.
#' @param convert If `FALSE`, will return as numeric. The default value is `TRUE`,
#' and numeric values are treated as strings.
#' @param .under Number scale to be converted. The default value is infinity.
#' @return a character or numeric.
#' @rdname kansuji
#' @examples
#' kansuji2arabic("\u4e00")
#' kansuji2arabic(c("\u4e00", "\u767e"))
#' kansuji2arabic(c("\u4e00", "\u767e"), convert = FALSE)
#' # Keep Kansuji over 1000.
#' kansuji2arabic(c("\u4e00", "\u767e", "\u5343"), .under = 1000)
#' # Convert all character
#' kansuji2arabic_all("\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341")
#' kansuji2arabic_all("\u516b\u4e01\u76ee")
#' @export
kansuji2arabic <- function(str, convert = TRUE, .under = Inf) {
  kanjiarabic_key <-
    c(0,
      seq.int(0, 10),
      10^c(seq.int(2, 4), 8, 12, 16)
    ) %>%
    purrr::set_names(
      stringr::str_split(
        paste0(
          "\u96f6",
          "\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341",
          "\u767e\u5343\u4e07",
          "\u5104\u5146\u4eac"),
        pattern = stringr::boundary("character"),
        simplify = TRUE)) %>%
    purrr::keep(
      ~ .x < .under) %>%
    purrr::map(
      ~ as.character(.x)
    )
  res <-
    dplyr::recode(str, !!!kanjiarabic_key)
  if (convert == FALSE)
    res <- res %>% as.numeric()
  res
}

#' @param ... Other arguments to carry over to `kansuji2arabic()`
#' @rdname kansuji
#' @export
kansuji2arabic_all <- function(str, ...) {
  stringr::str_split(str,
                     pattern = stringr::boundary("character")) %>%
    purrr::map(kansuji2arabic, ...) %>%
    purrr::reduce(c) %>%
    paste(collapse = "")
}

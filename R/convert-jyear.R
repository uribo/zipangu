#' Convert Japanese imperial year to Anno Domini
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}
#' @param jyear Japanese imperial year (jyear). Kanji or Roman character
#' @examples
#' convert_jyear("R1")
#' convert_jyear("Heisei2")
#' convert_jyear("\u5e73\u6210\u5143\u5e74")
#' convert_jyear(c("\u662d\u548c10\u5e74", "\u5e73\u621014\u5e74"))
#' convert_jyear(kansuji2arabic_all("\u5e73\u6210\u4e09\u5e74"))
#' @export
convert_jyear <- function(jyear) {
  jyear <- sapply(jyear,
                  stringr::str_trim,
                  USE.NAMES = FALSE)
  if (sum(sapply(jyear, stringr::str_detect,
                 pattern = "([0-9]{4}|[0-9]{4}.+\u5e74)",
                 USE.NAMES = FALSE)) > 0) {
    res <-
      as.numeric(stringr::str_replace(jyear, "\u5e74", ""))
  } else if (sum(is_jyear(jyear)) == 0) {
    rlang::warn("Unsupported Japanese imperial year.\nPlease include the year after 1868 or the year used since then, Meiji, Taisho, Showa, Heisei and Reiwa.")
    res <- NA_real_
  }  else {
    jyear <-
      jyear_initial_tolower(jyear)
    wareki_yr <-
      as.integer(
        stringr::str_extract(
          jyear,
          pattern = "[0-9]{1,2}"))
    wareki_roman <-
      stringr::str_sub(jyear, 1, 1) %>%
      purrr::map_chr(convert_jyear_roman)
    res <-
      wareki_yr +
      wareki_roman %>%
      purrr::map_dbl(function(.x) {
        jyear_sets %>%
          purrr::map("start_year") %>%
          purrr::map(~ .x - 1) %>%
          purrr::pluck(stringr::str_which(.x, names(jyear_sets)))
      })
  }
  res
}

jyear_initial_tolower <- function(jyear) {
  jyear %>%
    stringr::str_replace("\u5143", "1") %>%
    purrr::modify_if(
      .p = ~ stringr::str_detect(.x, "[A-Za-z]"),
      stringr::str_to_lower)
}

is_jyear <- function(jyear) {
  jyear_initial_tolower(jyear) %>%
    purrr::map_lgl(
      ~ stringr::str_detect(.x,
                            paste0("^(", paste(jyear_sets %>%
                                                 purrr::flatten() %>%
                                                 purrr::keep(is.character) %>%
                                                 purrr::as_vector(),
                                               collapse = "|"), ")")))
}

convert_jyear_roman <- function(x) {
  check_roman <-
    stringr::str_which(x,
                       jyear_sets %>%
                         purrr::map(`[`, c("roman_capital")) %>%
                         unlist())
  if (length(check_roman) > 0) {
    names(jyear_sets)[check_roman]
  } else {
    l_kanji <-
      jyear_sets %>%
      purrr::map_chr("kanji_capital")
    l_roman <-
      names(l_kanji) %>%
      purrr::set_names(l_kanji)
    dplyr::recode(x, !!!l_roman)
  }
}

jyear_sets <-
  list(
    c("\u660e\u6cbb",
      "\u5927\u6b63",
      "\u662d\u548c",
      "\u5e73\u6210",
      "\u4ee4\u548c"),
    list("meiji",
         c("taisyo", "taisho", "taisyou"),
         c("syouwa", "showa"),
         "heisei",
         "reiwa")) %>%
  rep(each = 2) %>%
  purrr::map_at(2,
                ~ stringr::str_sub(.x, 1, 1)) %>%
  purrr::map_at(4,
                ~ purrr::map(.x, stringr::str_sub, 1, 1) %>%
                  unlist() %>%
                  unique()) %>%
  purrr::set_names(c("kanji", "kanji_capital", "roman", "roman_capital")) %>%
  purrr::list_merge(start_year = c(1868, 1912, 1926, 1989, 2019)) %>%
  purrr::transpose(.names = c("meiji", "taisyo", "syouwa", "heisei", "reiwa")) %>%
  purrr::simplify()

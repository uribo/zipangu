#' Convert Japanese imperial year to Anno Domini
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}
#' @param jyear Japanese imperial year (jyear). Kanji or Roman character
#' @section Examples:
#' ```{r, child = "man/rmd/setup.Rmd"}
#' ```
#'
#' ```{r}
#' convert_jyear("R1")
#' convert_jyear("Heisei2")
#' convert_jyear("\u5e73\u6210\u5143\u5e74")
#' convert_jyear(c("\u662d\u548c10\u5e74", "\u5e73\u621014\u5e74"))
#' convert_jyear(kansuji2arabic_all("\u5e73\u6210\u4e09\u5e74"))
#' ```
#' @export
convert_jyear <- function(jyear) {
  jyear <-
    stringr::str_trim(jyear)

  res <- rep(NA_real_, length(jyear))

  # Convert to position to ignore NAs
  idx_ad <-
    which(stringr::str_detect(jyear, "([0-9]{4}|[0-9]{4}.+\u5e74)"))
  idx_wareki <-
    which(is_jyear(jyear))

  # If there are some index not covered by AD or Wareki, show a warning
  if (length(setdiff(seq_along(jyear), c(idx_ad, idx_wareki, which(is.na(jyear))))) > 0) {
    rlang::warn("Unsupported Japanese imperial year.\nPlease include the year after 1868 or the year used since then, Meiji, Taisho, Showa, Heisei and Reiwa.")
  }

  # For AD years, simply parse the numbers
  res[idx_ad] <-
      as.numeric(stringr::str_replace(jyear[idx_ad], "\u5e74", ""))

  # For Wareki years, do some complex stuff...
  jyear_wareki <-
    jyear_initial_tolower(jyear[idx_wareki])
  wareki_yr <-
    as.integer(
      stringr::str_extract(
        jyear_wareki,
        pattern = "[0-9]{1,2}"))
  wareki_roman <-
    stringr::str_sub(jyear_wareki, 1, 1) %>%
    purrr::map_chr(convert_jyear_roman)
  res[idx_wareki] <-
    wareki_yr +
    wareki_roman %>%
    purrr::map_dbl(function(.x) {
      jyear_sets %>%
        purrr::map("start_year") %>%
        purrr::map(~ .x - 1) %>%
        purrr::pluck(stringr::str_which(.x, names(jyear_sets)))
    })

  res
}

#' Convert Japanese date format to date object
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}
#' @param date a character object.
#' @section Examples:
#' ```{r, child = "man/rmd/setup.Rmd"}
#' ```
#'
#' ```{r}
#' convert_jdate("\u4ee4\u548c2\u5e747\u67086\u65e5")
#' ```
#' @export
convert_jdate <- function(date) {
  date %>%
    stringi::stri_trans_nfkc() %>%
    stringr::str_replace(".*(?=\u5e74)",
                         convert_jyear) %>%
    lubridate::ymd()
}

jyear_initial_tolower <- function(jyear) {
  jyear <-
    stringr::str_replace(jyear, "\u5143", "1")

  idx <-
    which(stringr::str_detect(jyear, "[A-Za-z]"))
  jyear[idx] <-
    stringr::str_to_lower(jyear[idx])

  jyear
}

is_jyear <- function(jyear) {
  pattern <- paste0(
    "^(",
    paste(jyear_sets %>%
            purrr::map(~ .x[c("kanji", "roman")]) %>%
            purrr::flatten() %>%
            purrr::as_vector(),
          collapse = "|"),
    ")")
  res <-
    stringr::str_detect(jyear_initial_tolower(jyear),
                        pattern)
  res %>%
    purrr::map2_lgl(
      .y = jyear,
      function(.x, .y) {
        if (is.na(.x)) {
          .x
        } else if (.x == FALSE) {
          pattern <- paste0(
            "^(",
            paste(jyear_sets %>%
                    purrr::map(~ .x[c("kanji_capital", "roman_capital")]) %>%
                    purrr::flatten(),
                  collapse = "|"),
            ")([0-9]|[\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341])")
          stringr::str_detect(jyear_initial_tolower(.y),
                              pattern)
        } else {
          TRUE
        }
      }
    )
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

#' Public holidays in Japan
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' @details Holiday information refers to data published as of December 21, 2020.
#' Future holidays are subject to change.
#' @param year numeric years after 1949.
#' If `NA` supplied, `jholiday_spec` returns `NA` respectively.
#' On the other hand, `jholiday` always omits any `NA` values.
#' @param name holiday names.
#' If this argument is not the same length of year, the first element will be recycled.
#' @param lang switch for turning values to "en" or "jp".
#' @references Public Holiday Law [https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html](https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html),
#' [https://elaws.e-gov.go.jp/document?lawid=323AC1000000178](https://elaws.e-gov.go.jp/document?lawid=323AC1000000178)
#' @rdname jholiday
#' @section Examples:
#' ```{r, child = "man/rmd/setup.Rmd"}
#' ```
#'
#' ```{r}
#' jholiday_spec(2019, "Sports Day")
#' jholiday_spec(2021, "Sports Day")
#' ```
#' List of a specific year holidays
#' ```{r}
#' jholiday(2021, "en")
#' ```
#' @importFrom rlang :=
#' @export
jholiday_spec <- function(year, name, lang = "en") {
  if (are_all_current_law_yr(year)) {
    if (length(year) < length(name))
      rlang::abort("`year` must be a vector of length 1 or longer length than `name`.")
    if (!identical(length(name), 1L) & (length(year) > length(name))) {
      rlang::warn(
        paste("`name` is expected to be a vector of length 1 or the same length of `year`.",
              "the first element of `name` is recycled."
        ))
      name <- name[1]
    }
    jholiday_names <- jholiday_list[[lang]]
    if (!purrr::every(name, ~ match(., jholiday_names, nomatch = 0) > 0)) {
      rlang::abort(
        sprintf("No such holiday: %s",
                purrr::discard(name, ~ match(., jholiday_names, nomatch = 0) > 0))
      )
    }
    res <-
      purrr::map2(year, name, function(yr, nm) {
        fn_name <- paste("jholiday_spec", yr, lang, sep = "_")
        if (!rlang::env_has(.pkgenv, fn_name)) {
          rlang::env_bind(
            .pkgenv,
            !!fn_name := memoise::memoise(jholiday_spec_impl()(yr, lang))
          )
        }
        rlang::env_get(.pkgenv, fn_name, inherit = TRUE)(nm)
      }) %>%
        unlist() %>%
        lubridate::as_date()
    res
  }
}

#' @noRd
jholiday_spec_impl <- function() {
  fn <- function(year, name, lang) {
    if (!is.numeric(year) || is.na(year)) {
      # early return
      return(lubridate::as_date(NA_character_))
    }
    jholiday_names <- jholiday_list[[lang]]
    dplyr::case_when(
      # New Year's Day
      name == jholiday_names[1] ~
        lubridate::make_date(year, 1, 1),
      # Coming of Age Day
      name == jholiday_names[2] ~
        dplyr::if_else(
          year >= 2000,
          find_date_by_wday(year, 1, 2, 2),
          lubridate::ymd(paste0(year, "0115"))
        ),
      # Foundation Day
      name == jholiday_names[3] ~
        dplyr::if_else(
          year >= 1967,
          lubridate::ymd(paste0(year, "0211")),
          lubridate::as_date(NA_character_)
        ),
      # Vernal Equinox Day
      name == jholiday_names[4] ~
        lubridate::make_date(year, 3, day = shunbun_day(year)),
      # Showa Day (2007-), Greenery Day (1989-2006), and The Emperor's Birthday (-1989)
      (name == jholiday_names[5] & year >= 2007) |
        (name == jholiday_names[6] & dplyr::between(year, 1989, 2006)) |
        (name == jholiday_names[7] & year < 1989) ~
        lubridate::make_date(year, 4, 29),
      # Constitution Memorial Day
      name == jholiday_names[8] ~
        lubridate::make_date(year, 5, 3),
      # Greenery Day (2007-), and Citizens' Holiday (1988-2006)
      (name == jholiday_names[9] & year >= 2007) |
        (name == jholiday_names[10] & dplyr::between(year, 1988, 2006)) ~
        lubridate::make_date(year, 5, 4),
      # Children's Day
      name == jholiday_names[11] & year >= 1949 ~
        lubridate::make_date(year, 5, 5),
      # Marine Day
      name == jholiday_names[12] & year == 2020 ~
        lubridate::as_date("20200723"),
      name == jholiday_names[12] & year == 2021 ~
        lubridate::as_date("20210722"),
      name == jholiday_names[12] & year >= 2003 & year != 2020 & year != 2021 ~
        find_date_by_wday(year, 7, 2, 3),
      name == jholiday_names[12] & dplyr::between(year, 1996, 2002) ~
        lubridate::make_date(year, 7, 20),
      # Mountain Day
      name == jholiday_names[13] & year == 2020 ~
        lubridate::as_date("20200810"),
      name == jholiday_names[13] & year == 2021 ~
        lubridate::as_date("20210808"),
      name == jholiday_names[13] & year >= 2016 & year != 2020 & year != 2021 ~
        lubridate::make_date(year, 8, 11),
      # Respect for the Aged Day
      name == jholiday_names[14] & dplyr::between(year, 1966, 2002) ~
        lubridate::make_date(year, 9, 15),
      name == jholiday_names[14] & year >= 2003 ~
        find_date_by_wday(year, 9, 2, 3),
      # Autumnal Equinox Day
      name == jholiday_names[15] ~
        lubridate::make_date(year, 9, day = shubun_day(year)),
      # Sports Day
      name == jholiday_names[17] & year == 2020 ~
        lubridate::as_date("20200724"),
      name == jholiday_names[17] & year == 2021 ~
        lubridate::as_date("20210723"),
      name %in% jholiday_names[16] & dplyr::between(year, 2000, 2019) ~
          find_date_by_wday(year, 10, 2, 2),
      name %in% jholiday_names[17] & year >= 2022 ~
          find_date_by_wday(year, 10, 2, 2),
      name %in% jholiday_names[16] & dplyr::between(year, 1966, 1999) ~
        lubridate::make_date(year, 10, 10),
      # Culture Day
      name == jholiday_names[18] ~
        lubridate::make_date(year, 11, 3),
      # Labour Thanksgiving Day
      name == jholiday_names[19] ~
        lubridate::make_date(year, 11, 23),
      # The Emperor's Birthday
      name == jholiday_names[20] & dplyr::between(year, 1989, 2018) ~
        lubridate::make_date(year, 12, 23),
      name == jholiday_names[20] & year >= 2020 ~
        lubridate::make_date(year, 2, 23),
      # default
      TRUE ~ lubridate::as_date(NA_character_)
    )
  }
  function(year, lang) {
    purrr::partial(fn, year = year, lang = lang)
  }
}

#' @rdname jholiday
#' @export
jholiday <- function(year, lang = "en") {
  jholiday_names <- jholiday_list[[lang]]
  if (are_all_current_law_yr(year)) {
    res <-
      jholiday_names %>%
      purrr::map(~ jholiday_spec(year, name = .x, lang = lang)) %>%
      purrr::set_names(jholiday_names)
    res <-
      res[!duplicated(res)]
    res <-
      res %>%
      purrr::discard(~ all(is.na(.))) %>%
      purrr::imap(function(x, y) {
        sort(x)
      })
    res <-
      res[res %>%
          purrr::map(1) %>%
          purrr::flatten_dbl() %>%
          purrr::set_names(names(res)) %>%
          sort() %>%
          names()]
    res
  }
}

are_all_current_law_yr <- function(years) {
  # This check omits any NAs, NULL, and empty strings for convenience.
  checked <- all(as.numeric(years) >= 1948, na.rm = TRUE)
  if (!checked)
    rlang::warn("The year specified must be after the law was enacted in 1948")
  checked
}

shunbun_day <- function(year) {
  dplyr::case_when(
    year <= 1947 ~ NA_real_,
    year <= 1979 ~ trunc(20.8357 + 0.242194 * (year - 1980) - trunc((year -
                                                                       1983) /
                                                                      4)),
    year <= 2099 ~ trunc(20.8431 + 0.242194 * (year - 1980) - trunc((year -
                                                                       1980) /
                                                                      4)),
    year <= 2150 ~ trunc(21.851 + 0.242194 * (year - 1980) - trunc((year -
                                                                      1980) /
                                                                     4))
  )
}

shubun_day <- function(year) {
  dplyr::case_when(
    year <= 1947 ~ NA_real_,
    year <= 1979 ~ trunc(23.2588 + 0.242194 * (year - 1980) - trunc((year -
                                                                       1983) /
                                                                      4)),
    year <= 2099 ~ trunc(23.2488 + 0.242194 * (year - 1980) - trunc((year -
                                                                       1980) /
                                                                      4)),
    year <= 2150 ~ trunc(24.2488 + 0.242194 * (year - 1980) - trunc((year -
                                                                       1980) /
                                                                      4))
  )
}

#' Is x a public holidays in Japan?
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' Whether it is a holiday defined by Japanese law (enacted in 1948)
#' @details Holiday information refers to data published as of December 21, 2020.
#' Future holidays are subject to change.
#' @param date a vector of [POSIXt], numeric or character objects
#' @return TRUE if x is a public holidays in Japan, FALSE otherwise.
#' @rdname is_jholiday
#' @section Examples:
#' ```{r, child = "man/rmd/setup.Rmd"}
#' ```
#'
#' ```{r}
#' is_jholiday("2021-01-01")
#' is_jholiday("2018-12-23")
#' is_jholiday("2019-12-23")
#' ```
#' @export
is_jholiday <- function(date) {
  date <-
    lubridate::as_date(date)
  yr <-
    unique(lubridate::year(date[!is.na(date)]))
  jholidays <-
    unique(c(
      jholiday_df$date,            # Holidays from https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv
      lubridate::as_date(unlist(jholiday(yr, "en")))   # Calculated holidays
    ))

  # exclude NA from jholidays then check if the date is Japanese Holiday or not.
  date %in% jholidays[!is.na(jholidays)]
}

#' Find out the date of the specific month and weekday
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' Get the date of the Xth the specific weekday
#' @param year numeric year
#' @param month numeric month
#' @param wday numeric weekday
#' @param ordinal number of week
#' @return a vector of class POSIXct
#' @rdname find_date_by_wday
#' @examples
#' find_date_by_wday(2021, 1, 2, 2)
#' @export
find_date_by_wday <- function(year, month, wday, ordinal) {
  date_begin <-
    lubridate::make_date(year, month)
  # If the lubridate.week.start option is set, lubridate::wday results is affected by it.
  # To get the correct Japanese Holiday information, explicitly pass Sunday (7) as week_start.
  wday_of_date_begin <-
    lubridate::wday(date_begin, week_start = 7)
  # First dates of the specified wday on each year-month
  first_wday <-
    date_begin + (wday - wday_of_date_begin) %% 7
  # Add 1 ordinal = 1 week = 7 days
  result <- first_wday + 7 * (ordinal - 1)
  # If the calculated result is beyond the end of the month, fill it with NA
  dplyr::if_else(
    lubridate::month(result) == lubridate::month(date_begin),
    result,
    lubridate::as_date(NA_character_)
  )
}

jholiday_list <-
  list(
    jp = c("\u5143\u65e5",
           "\u6210\u4eba\u306e\u65e5",
           "\u5efa\u56fd\u8a18\u5ff5\u306e\u65e5",
           "\u6625\u5206\u306e\u65e5",
           list("\u662d\u548c\u306e\u65e5", "\u307f\u3069\u308a\u306e\u65e5", "\u5929\u7687\u8a95\u751f\u65e5"),
           "\u61b2\u6cd5\u8a18\u5ff5\u65e5",
           list("\u307f\u3069\u308a\u306e\u65e5", "\u56fd\u6c11\u306e\u4f11\u65e5"),
           "\u3053\u3069\u3082\u306e\u65e5",
           "\u6d77\u306e\u65e5",
           "\u5c71\u306e\u65e5",
           "\u656c\u8001\u306e\u65e5",
           "\u79cb\u5206\u306e\u65e5",
           list("\u4f53\u80b2\u306e\u65e5", "\u30b9\u30dd\u30fc\u30c4\u306e\u65e5"),
           "\u6587\u5316\u306e\u65e5",
           "\u52e4\u52b4\u611f\u8b1d\u306e\u65e5",
           list("\u5929\u7687\u8a95\u751f\u65e5")),
    en = c("New Year's Day",
           "Coming of Age Day",
           "Foundation Day",
           "Vernal Equinox Day",
           list("Showa Day", "Greenery Day", "The Emperor's Birthday"),
           "Constitution Memorial Day",
           list("Greenery Day", "Citizens' Holiday"),
           "Children's Day",
           "Marine Day",
           "Mountain Day",
           "Respect for the Aged Day",
           "Autumnal Equinox Day",
           list("Sports Day", "Sports Day"),
           "Culture Day",
           "Labour Thanksgiving Day",
           list("The Emperor's Birthday")))

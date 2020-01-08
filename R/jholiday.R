#' Public holidays in Japan
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' @details Holiday information refers to data published as of January 1, 2020.
#' Future holidays are subject to change.
#' @param year numeric year and in and after 1949.
#' @param name holiday name
#' @param lang return holiday names to "en" or "jp".
#' @references Public Holiday Law [https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html](https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html),
#' [https://elaws.e-gov.go.jp/search/elawsSearch/elaws_search/lsg0500/detail?lawId=323AC1000000178](https://elaws.e-gov.go.jp/search/elawsSearch/elaws_search/lsg0500/detail?lawId=323AC1000000178)
#' @rdname jholiday
#' @examples
#' jholiday_spec(2019, "Sports Day")
#' jholiday_spec(2020, "Sports Day")
#' # List of a specific year holidays
#' jholiday(2020, "en")
#' @export
jholiday_spec <- function(year, name, lang = "en") {
  if (is_current_law_yr(year)) {
    name <-
      jholiday_list %>%
      purrr::pluck(lang) %>%
      purrr::keep(~ .x == name)
    res <-
      dplyr::case_when(
        name %in% c(jholiday_list %>%
                      purrr::map_chr(1)) ~ lubridate::make_date(year, 1, 1),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(2)) ~ dplyr::if_else(
                        year >= 2000,
                        find_date_by_wday(year, 1, 2, 2),
                        lubridate::ymd(paste0(year, "0115"))),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(3)) ~ dplyr::if_else(
                        year >= 1967,
                        lubridate::ymd(paste0(year, "0211")),
                        lubridate::as_date(NA_character_)),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(4)) ~ lubridate::make_date(year, 3, day = shunbun_day(year)),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 5) %>%
                      purrr::flatten_chr()) & year >= 2007 ~ lubridate::make_date(year, 4, 29),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 6) %>%
                      purrr::flatten_chr()) & dplyr::between(year, 1989, 2006) ~ lubridate::make_date(year, 4, 29),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 7) %>%
                      purrr::flatten_chr()) & year < 1989 ~ lubridate::make_date(year, 4, 29),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(8)) ~ lubridate::make_date(year, 5, 3),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 9) %>%
                      purrr::flatten_chr()) & year >= 2007 ~ lubridate::make_date(year, 5, 4),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 10) %>%
                      purrr::flatten_chr()) & dplyr::between(year, 1988, 2006) ~ lubridate::make_date(year, 5, 4),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(11)) & year >= 1949 ~ lubridate::make_date(year, 5, 5),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(12)) & year == 2020 ~ lubridate::as_date("20200723"),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(12)) & year >= 2003 & year != 2020 ~ find_date_by_wday(year, 7, 2, 3),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(12)) & dplyr::between(year, 1996, 2002) ~ lubridate::make_date(year, 7, 20),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(13)) & year == 2020 ~ lubridate::as_date("20200810"),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(13)) & year >= 2016 & year != 2020 ~ lubridate::make_date(year, 8, 11),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(14)) & dplyr::between(year, 1966, 2002) ~ lubridate::make_date(year, 9, 15),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(14)) & year >= 2003 ~ find_date_by_wday(year, 9, 2, 3),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(15)) ~ lubridate::make_date(year, 9, day = shubun_day(year)),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(17)) & year == 2020 ~ lubridate::as_date("20200724"),
        name %in% c(jholiday_list %>%
                      purrr::map(`[`, c(16, 17)) %>%
                      unlist() %>%
                      unique()) & year >= 2000 & year != 2020 ~ find_date_by_wday(year, 10, 2, 2),
        name %in% c(jholiday_list %>%
                      purrr::map(`[`, c(16, 17)) %>%
                      unlist() %>%
                      unique()) &  dplyr::between(year, 1966, 1999) ~ lubridate::make_date(year, 10, 10),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(18)) ~ lubridate::make_date(year, 11, 3),
        name %in% c(jholiday_list %>%
                      purrr::map_chr(19)) ~ lubridate::make_date(year, 11, 23),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 20) %>%
                      purrr::flatten_chr()) & dplyr::between(year, 1989, 2018) ~ lubridate::make_date(year, 12, 23),
        name %in% c(jholiday_list %>%
                      purrr::map(`[[`, 20) %>%
                      purrr::flatten_chr()) & year >= 2020 ~ lubridate::make_date(year, 2, 23)
      )
    unique(res)
  }
}

#' @rdname jholiday
#' @export
jholiday <- function(year, lang = "en") {
  if (is_current_law_yr(year)) {
    res <-
      jholiday_list %>%
      purrr::pluck(lang) %>%
      purrr::map(~ as.numeric(jholiday_spec(year, name = .x, lang = lang))) %>%
      purrr::set_names(jholiday_list %>%
                         purrr::pluck(lang)) %>%
      purrr::discard(is.na)
    res <-
      res[!duplicated(res)]
    res %>%
      unlist() %>%
      sort() %>%
      as.list() %>%
      purrr::map(lubridate::as_date)
  }
}

is_current_law_yr <- function(year) {
  checked <- year >= 1948
  if (checked == FALSE)
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
#' @details Holiday information refers to data published as of January 1, 2020.
#' Future holidays are subject to change.
#' @param date a vector of [POSIXt], numeric or character objects
#' @return TRUE if x is a public holidays in Japan, FALSE otherwise.
#' @rdname is_jholiday
#' @examples
#' is_jholiday("2020-01-01")
#' is_jholiday("2018-12-23") # TRUE
#' is_jholiday("2019-12-23") # FALSE
#' is_jholiday("2020-02-23") # TRUE
#' is_jholiday("2020-05-06") # TRUE
#' @export
is_jholiday <- function(date) {
  date <-
    lubridate::as_date(date)
  yr <-
    lubridate::year(date)
  dplyr::if_else(
    is.na(match(date,
                unique(c(jholiday_df$date,
                         jholiday(yr, "en") %>% purrr::reduce(c))))),
    FALSE,
    TRUE
  )
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
#' find_date_by_wday(2020, 1, 2, 2)
#' @export
find_date_by_wday <- function(year, month, wday, ordinal) {
  date_begin <-
    lubridate::make_date(year, month)
  dom <-
    date_begin + seq.int(0, lubridate::days_in_month(date_begin) - 1)
  dom <-
    lubridate::wday(dom) %>%
    purrr::set_names(dom)
  purrr::keep(dom,
              ~ .x == as.character(wday))[ordinal] %>%
    names() %>%
    lubridate::as_date()
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

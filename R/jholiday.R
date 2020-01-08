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

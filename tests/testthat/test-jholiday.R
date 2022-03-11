test_that("Specific year's holiday", {
  expect_equal(
    jholiday_spec(2020, "New Year's Day", lang = "en"),
    as.Date("2020-01-01")
  )
  expect_equal(
    jholiday_spec(2000, "\u5143\u65e5", lang = "jp"),
    jholiday_spec(2000, "New Year's Day", lang = "en")
  )
  expect_equal(
    jholiday_spec(2019, "\u6210\u4eba\u306e\u65e5", lang = "jp"),
    as.Date("2019-01-14")
  )
  expect_equal(
    jholiday_spec(2020, "Coming of Age Day"),
    as.Date("2020-01-13")
  )
  expect_equal(
    jholiday_spec(1966, "Vernal Equinox Day"),
    lubridate::make_date(1966, 3, shunbun_day(1986))
  )
  expect_equal(
    seq.int(2003, 2019) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Marine Day"))
      ),
    c(21, 19, 18, 17, 16,
      21, 20, 19, 18, 16, 15,
      21, 20, 18, 17, 16, 15))
  expect_equal(
    length(jholiday(2019, "en")),
    15L
  )
  expect_equal(
    length(jholiday(2021, "en")),
    16L
  )
  expect_equal(
    length(jholiday(2022, "en")),
    16L
  )
  res <- jholiday(2020:2021, "en")
  expect_equal(
    length(res),
    16L
  )
  expect_equal(
    unique(purrr::map_int(res, length)),
    2L
  )
  expect_equal(
    names(jholiday(2021, lang = "en")),
    c("New Year's Day", "Coming of Age Day", "Foundation Day", "The Emperor's Birthday",
      "Vernal Equinox Day", "Showa Day", "Constitution Memorial Day",
      "Greenery Day", "Children's Day", "Marine Day", "Sports Day",
      "Mountain Day", "Respect for the Aged Day", "Autumnal Equinox Day",
      "Culture Day", "Labour Thanksgiving Day")
  )
  expect_error(
    jholiday_spec(2019:2020, c("Coming of Age Day",
                               "Foundation Day",
                               "Vernal Equinox Day")),
    "longer length than `name`."
  )
  expect_warning(
    res <-
      jholiday_spec(2019:2021, c("Coming of Age Day",
                                 "Foundation Day")),
    "the first element of `name` is recycled."
  )
  expect_equal(res, as.Date(c("2019-01-14", "2020-01-13", "2021-01-11")))
})

test_that("Another approaches", {
  skip_on_cran()
  expect_equal(
    jholiday_spec(2000, "Coming of Age Day"),
    as.Date("2000-01-10")
  )
  expect_equal(
    jholiday_spec(2021, "Foundation Day"),
    as.Date("2021-02-11")
  )
  expect_equal(
    jholiday_spec(1966, "Foundation Day"),
    as.Date(NA_character_)
  )
  expect_equal(
    jholiday_spec(1969, "Vernal Equinox Day"),
    as.Date("1969-03-21")
  )
  expect_equal(
    jholiday_spec(2021, "Vernal Equinox Day"),
    as.Date("2021-03-20")
  )
  expect_equal(
    jholiday_spec(2021, "\u662d\u548c\u306e\u65e5", lang = "jp"),
    jholiday_spec(2021, "Showa Day")
  )
  expect_equal(
    jholiday_spec(2007, "Showa Day"),
    as.Date("2007-04-29")
  )
  expect_equal(
    jholiday_spec(2006, "Showa Day"),
    as.Date(NA_character_)
  )
  expect_equal(
    jholiday_spec(2006, "Greenery Day"),
    as.Date("2006-04-29")
  )
  expect_equal(
    jholiday_spec(1988, "The Emperor's Birthday"),
    as.Date("1988-04-29")
  )
  expect_equal(
    jholiday_spec(2021, "Greenery Day"),
    as.Date("2021-05-04")
  )
  expect_equal(
    jholiday_spec(1989, "Greenery Day"),
    as.Date("1989-04-29")
  )
  expect_equal(
    jholiday_spec(2006, "Greenery Day"),
    as.Date("2006-04-29")
  )
  expect_equal(
    jholiday_spec(2007, "Greenery Day"),
    as.Date("2007-05-04")
  )
  expect_equal(
    jholiday_spec(2020, "Marine Day"),
    as.Date("2020-07-23")
  )
  expect_equal(
    jholiday_spec(2021, "Marine Day"),
    as.Date("2021-07-22")
  )
  expect_equal(
    seq.int(1996, 2002) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Marine Day"))
      ) %>%
      unique(),
    20
  )
  expect_equal(
    jholiday_spec(1995, "Marine Day"),
    as.Date(NA_character_)
  )
  expect_equal(
    jholiday_spec(2020, "Mountain Day"),
    as.Date("2020-08-10")
  )
  expect_equal(
    jholiday_spec(2021, "Mountain Day"),
    as.Date("2021-08-08")
  )
  expect_equal(
    seq.int(2016, 2019) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Mountain Day"))
      ) %>%
      unique(),
    11
  )
  expect_equal(
    jholiday_spec(2015, "Mountain Day"),
    as.Date(NA_character_)
  )
  expect_equal(
    seq.int(1966, 2002) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Respect for the Aged Day"))
      ) %>%
      unique(),
    15
  )
  expect_equal(
    seq.int(2003, 2021) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Respect for the Aged Day"))
      ),
    c(15, 20, 19, 18, 17,
      15, 21, 20, 19, 17,
      16, 15, 21, 19, 18,
      17, 16, 21, 20))
  expect_equal(
    seq.int(1955, 1982) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Autumnal Equinox Day"))
      ),
    c(rep(c(24, rep(23, each = 3)), times = 7)))
  expect_equal(
    seq.int(1983, 2011) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Autumnal Equinox Day"))
      ),
    rep(23, times = 29))
  expect_equal(
    seq.int(2012, 2021) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "\u79cb\u5206\u306e\u65e5", lang = "jp"))
      ),
    c(22, 23, 23, 23,
      22, 23, 23, 23,
      22, 23))
  expect_equal(
    jholiday_spec(2020, "Sports Day"),
    as.Date("2020-07-24")
  )
  expect_equal(
    jholiday_spec(2021, "Sports Day"),
    as.Date("2021-07-23")
  )
  expect_equal(
    seq.int(2000, 2019) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Sports Day"))
      ),
    c(9, 8, 14, 13, 11, 10,
      9, 8, 13, 12, 11, 10,
      8, 14, 13, 12, 10, 9,
      8, 14))
  expect_equal(
    seq.int(1966, 1999) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Sports Day"))
      ) %>%
      unique(),
    10
  )
  expect_equal(
    seq.int(1955, 2021) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Culture Day"))
      ) %>%
      unique(),
    3
  )
  expect_equal(
    seq.int(1955, 2021) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Labour Thanksgiving Day"))
      ) %>%
      unique(),
    23
  )
  expect_equal(
    seq.int(1989, 2018) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Labour Thanksgiving Day"))
      ) %>%
      unique(),
    23
  )
  expect_equal(
    jholiday_spec(2019, "The Emperor's Birthday"),
    as.Date(NA_character_)
  )
  expect_equal(
    jholiday_spec(2021, "The Emperor's Birthday"),
    as.Date("2021-02-23")
  )
})

test_that("Is jholiday works", {
  expect_true(
    is_jholiday("2021-01-01")
  )
  expect_false(
    is_jholiday("2021-01-02")
  )
  expect_true(
    is_jholiday("19930609")
  )
  expect_true(
    is_jholiday(lubridate::ymd("1989-02-11"))
  )
  # multiple dates
  expect_equal(
    is_jholiday(as.Date("2021-01-01") + 0:2),
    c(TRUE, FALSE, FALSE)
  )
  # multiple dates in multiple years
  expect_equal(
    is_jholiday(as.Date(c("2019-01-01", "2021-01-01"))),
    c(TRUE, TRUE)
  )
  # for multiple dates with NA
  expect_equal(
    is_jholiday(c("2019-01-01", NA, "2021-01-01")),
    c(TRUE, FALSE, TRUE)
  )

  current_option <- getOption("lubridate.week.start")
  # Set the week start day to Monday (1) to see if it can still recognize correct Japanese Holidays
  options(lubridate.week.start = 1)
  expect_equal(is_jholiday("2019-10-08"), FALSE)
  expect_equal(getOption("lubridate.week.start"),1)
  # reset
  options(lubridate.week.start = current_option)

})

test_that("Utils", {
  expect_true(
    are_all_current_law_yr(1948)
  )
  expect_warning(
    expect_false(
      are_all_current_law_yr(1947),
      "The year specified must be after the law was enacted in 1948"
    )
  )
  expect_true(
    are_all_current_law_yr(1948:1950)
  )
  expect_true(
    all(are_all_current_law_yr(NA_real_),
        are_all_current_law_yr(c("", NA_character_)),
        are_all_current_law_yr(NULL))
  )
  expect_warning(
    expect_false(
      are_all_current_law_yr(1947:1949),
      "The year specified must be after the law was enacted in 1948"
    )
  )
  expect_equal(
    find_date_by_wday(2021, 1, 2, 2),
    as.Date("2021-01-11")
  )
  expect_equal(
    find_date_by_wday(2019, 12, 3, 5),
    as.Date("2019-12-31")
  )
  expect_equal(
    find_date_by_wday(2019, 12, 8, 6),
    as.Date(NA_character_)
  )
  expect_equal(
    find_date_by_wday(2019:2021, 1, 2, 2),
    as.Date(c("2019-01-14", "2020-01-13", "2021-01-11"))
  )
  expect_equal(
    shunbun_day(1966),
    21
  )
  expect_equal(
    shunbun_day(1988),
    lubridate::mday(jholiday_spec(1988, "Vernal Equinox Day"))
  )
  expect_equal(
    shunbun_day(1945),
    NA_real_
  )
  expect_equal(
    shubun_day(1966),
    23
  )
  expect_equal(
    shubun_day(1988),
    lubridate::mday(jholiday_spec(1988, "Autumnal Equinox Day"))
  )
  expect_equal(
    shubun_day(1945),
    NA_real_
  )
})

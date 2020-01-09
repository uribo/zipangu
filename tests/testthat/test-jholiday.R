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
    length(jholiday(2020, "en")),
    16L
  )
})

test_that("Another approaches", {
  skip_on_cran()
  expect_equal(
    jholiday_spec(2000, "Coming of Age Day"),
    as.Date("2000-01-10")
  )
})

test_that("Is jholiday works", {
  expect_true(
    is_jholiday("2020-01-01")
  )
  expect_false(
    is_jholiday("2020-01-02")
  )
  expect_true(
    is_jholiday("19930609")
  )
  expect_true(
    is_jholiday(lubridate::ymd("1989-02-11"))
  )
  expect_equal(
    jholiday_spec(2020, "Foundation Day"),
    as.Date("2020-02-11")
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
    jholiday_spec(2020, "Vernal Equinox Day"),
    as.Date("2020-03-20")
  )
  expect_equal(
    jholiday_spec(2020, "\u662d\u548c\u306e\u65e5", lang = "jp"),
    jholiday_spec(2020, "Showa Day")
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
    jholiday_spec(2020, "Greenery Day"),
    as.Date("2020-05-04")
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
    seq.int(2003, 2020) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Respect for the Aged Day"))
      ),
    c(15, 20, 19, 18, 17,
      15, 21, 20, 19, 17,
      16, 15, 21, 19, 18,
      17, 16, 21))
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
    seq.int(2012, 2020) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "\u79cb\u5206\u306e\u65e5", lang = "jp"))
      ),
    c(22, 23, 23, 23,
      22, 23, 23, 23,
      22))
  expect_equal(
    jholiday_spec(2020, "Sports Day"),
    as.Date("2020-07-24")
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
    seq.int(1955, 2020) %>%
      purrr::map_dbl(
        ~ lubridate::mday(jholiday_spec(.x, "Culture Day"))
      ) %>%
      unique(),
    3
  )
  expect_equal(
    seq.int(1955, 2020) %>%
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
    jholiday_spec(2020, "The Emperor's Birthday"),
    as.Date("2020-02-23")
  )
})

test_that("Utils", {
  expect_true(
    is_current_law_yr(1948)
  )
  expect_warning(
    expect_false(
    is_current_law_yr(1947),
    "The year specified must be after the law was enacted in 1948"
  ))
  expect_equal(
    find_date_by_wday(2020, 1, 2, 2),
    as.Date("2020-01-13")
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

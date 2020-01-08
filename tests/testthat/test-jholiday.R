test_that("Utils", {
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

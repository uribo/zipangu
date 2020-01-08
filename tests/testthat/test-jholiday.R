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
})

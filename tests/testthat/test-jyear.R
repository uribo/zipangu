test_that("convert jyear works", {
  expect_equal(
    convert_jyear("R1"),
    2019
  )
  expect_equal(
    convert_jyear("Heisei1"),
    convert_jyear("H1")
  )
  expect_equal(
    convert_jyear("\u5e73\u6210\u5143\u5e74"),
    convert_jyear("H1")
  )
  expect_equal(
    convert_jyear("1989\u5e74"),
    1989
  )
  expect_warning(
    expect_equal(
      convert_jyear("\u6587\u4e453\u5e74", legacy = TRUE),
      NA_real_
    )
  )
  expect_silent(
    expect_equal(
      convert_jyear(c("\u662d\u548c10\u5e74", "\u5e73\u621014\u5e74", NA)),
      c(1935, 2002, NA)
    )
  )
})

test_that("convert japanese date format", {
  expect_equal(
    convert_jdate("\u4ee4\u548c2\u5e747\u67086\u65e5"),
    as.Date("2020-07-06")
  )
  expect_equal(
    convert_jdate("H20.4.1"),
    convert_jdate("\u5e73\u621020\u5e744\u67081\u65e5")
  )
  expect_equal(
    convert_jdate("R2/12/1"),
    convert_jdate("R2-12-01")
  )
  expect_equal(
    convert_jdate(c("\u5e73\u621030\u5e741\u67081\u65e5", "\u5e73\u621030\u5e742\u67081\u65e5", NA)),
    as.Date(c("2018-01-01", "2018-02-01", NA))
  )
  expect_equal(
    convert_jdate("\u4ee4\u548c4\u5e742\u670824\u65e5",
                  legacy = TRUE),
    as.Date("2022-02-24")
  )
  expect_equal(
    convert_jdate("2023\u5e742\u670824\u65e5",
                  legacy = TRUE),
    as.Date("2023-02-24")
  )
})

test_that("is_jyear() works", {
  expect_equal(
    is_jyear(c("Heisei1", "1989\u5e74", NA, "\u6587\u4e453\u5e74")),
    c(TRUE, FALSE, NA, FALSE)
  )
})

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
      convert_jyear("\u6587\u4e453\u5e74"),
      NA_real_
    )
  )
  expect_equal(
    convert_jyear(c("\u662d\u548c10\u5e74", "\u5e73\u621014\u5e74")),
    c(1935, 2002)
  )
})

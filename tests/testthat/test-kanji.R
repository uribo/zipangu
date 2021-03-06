test_that("convert kansuji to arabic works", {
  expect_equal(
    kansuji2arabic("\u4e00"),
    "1"
  )
  expect_equal(
    kansuji2arabic(c("\u4e00", "\u767e"), convert = FALSE),
    c(1, 100)
  )
  res <-
    kansuji2arabic(c("\u4e00", "\u767e", "\u5343"), .under = 1000)
  expect_is(res, "character")
  expect_equal(
    res,
    c("1", "100", "\u5343")
  )
  expect_equal(
    kansuji2arabic_all("\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341"),
    "012345678910"
  )
  expect_equal(
    kansuji2arabic_all("\u767e\u5343\u4e07"),
    "100100010000"
  )
  expect_equal(
    kansuji2arabic("\u96f6"),
    kansuji2arabic("\u3007")
  )
  expect_equal(
    kansuji2arabic_num("\u4e00\u5104\u4e8c\u5343\u4e09\u767e\u56db\u5341\u4e94\u4e07\u516d\u5343\u4e03\u767e\u516b\u5341\u4e5d"),
    "123456789"
  )
  expect_equal(
    kansuji2arabic_num("\u4e00\u5104\u4e8c\u4e09\u56db\u4e94\u4e07\u516d\u4e03\u516b\u4e5d"),
    "123456789"
  )
  expect_equal(
    kansuji2arabic_str("\u91d1\u4e00\u5104\u4e8c\u5343\u4e09\u767e\u56db\u5341\u4e94\u4e07\u516d\u5343\u4e03\u767e\u516b\u5341\u4e5d\u5186"),
    "\u91d1123456789\u5186"
  )
  expect_equal(
    kansuji2arabic_str("\u91d1\u4e00\u5104\u4e8c\u4e09\u56db\u4e94\u4e07\u516d\u4e03\u516b\u4e5d\u5186"),
    "\u91d1123456789\u5186"
  )
  expect_equal(
    kansuji2arabic_str("\u91d11\u51042345\u4e076789\u5186"),
    "\u91d1123456789\u5186"
  )
})

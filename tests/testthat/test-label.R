test_that("label format Arabic and Kansuji mix works", {
  number_kansuji <- label_kansuji(number = "arabic")
  expect_equal(number_kansuji(1e10), "100\u5104")
  expect_equal(number_kansuji(123456789), "1\u51042345\u4e076789")
})

test_that("label format Kansuji only works", {
  number_kansuji <- label_kansuji(number = "kansuji")
  expect_equal(number_kansuji(1e10), "\u767e\u5104")
  expect_equal(number_kansuji(123456789),
               "\u4e00\u5104\u4e8c\u5343\u4e09\u767e\u56db\u5341\u4e94\u4e07\u516d\u5343\u4e03\u767e\u516b\u5341\u4e5d")
})

test_that("label format suffix Kansuji works", {
  number_kansuji_suffix <- label_kansuji_suffix()
  expect_equal(number_kansuji_suffix(1e10), "100\u5104")
  expect_equal(number_kansuji_suffix(c(12000, 120000, 120000000)),
               c("1.2\u4e07", "12\u4e07",  "1.2\u5104"))
})

test_that("zip-code check is works", {
  expect_true(is_zipcode(7000027))
  expect_true(is_zipcode("7000027"))
  expect_true(is_zipcode("305-0053"))
  expect_message(
    expect_false(is_zipcode("305-005"))
  )
  expect_message(
    expect_false(is_zipcode("305"))
  )
})

test_that("zip-code spacer works", {
  expect_equal(
    zipcode_spacer("1000004"),
    "100-0004"
  )
  expect_equal(
    zipcode_spacer(1000004),
    "100-0004"
  )
  expect_equal(
    zipcode_spacer("100-0004", remove = TRUE),
    "1000004"
  )
  expect_equal(
    zipcode_spacer("305-0053", remove = FALSE),
    "305-0053"
  )
})

test_that("Utils", {
  skip_if_offline()
  expect_false(
    is_japanpost_zippath("example.com")
  )
  expect_true(
    is_japanpost_zippath("https://www.post.japanpost.jp/zipcode/dl/oogaki/zip/13tokyo.zip")
  )
  expect_error(
    dl_zipcode_file("example.com")
  )
})

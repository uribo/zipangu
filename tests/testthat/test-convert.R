test_that("", {
  expect_equal(
    convert_prefecture(c("tokyo-to", "osaka", "ALL"), to="kanji"),
    c("\u6771\u4eac\u90fd", "\u5927\u962a", "\u5168\u56fd")
  )
  expect_equal(
    convert_prefecture(c("\u6771\u4eac", "\u5927\u962a\u5e9c", "\u5317\u6d77\u9053", "\u5168\u56fd"), to="roman"),
    c("Tokyo", "Osaka-fu", "Hokkaido", "All")
  )
  expect_error(
    convert_prefecture(c("\u6771\u4eac"), to="kanji")
  )
  expect_error(
    convert_prefecture(c("tokyo"), to="roman")
  )
  expect_error(
    convert_prefecture(c("toky"), to="kanji")
  )
})
test_that("", {
  expect_equal(
    convert_prefecture_from_kana(c("\u3068\u3046\u304d\u3087\u3046\u3068")),
    c("\u6771\u4eac\u90fd")
  )
  expect_equal(
    convert_prefecture_from_kana(c("\u30c8\u30a6\u30ad\u30e7\u30a6", "\u304a\u304a\u3055\u304b")),
    c("\u6771\u4eac", "\u5927\u962a")
  )
  expect_equal(
    convert_prefecture_from_kana(c("\u30c8\u30a6\u30ad\u30e7\u30a6\u30c8", "\u30ad\u30e7\u30a6\u30c8")),
    c("\u6771\u4eac\u90fd", "\u4eac\u90fd")
  )
  expect_error(
    convert_prefecture_from_kana("\u6771\u4eac\u90fd")
  )
})

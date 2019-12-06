test_that("conver jstr works", {
  expect_equal(
    str_jconv("\u30a2\u30a4\u30a6\u30a8\u30aa", str_conv_hirakana, to = "hiragana"),
    "\u3042\u3044\u3046\u3048\u304a"
  )
  expect_equal(
    str_jconv("\u3042\u3044\u3046\u3048\u304a", str_conv_hirakana, to = "katakana"),
    "\u30a2\u30a4\u30a6\u30a8\u30aa"
  )
  expect_equal(
    str_jconv("\uff41\uff10", str_conv_zenhan, "hankaku"),
    "a0"
  )
  expect_equal(
    str_jconv("\uff76\uff9e\uff6f", str_conv_zenhan, "zenkaku"),
    "\u30ac\u30c3"
  )
  expect_equal(
    str_jconv("\u3042\u3044\u3046\u3048\u304a", str_conv_romanhira, "roman"),
    "aiueo"
  )
  expect_equal(
    str_jconv("\u2460", str_conv_normalize, "nfkc"),
    "1"
  )
  expect_equal(
    str_conv_hirakana("\u30a2\u30a4\u30a6\u30a8\u30aa", to = "hiragana"),
    "\u3042\u3044\u3046\u3048\u304a"
  )
  expect_equal(
    str_conv_hirakana("\u3042\u3044\u3046\u3048\u304a", to = "katakana"),
    "\u30a2\u30a4\u30a6\u30a8\u30aa"
  )
  expect_equal(
    str_conv_zenhan("\uff41\uff10", "hankaku"),
    "a0"
  )
  expect_equal(
    str_conv_zenhan("\uff76\uff9e\uff6f", "zenkaku"),
    "\u30ac\u30c3"
  )
  expect_equal(
    str_conv_romanhira("\u3042\u3044\u3046\u3048\u304a", "roman"),
    "aiueo"
  )
  expect_equal(
    str_conv_romanhira("hiragana", "hiragana"),
    "\u3072\u3089\u304c\u306a"
  )
  expect_equal(
    str_conv_normalize("\u2460", "nfkc"),
    "1"
  )
})

test_that("noramalize works", {
  expect_equal(
    str_jnormalize("\uff5e\uff5e\uff5e\u30b9\u30fc\u30d1\u30fc\u30fc\u30fc\u30fc"),
    "\u30b9\u30fc\u30d1\u30fc"
  )
  expect_equal(
    str_jnormalize("Coding the Matrix"),
    "Coding the Matrix"
  )
  expect_equal(
    str_jnormalize("\uff30\uff32\uff2d\uff2c \u526f\u3000\u8aad\u3000\u672c"),
    "PRML\u526f\u8aad\u672c"
  )
  expect_equal(
    str_jnormalize(
      paste0(
        "\u5357\u30a2\u30eb\u30d7\u30b9\u306e\u3000\u5929\u7136\u6c34",
        "-\u3000\uff33\uff50\uff41\uff52\uff4b\uff49\uff4e\uff47\u3000",
        "\uff2c\uff45\uff4d\uff4f\uff4e\u3000",
        "\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a")
    ),
    paste0(
      "\u5357\u30a2\u30eb\u30d7\u30b9\u306e\u5929\u7136\u6c34",
      "-Sparking Lemon\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a")
  )
})

test_that("", {
  expect_equal(
    harmonize_prefecture_name("\u5ca9\u624b", to = "long"),
    "\u5ca9\u624b\u770c"
  )
  expect_equal(
    harmonize_prefecture_name(
      c("\u5317\u6d77\u9053", "\u9752\u68ee\u770c", "\u5ca9\u624b\u770c",
        "\u5bae\u57ce\u770c", "\u79cb\u7530\u770c", "\u5c71\u5f62\u770c",
        "\u798f\u5cf6\u770c", "\u8328\u57ce\u770c", "\u6803\u6728\u770c",
        "\u7fa4\u99ac\u770c", "\u57fc\u7389\u770c", "\u5343\u8449\u770c",
        "\u6771\u4eac\u90fd", "\u795e\u5948\u5ddd\u770c", "\u65b0\u6f5f\u770c",
        "\u5bcc\u5c71\u770c", "\u77f3\u5ddd\u770c", "\u798f\u4e95\u770c",
        "\u5c71\u68a8\u770c", "\u9577\u91ce\u770c", "\u5c90\u961c\u770c",
        "\u9759\u5ca1\u770c", "\u611b\u77e5\u770c", "\u4e09\u91cd\u770c",
        "\u6ecb\u8cc0\u770c", "\u4eac\u90fd\u5e9c", "\u5927\u962a\u5e9c",
        "\u5175\u5eab\u770c", "\u5948\u826f\u770c", "\u548c\u6b4c\u5c71\u770c",
        "\u9ce5\u53d6\u770c", "\u5cf6\u6839\u770c", "\u5ca1\u5c71\u770c",
        "\u5e83\u5cf6\u770c", "\u5c71\u53e3\u770c", "\u5fb3\u5cf6\u770c",
        "\u9999\u5ddd\u770c", "\u611b\u5a9b\u770c", "\u9ad8\u77e5\u770c",
        "\u798f\u5ca1\u770c", "\u4f50\u8cc0\u770c", "\u9577\u5d0e\u770c",
        "\u718a\u672c\u770c", "\u5927\u5206\u770c", "\u5bae\u5d0e\u770c",
        "\u9e7f\u5150\u5cf6\u770c", "\u6c96\u7e04\u770c"),
      to = "short"),
    c("\u5317\u6d77\u9053", "\u9752\u68ee", "\u5ca9\u624b",
      "\u5bae\u57ce", "\u79cb\u7530", "\u5c71\u5f62", "\u798f\u5cf6",
      "\u8328\u57ce", "\u6803\u6728", "\u7fa4\u99ac", "\u57fc\u7389",
      "\u5343\u8449", "\u6771\u4eac", "\u795e\u5948\u5ddd",
      "\u65b0\u6f5f", "\u5bcc\u5c71", "\u77f3\u5ddd", "\u798f\u4e95",
      "\u5c71\u68a8", "\u9577\u91ce", "\u5c90\u961c", "\u9759\u5ca1",
      "\u611b\u77e5", "\u4e09\u91cd", "\u6ecb\u8cc0", "\u4eac\u90fd",
      "\u5927\u962a", "\u5175\u5eab", "\u5948\u826f", "\u548c\u6b4c\u5c71",
      "\u9ce5\u53d6", "\u5cf6\u6839", "\u5ca1\u5c71", "\u5e83\u5cf6",
      "\u5c71\u53e3", "\u5fb3\u5cf6", "\u9999\u5ddd", "\u611b\u5a9b",
      "\u9ad8\u77e5", "\u798f\u5ca1", "\u4f50\u8cc0", "\u9577\u5d0e",
      "\u718a\u672c", "\u5927\u5206", "\u5bae\u5d0e", "\u9e7f\u5150\u5cf6",
      "\u6c96\u7e04")
  )
  expect_equal(
    harmonize_prefecture_name(
      c("\u8328\u57ce",
        "\u3064\u304f\u3070"),
      to = "long"),
    c("\u8328\u57ce\u770c",
      "\u3064\u304f\u3070")
  )
})
test_that("Is address elements", {
  expect_true(
    is_prefecture("\u5ca1\u5c71\u770c")
  )
  expect_false(
    is_prefecture("\u5ca1\u6d77\u770c")
  )
  expect_false(
    # Does not contain anything other character than the prefecture name
    is_prefecture("\u8328\u57ce\u770c\u3064\u304f\u3070\u5e02")
  )
})

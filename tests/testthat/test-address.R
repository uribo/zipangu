test_that("address separate works", {
  expect_equal(
    separate_address("北海道札幌市中央区北1条西2丁目"),
    list(
      prefecture = "北海道",
      city = "札幌市中央区",
      street = "北1条西2丁目"
    )
  )
  expect_equal(
    separate_address("奈良県高市郡高取町"),
    list(
      prefecture = "奈良県",
      city = "高市郡高取町",
      street = NA_character_
    )
  )
  expect_equal(
    separate_address("北海道余市郡余市町朝日町"),
    list(
      prefecture = "北海道",
      city = "余市郡余市町",
      street = "朝日町"
    )
  )
  expect_equal(
    separate_address("北海道余市郡赤井川村"),
    list(
      prefecture = "北海道",
      city = "余市郡赤井川村",
      street = NA_character_
    )
  )
  expect_equal(
    separate_address("北海道余市郡余市町黒川町十九丁目"),
    list(
      prefecture = "北海道",
      city = "余市郡余市町",
      street = "黒川町十九丁目"
    )
  )
  expect_equal(
    separate_address("宮城県柴田郡村田町大字村田"),
    list(
      prefecture = "宮城県",
      city = "柴田郡村田町",
      street = "大字村田"
    )
  )
  expect_equal(
    separate_address("秋田県北上市町分"),
    list(
      prefecture = "秋田県",
      city = "北上市",
      street = "町分"
    )
  )
  expect_equal(
    separate_address("岡山県岡山市南区西七区"),
    list(
      prefecture = "岡山県",
      city = "岡山市南区",
      street = "西七区"
    )
  )
  expect_equal(
    separate_address("愛知県蒲郡市蒲郡中部土地区画整理43街区5"),
    list(
      prefecture = "愛知県",
      city = "蒲郡市",
      street = "蒲郡中部土地区画整理43街区5"
    )
  )
  expect_equal(
    separate_address("つくば市谷田部陣場F-6街区3"),
    list(
      prefecture = NA_character_,
      city = "つくば市",
      street = "谷田部陣場F-6街区3"
    )
  )
  expect_equivalent(
    unlist(separate_address("神奈川県")),
    c("神奈川県", NA_character_, NA_character_)
  )
  expect_equivalent(
    unlist(separate_address("西京都は存在しない")),
    c(NA_character_, NA_character_, NA_character_)
  )
  expect_equal(
    separate_address("岡山市"),
    list(
      prefecture = NA_character_,
      city = "岡山市",
      street = NA_character_
    )
  )
  str <-
    c("\u8328\u57ce\u770c\u3064\u304f\u3070\u5e02\u7814\u7a76\u5b66\u5712\u4e00\u4e01\u76ee1\u756a\u57301",
      "\u5ca1\u5c71\u770c\u5ca1\u5c71\u5e02\u5317\u533a\u5927\u4f9b\u4e00\u4e01\u76ee1\u756a1\u53f7")
  res <-
    separate_address(str)
  expect_length(
    res,
    2L
  )
})

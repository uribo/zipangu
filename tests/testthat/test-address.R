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
    separate_address("岡山市"),
    list(
      prefecture = NA_character_,
      city = "岡山市",
      street = NA_character_
    )
  )
})

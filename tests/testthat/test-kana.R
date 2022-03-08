test_that("hiragana", {
  expect_error(kana(type = "hiraganaa"))
  expect_warning(
    kana(type = "hira", core = FALSE)
  )
  expect_length(
    kana(type = "hira", core = TRUE),
    46L
  )
  expect_equal(
    kana(type = "hira", dakuon = TRUE, core = FALSE),
    c("\u304c", "\u304e", "\u3050", "\u3052", "\u3054", "\u3056",
      "\u3058", "\u305a", "\u305c", "\u305e", "\u3060", "\u3062",
      "\u3065", "\u3067", "\u3069", "\u3070", "\u3073", "\u3076",
      "\u3079", "\u307c", "\u3094")
  )
  expect_equal(
    kana(type = "hira", handakuon = TRUE, core = FALSE),
    c("\u3071", "\u3074", "\u3077", "\u307a", "\u307d")
  )
  expect_equal(
    kana(type = "hira", kogaki = TRUE, core = FALSE),
    c("\u3041", "\u3043", "\u3045", "\u3047", "\u3049", "\u3063",
      "\u3083", "\u3085", "\u3087", "\u308e", "\u3095", "\u3096"
    )
  )
  expect_equal(
    kana(type = "hira", historical = TRUE, core = FALSE),
    c("\u3090", "\u3091")
  )
  expect_equal(
    sum(stringi::stri_detect_charclass(
      hiragana(historical = FALSE),
      "\\p{hira}")),
    46L
  )
  identical(
    kana(type = "hira", core = TRUE),
    kana(type = "hiragana", core = TRUE)
  )
})

test_that("katakana", {
  expect_length(
    kana(type = "kata",
         core = FALSE,
         dakuon = TRUE),
    21L
  )
})

test_that("conversion", {
  expect_identical(
    kana(type = "hira", core = TRUE),
    stringi::stri_trans_general(kana(type = "kata", core = TRUE), "hira")
  )
})

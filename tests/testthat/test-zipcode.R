test_that("read_zipcode", {
  path <- system.file("zipcode_dummy/13TOKYO_oogaki.CSV",
                      package = "zipangu")
  expect_s3_class(
    read_zipcode(path, type = "oogaki"),
    "tbl_df"
  )
  expect_equal(
    ncol(read_zipcode(path, "oogaki")),
    15L
  )
  expect_named(
    read_zipcode(path, "oogaki"),
    c("jis_code", "old_zip_code", "zip_code",
      paste0(c("prefecture", "city", "street"), "_kana"),
      c("prefecture", "city", "street"),
      "is_street_duplicate",
      "is_banchi",
      "is_cyoumoku",
      "is_zipcode_duplicate",
      "status",
      "modify_type"
    )
  )
  expect_equal(
    names(read_zipcode(path,
                       "oogaki")),
    names(read_zipcode(system.file("zipcode_dummy/13TOKYO_kogaki.CSV",
                                   package = "zipangu"),
                       "kogaki"))
  )
  expect_named(
    read_zipcode(system.file("zipcode_dummy/KEN_ALL_ROME.CSV",
                             package = "zipangu"),
                 "roman"),
    c("zip_code",
      c("prefecture", "city", "street"),
      paste0(c("prefecture", "city", "street"), "_roman")
    )
  )
  expect_named(
    read_zipcode(system.file("zipcode_dummy/JIGYOSYO.CSV",
                             package = "zipangu"),
                 "jigyosyo"),
    c("jis_code", "name_kana", "name",
      c("prefecture", "city", "street"),
      "street_sub",
      "jigyosyo_identifier",
      "old_zip_code",
      "grouped",
      "individual_id",
      "multiple_type",
      "update_type"
    )
  )
})

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

################################
# 日本郵便 郵便番号データダウンロード
# ライセンス: 特になし
# > 郵便番号データに限っては日本郵便株式会社は著作権を主張しません。自由に配布していただいて結構です。
################################
pkgload::load_all()
library(dplyr)
dir.create("data-raw/japanpost")
dir.create("inst/zipcode_dummy")

dl_zipcode_file(path = "https://www.post.japanpost.jp/zipcode/dl/oogaki/zip/13tokyo.zip",
                exdir = "data-raw/japanpost/")
write.csv(
  read_zipcode("data-raw/japanpost/13TOKYO.CSV", "oogaki") %>%
    filter(jis_code == "13101",
           zip_code == "1000001"),
    file = "inst/zipcode_dummy/13TOKYO_oogaki.CSV",
    row.names = FALSE,
    fileEncoding = "cp932")

dl_zipcode_file(path = "https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/13tokyo.zip",
                exdir = "data-raw/japanpost/")
write.csv(
  read_zipcode("data-raw/japanpost/13TOKYO.CSV", "oogaki") %>%
    filter(jis_code == "13101",
           zip_code == "1000001"),
  file = "inst/zipcode_dummy/13TOKYO_kogaki.CSV",
  row.names = FALSE,
  fileEncoding = "cp932")

dl_zipcode_file("https://www.post.japanpost.jp/zipcode/dl/roman/ken_all_rome.zip?190712",
                "data-raw/japanpost/")
write.csv(
  read_zipcode("data-raw/japanpost/KEN_ALL_ROME.CSV", "roman") %>%
    filter(zip_code == "1000001"),
    file = "inst/zipcode_dummy/KEN_ALL_ROME.CSV",
    row.names = FALSE,
    fileEncoding = "cp932")

dl_zipcode_file("https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip",
                "data-raw/japanpost/")
write.csv(
  read_zipcode("data-raw/japanpost/JIGYOSYO.CSV", "jigyosyo") %>%
    filter(jis_code == "13101",
           stringr::str_detect(name, "日本郵便")),
    file = "inst/zipcode_dummy/JIGYOSYO.CSV",
    row.names = FALSE,
    fileEncoding = "cp932")

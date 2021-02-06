#####################################
# last update: 2021-02-05
# 内閣府 昭和30年（1955年）から令和4年（2022年）国民の祝日ファイルダウンロード
# https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html
#####################################
library(dplyr)
dir.create("data-raw/cabinet_office")
download.file(url = "https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv",
              destfile = "data-raw/cabinet_office/syukujitsu.csv")

jholiday_df <-
  read.csv("data-raw/cabinet_office/syukujitsu.csv",
             fileEncoding = "cp932",
         stringsAsFactors = FALSE) %>%
  purrr::set_names(c("date", "holiday_name")) %>%
  mutate(date = lubridate::as_date(date)) %>%
  tibble::as_tibble()

usethis::use_data(jholiday_df, internal = TRUE, overwrite = TRUE)

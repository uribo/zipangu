#' Separate address elements
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' Parses and decomposes address string into elements of
#' prefecture, city, and lower address.
#' @param str Input vector. address string.
#' @return A list of elements that make up an address.
#' @examples
#' separate_address("\u5317\u6d77\u9053\u672d\u5e4c\u5e02\u4e2d\u592e\u533a")
#' @export
separate_address <- function(str) {
  . <- NULL
  city_name_regex <-
    "(\u5ca1\u5c71\u5e02\u5357\u533a|(\u98ef\u80fd|\u4e0a\u5c3e|\u5b89\u4e2d|\u5742\u4e95|\u753a\u7530|\u5e02\u539f|\u5e02\u5ddd|\u6751\u4e0a)\u5e02|\u6751\u5c71\u5e02|\u4f59\u5e02\u90e1(\u4f59\u5e02\u753a|\u4ec1\u6728\u753a|\u8d64\u4e95\u5ddd\u6751)|(\u4f59\u5e02|\u9ad8\u5e02)\u90e1.+(\u753a|\u6751)|\u67f4\u7530\u90e1(\u6751\u7530\u753a|\u5927\u6cb3\u539f\u753a)|(\u6b66\u8535|\u6771)\u6751\u5c71\u5e02|\u897f\u6751\u5c71\u90e1\u6cb3\u5317\u753a|\u5317\u6751\u5c71\u90e1\u5927\u77f3\u7530\u753a|(\u6771|\u897f|\u5317)\u6751\u5c71\u90e1.+(\u753a|\u6751)|\u7530\u6751(\u5e02|\u90e1..\u753a)|\u82b3\u8cc0\u90e1\u5e02\u8c9d\u753a|(\u4f50\u6ce2\u90e1)?\u7389\u6751\u753a|[\u7fbd\u5927]\u6751\u5e02|(\u5341\u65e5|\u5927)\u753a\u5e02|(\u4e2d\u65b0\u5ddd\u90e1)?\u4e0a\u5e02\u753a|(\u91ce\u3005|[\u56db\u5eff]\u65e5)\u5e02\u5e02|\u897f\u516b\u4ee3\u90e1\u5e02\u5ddd\u4e09\u90f7\u753a|\u795e\u5d0e\u90e1\u5e02\u5ddd\u753a|\u9ad8\u5e02\u90e1(\u9ad8\u53d6\u753a|\u660e\u65e5\u9999\u6751)|(\u5409\u91ce\u90e1)?\u4e0b\u5e02\u753a|(\u6775\u5cf6\u90e1)?\u5927\u753a\u753a|(\u5357\u76f8\u99ac|\u5317\u4e0a|\u5965\u5dde|\u90a3\u9808\u5869\u539f|\u5370\u897f|\u4e0a\u8d8a|\u59eb\u8def|\u7389\u91ce|\u5c71\u53e3|\u4f50\u4f2f|\u5317\u898b|\u58eb\u5225|\u5bcc\u826f\u91ce|\u65ed\u5ddd|\u4f0a\u9054|\u77f3\u72e9|\u5bcc\u5c71|\u9ed2\u90e8|\u5c0f\u8af8|\u5869\u5c3b|\u677e\u962a|\u8c4a\u5ddd|\u798f\u77e5\u5c71|\u5468\u5357|\u897f\u6d77|\u5225\u5e9c)\u5e02|(\u5343\u4ee3\u7530|\u4e2d\u592e|\u6e2f|\u65b0\u5bbf|\u6587\u4eac|\u53f0\u6771|\u58a8\u7530|\u6c5f\u6771|\u54c1\u5ddd|\u76ee\u9ed2|\u5927\u7530|\u4e16\u7530\u8c37|\u6e0b\u8c37|\u4e2d\u91ce|\u6749\u4e26|\u8c4a\u5cf6|\u5317|\u8352\u5ddd|\u677f\u6a4b|\u7df4\u99ac|\u8db3\u7acb|\u845b\u98fe|\u6c5f\u6238\u5ddd)\u533a|.+\u5e02.+\u533a|\u5e02|\u753a|\u6751)"
  res <-
    purrr::map(
    str,
    function(str) {
      split_pref <-
        stringr::str_split(str,
                           stringr::regex("(?<=(\u6771\u4eac\u90fd|\u9053|\u5e9c|\u770c))"),
                           n = 2,
                           simplify = TRUE) %>%
        stringr::str_subset(".{1}", negate = FALSE)
      if (length(split_pref) == 1L) {
        if (is_prefecture(str)) {
          split_pref <- c(split_pref, NA_character_)
        } else {
          if (stringr::str_detect(split_pref,
                                  city_name_regex)) {
            split_pref <- c(NA_character_, split_pref)
          } else {
            split_pref <- c(NA_character_, NA_character_)
          }
        }
      }
      res <-
        list(prefecture = split_pref[1])
      if (length(split_pref[2] %>%
                 stringr::str_split(city_name_regex,
                                    n = 2,
                                    simplify = TRUE) %>%
                 stringr::str_subset(".{1}", negate = FALSE)) == 0L) {
        res <-
          res %>%
          purrr::list_merge(
            city =
              split_pref[2] %>%
              dplyr::if_else(is_address_block(.),
                             stringr::str_remove(., "((\u571f\u5730\u533a\u753b|\u8857\u533a).+)") %>%
                               stringr::str_remove("\u571f\u5730\u533a\u753b|\u8857\u533a"),
                             .) %>%
              stringr::str_replace("(.\u5e02)(.+\u753a.+)", "\\1") %>%
              stringr::str_replace(city_name_regex,
                                   replacement = "\\1")
          )
      } else {
        res <-
          res %>%
          purrr::list_merge(
            city =
              split_pref[2] %>%
              dplyr::if_else(is_address_block(.),
                             stringr::str_remove(., "((\u571f\u5730\u533a\u753b|\u8857\u533a).+)") %>%
                               stringr::str_remove("\u571f\u5730\u533a\u753b|\u8857\u533a"),
                             .) %>%
              stringr::str_replace(
                paste0(city_name_regex, "(.+)"),
                replacement = "\\1"))
      }
      res <-
        res %>%
        purrr::list_merge(
          street = split_pref[2] %>%
            stringr::str_remove(res %>%
                                  purrr::pluck("city")))
      res %>%
        purrr::map(
          ~ dplyr::if_else(.x == "", NA_character_, .x)
        )
    }
  )
  if (length(res) == 1L) {
    purrr::flatten(res)
  } else {
    res
  }
}

is_prefecture <- function(str) {
  stringr::str_detect(str,
                      stringr::regex("^(\u5317\u6d77\u9053|\u6771\u4eac\u90fd|(\u5927\u962a|\u4eac\u90fd)\u5e9c|(\u795e\u5948\u5ddd|\u548c\u6b4c\u5c71|\u9e7f\u5150\u5cf6)\u770c|(\u9752\u68ee|\u5ca9\u624b|\u5bae\u57ce|\u79cb\u7530|\u5c71\u5f62|\u798f\u5cf6|\u8328\u57ce|\u6803\u6728|\u7fa4\u99ac|\u57fc\u7389|\u5343\u8449|\u65b0\u6f5f|\u5bcc\u5c71|\u77f3\u5ddd|\u798f\u4e95|\u5c71\u68a8|\u9577\u91ce|\u5c90\u961c|\u9759\u5ca1|\u611b\u77e5|\u4e09\u91cd|\u6ecb\u8cc0|\u5175\u5eab|\u5948\u826f|\u9ce5\u53d6|\u5cf6\u6839|\u5ca1\u5c71|\u5e83\u5cf6|\u5c71\u53e3|\u5fb3\u5cf6|\u9999\u5ddd|\u611b\u5a9b|\u9ad8\u77e5|\u798f\u5ca1|\u4f50\u8cc0|\u9577\u5d0e|\u718a\u672c|\u5927\u5206|\u5bae\u5d0e|\u6c96\u7e04)\u770c)$"))
}

is_address_block <- function(str) {
  str %>%
    stringr::str_detect("(\u571f\u5730\u533a\u753b\u4e8b\u696d\u5730\u5185|\u8857\u533a|\u8857\u533a.+)$")
}

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
  city_name_regex <-
    "(\u5ca1\u5c71\u5e02\u5357\u533a|(\u98ef\u80fd|\u4e0a\u5c3e|\u5b89\u4e2d|\u5742\u4e95|\u753a\u7530|\u5e02\u539f|\u5e02\u5ddd|\u6751\u4e0a)\u5e02|\u6751\u5c71\u5e02|\u4f59\u5e02\u90e1(\u4f59\u5e02\u753a|\u4ec1\u6728\u753a|\u8d64\u4e95\u5ddd\u6751)|(\u4f59\u5e02|\u9ad8\u5e02)\u90e1.+(\u753a|\u6751)|\u67f4\u7530\u90e1(\u6751\u7530\u753a|\u5927\u6cb3\u539f\u753a)|(\u6b66\u8535|\u6771)\u6751\u5c71\u5e02|\u897f\u6751\u5c71\u90e1\u6cb3\u5317\u753a|\u5317\u6751\u5c71\u90e1\u5927\u77f3\u7530\u753a|(\u6771|\u897f|\u5317)\u6751\u5c71\u90e1.+(\u753a|\u6751)|\u7530\u6751(\u5e02|\u90e1..\u753a)|\u82b3\u8cc0\u90e1\u5e02\u8c9d\u753a|(\u4f50\u6ce2\u90e1)?\u7389\u6751\u753a|[\u7fbd\u5927]\u6751\u5e02|(\u5341\u65e5|\u5927)\u753a\u5e02|(\u4e2d\u65b0\u5ddd\u90e1)?\u4e0a\u5e02\u753a|(\u91ce\u3005|[\u56db\u5eff]\u65e5)\u5e02\u5e02|\u897f\u516b\u4ee3\u90e1\u5e02\u5ddd\u4e09\u90f7\u753a|\u795e\u5d0e\u90e1\u5e02\u5ddd\u753a|\u9ad8\u5e02\u90e1(\u9ad8\u53d6\u753a|\u660e\u65e5\u9999\u6751)|(\u5409\u91ce\u90e1)?\u4e0b\u5e02\u753a|(\u6775\u5cf6\u90e1)?\u5927\u753a\u753a|(\u5357\u76f8\u99ac|\u5317\u4e0a|\u5965\u5dde|\u90a3\u9808\u5869\u539f|\u5370\u897f|\u4e0a\u8d8a|\u59eb\u8def|\u7389\u91ce|\u5c71\u53e3|\u4f50\u4f2f|\u5317\u898b|\u58eb\u5225|\u5bcc\u826f\u91ce|\u65ed\u5ddd|\u4f0a\u9054|\u77f3\u72e9|\u5bcc\u5c71|\u9ed2\u90e8|\u5c0f\u8af8|\u5869\u5c3b|\u677e\u962a|\u8c4a\u5ddd|\u798f\u77e5\u5c71|\u5468\u5357|\u897f\u6d77|\u5225\u5e9c)\u5e02|(\u5343\u4ee3\u7530|\u4e2d\u592e|\u6e2f|\u65b0\u5bbf|\u6587\u4eac|\u53f0\u6771|\u58a8\u7530|\u6c5f\u6771|\u54c1\u5ddd|\u76ee\u9ed2|\u5927\u7530|\u4e16\u7530\u8c37|\u6e0b\u8c37|\u4e2d\u91ce|\u6749\u4e26|\u8c4a\u5cf6|\u5317|\u8352\u5ddd|\u677f\u6a4b|\u7df4\u99ac|\u8db3\u7acb|\u845b\u98fe|\u6c5f\u6238\u5ddd)\u533a|.+\u5e02.+\u533a|\u5e02|\u753a|\u6751)"
  split_pref =
    stringr::str_split(str,
                       stringr::regex("(?<=(\u6771\u4eac\u90fd|\u9053|\u5e9c|\u770c))"),
                       n = 2,
                       simplify = TRUE) %>%
    stringr::str_subset(".{1}", negate = FALSE)
  if (length(split_pref) == 1L) {
    split_pref[2] <- split_pref
    split_pref[1] <- NA_character_
  }
  if (length(split_pref[2] %>%
             stringr::str_split(city_name_regex,
                                n = 2,
                                simplify = TRUE) %>%
             stringr::str_subset(".{1}", negate = FALSE)) == 0L) {
    res <-
      list(
        prefecture = split_pref[1],
        city =
          split_pref[2] %>%
          stringr::str_replace(city_name_regex,
                               replacement = "\\1"),
        street =
          split_pref[2] %>%
          stringr::str_remove(
            split_pref[2] %>%
              stringr::str_replace(city_name_regex,
                                   replacement = "\\1")
          )
      )
  } else {
    res <-
      list(
        prefecture = split_pref[1],
        city =
          split_pref[2] %>%
          stringr::str_replace(
            paste0(city_name_regex, "(.+)"),
            replacement = "\\1"),
        street =
          split_pref[2] %>%
          stringr::str_remove(
            split_pref[2] %>%
              stringr::str_replace(
                paste0(city_name_regex, "(.+)"),
                replacement = "\\1")
          )
      )
  }
  res %>%
    purrr::map(
      ~ dplyr::if_else(.x == "", NA_character_, .x)
    )
}

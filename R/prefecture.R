#' Harmonize the notation of Japanese prefecture names.
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' @details Convert with and without terminal notation, respectively.
#' * long option, long formal name
#' * Use the short option to omit the trailing characters
#' @param x Input vector.
#' @param to Option. Whether to use longer ("long") or shorter ("short")
#' prefectures.
#' @examples
#' x <- c("\u6771\u4eac\u90fd", "\u5317\u6d77\u9053", "\u6c96\u7e04\u770c")
#' harmonize_prefecture_name(x, to = "short")
#' x <- c("\u6771\u4eac", "\u5317\u6d77\u9053", "\u6c96\u7e04")
#' harmonize_prefecture_name(x, to = "long")
#' @export
harmonize_prefecture_name <- function(x, to) {
  type <-
    rlang::arg_match(to,
                   c("short", "long"))
  if (to == "short") {
    tgt_index <-
      x %>%
      stringr::str_detect("^(\u5317\u6d77\u9053|\u6771\u4eac\u90fd|(\u5927\u962a|\u4eac\u90fd)\u5e9c|(\u795e\u5948\u5ddd|\u548c\u6b4c\u5c71|\u9e7f\u5150\u5cf6)\u770c|(\u9752\u68ee|\u5ca9\u624b|\u5bae\u57ce|\u79cb\u7530|\u5c71\u5f62|\u798f\u5cf6|\u8328\u57ce|\u6803\u6728|\u7fa4\u99ac|\u57fc\u7389|\u5343\u8449|\u65b0\u6f5f|\u5bcc\u5c71|\u77f3\u5ddd|\u798f\u4e95|\u5c71\u68a8|\u9577\u91ce|\u5c90\u961c|\u9759\u5ca1|\u611b\u77e5|\u4e09\u91cd|\u6ecb\u8cc0|\u5175\u5eab|\u5948\u826f|\u9ce5\u53d6|\u5cf6\u6839|\u5ca1\u5c71|\u5e83\u5cf6|\u5c71\u53e3|\u5fb3\u5cf6|\u9999\u5ddd|\u611b\u5a9b|\u9ad8\u77e5|\u798f\u5ca1|\u4f50\u8cc0|\u9577\u5d0e|\u718a\u672c|\u5927\u5206|\u5bae\u5d0e|\u6c96\u7e04)\u770c)$") %>%
      which()
  } else if (to == "long") {
    tgt_index <-
      x %>%
      stringr::str_detect("^(\u5317\u6d77\u9053|\u6771\u4eac|\u5927\u962a|\u4eac\u90fd|\u795e\u5948\u5ddd|\u548c\u6b4c\u5c71|\u9e7f\u5150\u5cf6|\u9752\u68ee|\u5ca9\u624b|\u5bae\u57ce|\u79cb\u7530|\u5c71\u5f62|\u798f\u5cf6|\u8328\u57ce|\u6803\u6728|\u7fa4\u99ac|\u57fc\u7389|\u5343\u8449|\u65b0\u6f5f|\u5bcc\u5c71|\u77f3\u5ddd|\u798f\u4e95|\u5c71\u68a8|\u9577\u91ce|\u5c90\u961c|\u9759\u5ca1|\u611b\u77e5|\u4e09\u91cd|\u6ecb\u8cc0|\u5175\u5eab|\u5948\u826f|\u9ce5\u53d6|\u5cf6\u6839|\u5ca1\u5c71|\u5e83\u5cf6|\u5c71\u53e3|\u5fb3\u5cf6|\u9999\u5ddd|\u611b\u5a9b|\u9ad8\u77e5|\u798f\u5ca1|\u4f50\u8cc0|\u9577\u5d0e|\u718a\u672c|\u5927\u5206|\u5bae\u5d0e|\u6c96\u7e04)$") %>%
      which()
  }
  if (length(tgt_index) > 0) {
    x <-
      replace(x,
              tgt_index,
              x[tgt_index] %>%
                convert_prefecture_name(to = to))
    }
  x
}

convert_prefecture_name <- function(x, to) {
  if (to == "short") {
    stringr::str_remove(x, "(\u90fd|\u5e9c|\u770c)$")
  } else if (to == "long") {
    dplyr::case_when(
      stringr::str_detect(x, "\u5317\u6d77\u9053") ~ "\u5317\u6d77\u9053",
      stringr::str_detect(x, "\u6771\u4eac") ~ paste0(x, "\u90fd"),
      stringr::str_detect(x, "\u5927\u962a|\u4eac\u90fd") ~ paste0(x, "\u5e9c"),
      stringr::str_detect(x, "\u5317\u6d77\u9053|\u6771\u4eac|\u5927\u962a|\u4eac\u90fd",
                          negate = TRUE) ~ paste0(x, "\u770c"))
  }
}

#' Check correctly prefecture names
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("stable")}
#' @details Check if the string is a prefectural string.
#' If it contains the name of the prefecture and other
#' strings (e.g. city name), it returns `FALSE`.
#' @inheritParams harmonize_prefecture_name
#' @return logical
#' @examples
#' is_prefecture("\u6771\u4eac\u90fd")
#' is_prefecture(c("\u6771\u4eac", "\u4eac\u90fd", "\u3064\u304f\u3070"))
#' @export
#' @rdname is_prefecture
is_prefecture <- function(x) {
  stringr::str_detect(x,
                      stringr::regex("^(\u5317\u6d77\u9053|\u6771\u4eac\u90fd|(\u5927\u962a|\u4eac\u90fd)\u5e9c|(\u795e\u5948\u5ddd|\u548c\u6b4c\u5c71|\u9e7f\u5150\u5cf6)\u770c|(\u9752\u68ee|\u5ca9\u624b|\u5bae\u57ce|\u79cb\u7530|\u5c71\u5f62|\u798f\u5cf6|\u8328\u57ce|\u6803\u6728|\u7fa4\u99ac|\u57fc\u7389|\u5343\u8449|\u65b0\u6f5f|\u5bcc\u5c71|\u77f3\u5ddd|\u798f\u4e95|\u5c71\u68a8|\u9577\u91ce|\u5c90\u961c|\u9759\u5ca1|\u611b\u77e5|\u4e09\u91cd|\u6ecb\u8cc0|\u5175\u5eab|\u5948\u826f|\u9ce5\u53d6|\u5cf6\u6839|\u5ca1\u5c71|\u5e83\u5cf6|\u5c71\u53e3|\u5fb3\u5cf6|\u9999\u5ddd|\u611b\u5a9b|\u9ad8\u77e5|\u798f\u5ca1|\u4f50\u8cc0|\u9577\u5d0e|\u718a\u672c|\u5927\u5206|\u5bae\u5d0e|\u6c96\u7e04)\u770c|\u6771\u4eac|\u5927\u962a|\u4eac\u90fd|\u795e\u5948\u5ddd|\u548c\u6b4c\u5c71|\u9e7f\u5150\u5cf6|\u9752\u68ee|\u5ca9\u624b|\u5bae\u57ce|\u79cb\u7530|\u5c71\u5f62|\u798f\u5cf6|\u8328\u57ce|\u6803\u6728|\u7fa4\u99ac|\u57fc\u7389|\u5343\u8449|\u65b0\u6f5f|\u5bcc\u5c71|\u77f3\u5ddd|\u798f\u4e95|\u5c71\u68a8|\u9577\u91ce|\u5c90\u961c|\u9759\u5ca1|\u611b\u77e5|\u4e09\u91cd|\u6ecb\u8cc0|\u5175\u5eab|\u5948\u826f|\u9ce5\u53d6|\u5cf6\u6839|\u5ca1\u5c71|\u5e83\u5cf6|\u5c71\u53e3|\u5fb3\u5cf6|\u9999\u5ddd|\u611b\u5a9b|\u9ad8\u77e5|\u798f\u5ca1|\u4f50\u8cc0|\u9577\u5d0e|\u718a\u672c|\u5927\u5206|\u5bae\u5d0e|\u6c96\u7e04)$"))
}

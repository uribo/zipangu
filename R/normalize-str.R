#' Converts characters following the rules of 'neologd'
#' @details Converts the characters into normalized style
#' basing on rules that is recommended by the Neologism dictionary for MeCab.
#' @seealso \url{https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja}
#' @param str Input vector.
#' @return a character
#' @examples
#' str_jnormalize(
#'   paste0(
#'     "    \uff30",
#'     "\uff32\uff2d\uff2c\u300    \u526f    \u8aad    \u672c      "
#'   )
#' )
#' str_jnormalize(
#'   paste0(
#'     "\u5357\u30a2\u30eb\u30d7\u30b9\u306e\u3000\u5929\u7136\u6c34",
#'     "-\u3000\uff33\uff50\uff41\uff52\uff4b\uff49\uff4e\uff47\u3000",
#'     "\uff2c\uff45\uff4d\uff4f\uff4e\u3000\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a"
#'  )
#' )
#' @export
str_jnormalize <- function(str) {
  res <- str_conv_normalize(str, to = "nfkc")
  res <- stringr::str_replace_all(
    res,
    c("\'", "\"") %>%
    purrr::set_names(c(intToUtf8(8217), intToUtf8(8221)))) %>%
  stringr::str_replace_all(
    "[\\-\u02d7\u058a\u2010\u2011\u2012\u2013\u2043\u207b\u208b\u2212]+", "-"
  ) %>%
  stringr::str_replace_all(
    "[\ufe63\uff0d\uff70\u2014\u2015\u2500\u2501\u30fc]+", enc2utf8("\u30fc")
  ) %>%
  stringr::str_replace_all(
    "([:blank:]){2,}", " "
  ) %>%
  stringr::str_replace_all(
    stringr::str_c(
      "([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)",
      "[[:blank:]]*",
      "([\u0021-\u007e[:punct:]]+)"
    ),
    "\\1\\2"
  ) %>%
  stringr::str_replace_all(
    stringr::str_c(
      "([\u0021-\u007e\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]*)",
      "[[:blank:]]*",
      "([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)"
    ),
    "\\1\\2"
  )
  res <- stringr::str_remove_all(res, "[~\u223c\u223e\u301c\u3030\uff5e]+")
  res <- stringr::str_trim(res)
  res <- stringr::str_remove_all(res, "[[:cntrl:]]+")
  return(res)
}

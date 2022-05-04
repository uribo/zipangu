#' Convert prefecture names from kana
#'
#' @param x prefecture name in kana
#'
#' @examples
#' convert_prefecture_from_kana(c("\u3068\u3046\u304d\u3087\u3046\u3068"))
#' convert_prefecture_from_kana(c("\u30c8\u30a6\u30ad\u30e7\u30a6\u30c8", "\u30ad\u30e7\u30a6\u30c8"))
#' convert_prefecture_from_kana(c("\u30c8\u30a6\u30ad\u30e7\u30a6", "\u304a\u304a\u3055\u304b"))
#'
#' @export
convert_prefecture_from_kana <- function(x) {
  x <- enc2utf8(as.character(x)) # Encoding to UTF-8

  x <- str_conv_hirakana(x, to = "hiragana") # Convert to hiragana
  # Avoid conflicts between
  # "\u304d\u3087\u3046\u3068" and "\u3068\u3046\u304d\u3087\u3046\u3068"
  x <- stringr::str_c("^", x, "$")

  for (i in 1:length(x)) {
    if (any(stringr::str_detect(prefecture_list[[3]], x[i]))) {
      x[i] <-
        prefecture_list[[1]][stringr::str_detect(prefecture_list[[3]], x[i])]
    } else if (any(stringr::str_detect(prefecture_list[[4]], x[i]))) {
      x[i] <-
        prefecture_list[[2]][stringr::str_detect(prefecture_list[[4]], x[i])]
    } else {
      stop(
        "\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059"
      )
    }
  }
  return(x)
}

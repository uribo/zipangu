#' Converts the kind of string used as Japanese
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("stable")}
#' @details Conversion form Katakana to Hiragana, vice versa
#' @inheritParams kansuji2arabic
#' @param fun convert function
#' @param to Select the type of character to convert.
#' @examples
#' str_jconv("\u30a2\u30a4\u30a6\u30a8\u30aa", str_conv_hirakana, to = "hiragana")
#' str_jconv("\u3042\u3044\u3046\u3048\u304a", str_conv_hirakana, to = "katakana")
#' str_jconv("\uff41\uff10", str_conv_zenhan, "hankaku")
#' str_jconv("\uff76\uff9e\uff6f", str_conv_zenhan, "zenkaku")
#' str_jconv("\u2460", str_conv_normalize, "nfkc")
#' str_conv_hirakana("\u30a2\u30a4\u30a6\u30a8\u30aa", to = "hiragana")
#' str_conv_hirakana("\u3042\u3044\u3046\u3048\u304a", to = "katakana")
#' str_conv_zenhan("\uff41\uff10", "hankaku")
#' str_conv_zenhan("\uff76\uff9e\uff6f", "zenkaku")
#' str_conv_normalize("\u2460", "nfkc")
#' @export
str_jconv <- function(str, fun, to) {
  fun(str, to)
}

#' @rdname str_jconv
#' @export
str_conv_hirakana <- function(str, to = c("hiragana", "katakana")) {
  rlang::arg_match(to)
  if (to == "hiragana") {
    stringi::stri_trans_general(str, "Katakana-Hiragana")
  } else {
    stringi::stri_trans_general(str, "Hiragana-Katakana")
  }
}

#' @rdname str_jconv
#' @export
str_conv_zenhan <- function(str, to = c("zenkaku", "hankaku")) {
  rlang::arg_match(to)
  switch (to,
          "zenkaku" = stringi::stri_trans_general(str, "Halfwidth-Fullwidth"),
          "hankaku" = stringi::stri_trans_general(str, "Fullwidth-Halfwidth")
  )
}

#' @rdname str_jconv
#' @export
str_conv_normalize <- function(str, to = c("nfkc")) {
  rlang::arg_match(to)
  stringi::stri_trans_general(str, "nfkc")
}

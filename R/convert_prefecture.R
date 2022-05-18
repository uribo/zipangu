convert_prefecture_to_kanji <- function(x) {
  x <- enc2utf8(as.character(x)) # Encoding to UTF-8
  if (any(is_prefecture(x) | x == "\u5168\u56fd"))
    stop(
      "\u65e5\u672c\u8a9e\u8868\u8a18\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059"
    ) # check:is Japanese
  x <- stringr::str_to_sentence(x) # Convert to sentence
  x <- stringr::str_c("^", x, "$")

  for (i in 1:length(x)) {
    if (any(stringr::str_detect(prefecture_list[[5]], x[i]))) {
      x[i] <-
        prefecture_list[[1]][stringr::str_detect(prefecture_list[[5]], x[i])] #Convert japanese to roman
    } else if (any(stringr::str_detect(prefecture_list[[6]], x[i]))) {
      x[i] <-
        prefecture_list[[2]][stringr::str_detect(prefecture_list[[6]], x[i])] #Convert japanese to roman
    } else {
      stop(
        "\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059"
      ) # check;is Japan
    }
  }
  return(x)
}

convert_prefecture_to_roman <- function(x) {
  x <- enc2utf8(as.character(x)) # Encoding to UTF-8
  if (any(!is_prefecture(x) & x != "\u5168\u56fd"))
    stop(
      "\u65e5\u672c\u8a9e\u8868\u8a18\u4ee5\u5916\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059"
    ) # check:is Japanese
  x <- stringr::str_c("^", x, "$")

  for (i in 1:length(x)) {
    if (any(stringr::str_detect(prefecture_list[[1]], x[i]))) {
      x[i] <-
        prefecture_list[[5]][stringr::str_detect(prefecture_list[[1]], x[i])] #Convert japanese to roman
    } else if (any(stringr::str_detect(prefecture_list[[2]], x[i]))) {
      x[i] <-
        prefecture_list[[6]][stringr::str_detect(prefecture_list[[2]], x[i])] #Convert japanese to roman
    } else {
      stop(
        "\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059"
      ) #check;is Japan
    }
  }
  return(x)
}

#' Convert prefecture names to roman or kanji
#'
#' @param x prefecture name in kanji
#' @param to conversion destination
#'
#' @examples
#' convert_prefecture(c("tokyo-to", "osaka", "ALL"), to="kanji")
#' convert_prefecture(
#'   c("\u6771\u4eac", "\u5927\u962a\u5e9c",
#'   "\u5317\u6d77\u9053", "\u5168\u56fd"),
#'   to = "roman")
#' @export
convert_prefecture <- function(x, to) {
  if (to == "kanji") {
    convert_prefecture_to_kanji(x)
  } else if (to == "roman") {
    convert_prefecture_to_roman(x)
  } else {
    stop("to\u304c\u6b63\u3057\u304f\u3042\u308a\u307e\u305b\u3093")
  }
}

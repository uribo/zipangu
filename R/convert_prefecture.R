#' Convert prefecture names to kanji
#'
#' @param x prefecture name in roman
#'
#' @importFrom stringr str_to_sentence
#' @importFrom stringr str_detect
#'
convert_prefecture_to_kanji <- function(x){
  x <- enc2utf8(as.character(x)) #Encoding to UTF-8
  if(any(is_prefecture(x)|x=="\u5168\u56fd"))
    stop("\u65e5\u672c\u8a9e\u8868\u8a18\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059") #check:is Japanese

  x <- str_to_sentence(x) #Convert to sentence
  y <- c(zipangu::jpnprefs$prefecture, "All") #Add all
  z <- c(zipangu::jpnprefs$prefecture_kanji, "\u5168\u56fd") #Add "\u5168\u56fd"

  for(i in 1:length(x)){
    if(!any(str_detect(y, x[i])))
      stop("\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059") #check;is Japan
    x[i] <- z[str_detect(y, x[i])] #Convert roman to japanese
  }
  return(x)
}



#' Convert prefecture names to roman
#'
#' @param x prefecture name in kanji
#'
#' @importFrom stringr str_detect
#'
convert_prefecture_to_roman <- function(x){
  x <- enc2utf8(as.character(x)) #Encoding to UTF-8
  if(any(!is_prefecture(x) & x!="\u5168\u56fd"))
    stop("\u65e5\u672c\u8a9e\u8868\u8a18\u4ee5\u5916\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059") #check:is Japanese

  x <- harmonize_prefecture_name(x, to="long")
  y <- c(zipangu::jpnprefs$prefecture, "All")
  z <- c(zipangu::jpnprefs$prefecture_kanji, "\u5168\u56fd")

  for(i in 1:length(x)){
    if(!any(str_detect(z, x[i])))
      stop("\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059") #check;is Japan
    x[i] <- y[str_detect(z, x[i])] #Convert japanese to roman
  }
  return(x)
}



#' Convert prefecture names to roman
#'
#' @param x prefecture name in kanji
#' @param to conversion destination
#'
#' @examples
#' convert_prefecture(c("tokyo", "osaka", "ALL"), to="kanji")
#' convert_prefecture(c("\u6771\u4eac", "\u5927\u962a\u5e9c", "\u5317\u6d77\u9053", "\u5168\u56fd"), to="roman")
#'
#' @export
#'
convert_prefecture <- function(x, to){
  if(to=="kanji"){
    convert_prefecture_to_kanji(x)
  } else if(to=="roman"){
    convert_prefecture_to_roman(x)
  } else {
    stop("to\u304c\u6b63\u3057\u304f\u3042\u308a\u307e\u305b\u3093")
  }
}

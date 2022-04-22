#' Convert prefecture names to kanji
#'
#' @param x prefecture name in roman
#'
#' @importFrom stringr str_to_sentence
#' @importFrom stringr str_detect
#'
convert_prefecture_to_kanji <- function(x){
  x <- enc2utf8(as.character(x)) #Encoding to UTF-8
  if(any(is_prefecture(x)|x=="全国"))
    stop("日本語表記が含まれています") #check:is Japanese

  x <- str_to_sentence(x) #Convert to sentence
  y <- c(zipangu::jpnprefs$prefecture, "All") #Add all
  z <- c(zipangu::jpnprefs$prefecture_kanji, enc2utf8("全国")) #Add 全国

  for(i in 1:length(x)){
    if(!any(str_detect(y, x[i]))) stop("存在しない地域が含まれています") #check;is Japan
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
  if(any(!is_prefecture(x) & x!="全国"))
    stop("日本語表記以外が含まれています") #check:is Japanese

  x <- harmonize_prefecture_name(x, to="long")
  y <- c(zipangu::jpnprefs$prefecture, "All")
  z <- c(zipangu::jpnprefs$prefecture_kanji, enc2utf8("全国"))

  for(i in 1:length(x)){
    if(!any(str_detect(z, x[i]))) stop("存在しない地域が含まれています") #check;is Japan
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
#' convert_prefecture(c("東京", "大阪府", "北海道", "全国"), to="roman")
#'
#' @export
#'
convert_prefecture <- function(x, to){
  if(to=="kanji"){
    convert_prefecture_to_kanji(x)
  } else if(to=="roman"){
    convert_prefecture_to_roman(x)
  } else {
    stop("toが正しくありません")
  }
}

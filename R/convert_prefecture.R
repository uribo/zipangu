#' List of prefecture long names in Kanji
#'
prefecture_kanji_long <- c("\u5317\u6d77\u9053","\u9752\u68ee\u770c","\u5ca9\u624b\u770c",
                           "\u5bae\u57ce\u770c","\u79cb\u7530\u770c","\u5c71\u5f62\u770c",
                           "\u798f\u5cf6\u770c","\u8328\u57ce\u770c","\u6803\u6728\u770c",
                           "\u7fa4\u99ac\u770c","\u57fc\u7389\u770c","\u5343\u8449\u770c",
                           "\u6771\u4eac\u90fd","\u795e\u5948\u5ddd\u770c","\u65b0\u6f5f\u770c",
                           "\u5bcc\u5c71\u770c","\u77f3\u5ddd\u770c","\u798f\u4e95\u770c",
                           "\u5c71\u68a8\u770c","\u9577\u91ce\u770c","\u5c90\u961c\u770c",
                           "\u9759\u5ca1\u770c","\u611b\u77e5\u770c","\u4e09\u91cd\u770c",
                           "\u6ecb\u8cc0\u770c","\u4eac\u90fd\u5e9c","\u5927\u962a\u5e9c",
                           "\u5175\u5eab\u770c","\u5948\u826f\u770c","\u548c\u6b4c\u5c71\u770c",
                           "\u9ce5\u53d6\u770c","\u5cf6\u6839\u770c","\u5ca1\u5c71\u770c",
                           "\u5e83\u5cf6\u770c","\u5c71\u53e3\u770c","\u5fb3\u5cf6\u770c",
                           "\u9999\u5ddd\u770c","\u611b\u5a9b\u770c","\u9ad8\u77e5\u770c",
                           "\u798f\u5ca1\u770c","\u4f50\u8cc0\u770c","\u9577\u5d0e\u770c",
                           "\u718a\u672c\u770c","\u5927\u5206\u770c","\u5bae\u5d0e\u770c",
                           "\u9e7f\u5150\u5cf6\u770c","\u6c96\u7e04\u770c","\u5168\u56fd")



#' List of prefecture short names in Kanji
#'
prefecture_kanji_short <- c("\u5317\u6d77\u9053","\u9752\u68ee","\u5ca9\u624b",
                            "\u5bae\u57ce","\u79cb\u7530","\u5c71\u5f62",
                            "\u798f\u5cf6","\u8328\u57ce","\u6803\u6728",
                            "\u7fa4\u99ac","\u57fc\u7389","\u5343\u8449",
                            "\u6771\u4eac","\u795e\u5948\u5ddd","\u65b0\u6f5f",
                            "\u5bcc\u5c71","\u77f3\u5ddd","\u798f\u4e95",
                            "\u5c71\u68a8","\u9577\u91ce","\u5c90\u961c",
                            "\u9759\u5ca1","\u611b\u77e5","\u4e09\u91cd",
                            "\u6ecb\u8cc0","\u4eac\u90fd","\u5927\u962a",
                            "\u5175\u5eab","\u5948\u826f","\u548c\u6b4c\u5c71",
                            "\u9ce5\u53d6","\u5cf6\u6839","\u5ca1\u5c71",
                            "\u5e83\u5cf6","\u5c71\u53e3","\u5fb3\u5cf6",
                            "\u9999\u5ddd","\u611b\u5a9b","\u9ad8\u77e5",
                            "\u798f\u5ca1","\u4f50\u8cc0","\u9577\u5d0e",
                            "\u718a\u672c","\u5927\u5206","\u5bae\u5d0e",
                            "\u9e7f\u5150\u5cf6","\u6c96\u7e04","\u5168\u56fd")



#' List of prefecture long names in Roman
#'
prefecture_roman_long <- c("Hokkaido","Aomori-ken","Iwate-ken","Miyagi-ken","Akita-ken","Yamagata-ken",
                           "Fukushima-ken","Ibaraki-ken","Tochigi-ken","Gunma-ken","Saitama-ken","Chiba-ken",
                           "Tokyo-to","Kanagawa-ken","Niigata-ken","Toyama-ken","Ishikawa-ken","Fukui-ken",
                           "Yamanashi-ken","Nagano-ken","Gifu-ken","Shizuoka-ken","Aichi-ken","Mie-ken",
                           "Shiga-ken","Kyoto-fu","Osaka-fu","Hyogo-ken","Nara-ken","Wakayama-ken",
                           "Tottori-ken","Shimane-ken","Okayama-ken","Hiroshima-ken","Yamaguchi-ken","Tokushima-ken",
                           "Kagawa-ken","Ehime-ken","Kochi-ken","Fukuoka-ken","Saga-ken","Nagasaki-ken",
                           "Kumamoto-ken","Oita-ken","Miyazaki-ken","Kagoshima-ken","Okinawa-ken","All")



#' List of prefecture short names in Roman
#'
prefecture_roman_short <- c("Hokkaido","Aomori","Iwate","Miyagi","Akita","Yamagata",
                            "Fukushima","Ibaraki","Tochigi","Gunma","Saitama","Chiba","Tokyo",
                            "Kanagawa","Niigata","Toyama","Ishikawa","Fukui",
                            "Yamanashi","Nagano","Gifu","Shizuoka","Aichi","Mie",
                            "Shiga","Kyoto","Osaka","Hyogo","Nara","Wakayama",
                            "Tottori","Shimane","Okayama","Hiroshima","Yamaguchi","Tokushima",
                            "Kagawa","Ehime","Kochi","Fukuoka","Saga","Nagasaki",
                            "Kumamoto","Oita","Miyazaki","Kagoshima","Okinawa","All")



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
  x <- str_c("^", x, "$")

  for(i in 1:length(x)){
    if(any(str_detect(prefecture_roman_long, x[i]))){
      x[i] <- prefecture_kanji_long[str_detect(prefecture_roman_long, x[i])] #Convert japanese to roman
    } else if(any(str_detect(prefecture_roman_short, x[i]))){
      x[i] <- prefecture_kanji_short[str_detect(prefecture_roman_short, x[i])] #Convert japanese to roman
    } else {
      stop("\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059") #check;is Japan
    }
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
  x <- str_c("^", x, "$")

  for(i in 1:length(x)){
    if(any(str_detect(prefecture_kanji_long, x[i]))){
      x[i] <- prefecture_roman_long[str_detect(prefecture_kanji_long, x[i])] #Convert japanese to roman
    } else if(any(str_detect(prefecture_kanji_short, x[i]))){
      x[i] <- prefecture_roman_short[str_detect(prefecture_kanji_short, x[i])] #Convert japanese to roman
    } else {
      stop("\u5b58\u5728\u3057\u306a\u3044\u5730\u57df\u304c\u542b\u307e\u308c\u3066\u3044\u307e\u3059") #check;is Japan
    }
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

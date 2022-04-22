#' Convert prefecture names from hiragana and katakana
#'
#' @param x prefecture name in hiragana or katakana
#'
#' @importFrom stringr str_c
#' @importFrom stringr str_detect
#'
#' @examples
#' convert_prefecture_from_hirakana(c("とうきょうと"))
#' convert_prefecture_from_hirakana(c("トウキョウト", "キョウト"))
#'
#' @export
#'
convert_prefecture_from_hirakana <- function(x){
  x <- enc2utf8(as.character(x)) #Encoding to UTF-8

  x <- str_conv_hirakana(x, to="hiragana") #Convert to hiragana
  x <- str_c("^", x) #Avoid conflicts between きょうと and とうきょうと
  y <- enc2utf8(c("ほっかいどう","あおもりけん","いわてけん","みやぎけん","あきたけん","やまがたけん",
                  "ふくしまけん","いばらきけん","とちぎけん","ぐんまけん","さいたまけん","ちばけん",
                  "とうきょうと","かながわけん","にいがたけん","とやまけん","いしかわけん","ふくいけん",
                  "やまなしけん","ながのけん","ぎふけん","しずおかけん","あいちけん","みえけん",
                  "しがけん","きょうとふ","おおさかふ","ひょうごけん","ならけん","わかやまけん",
                  "とっとりけん","しまねけん","おかやまけん","ひろしまけん","やまぐちけん","とくしまけん",
                  "かがわけん","えひめけん","こうちけん","ふくおかけん","さがけん","ながさきけん",
                  "くまもとけん","おおいたけん","みやざきけん","かごしまけん","おきなわけん","ぜんこく"))
  z <- enc2utf8(c("北海道","青森県","岩手県","宮城県","秋田県","山形県",
                  "福島県","茨城県","栃木県","群馬県","埼玉県","千葉県",
                  "東京都","神奈川県","新潟県","富山県","石川県","福井県",
                  "山梨県","長野県","岐阜県","静岡県","愛知県","三重県",
                  "滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県",
                  "鳥取県","島根県","岡山県","広島県","山口県","徳島県",
                  "香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                  "熊本県","大分県","宮崎県","鹿児島県","沖縄県","全国"))

  for(i in 1:length(x)){
    if(!any(str_detect(y, x[i]))) stop("存在しない地域が含まれています") #check;is Japan
    x[i] <- z[str_detect(y, x[i])] #Convert romen to japanese
  }

  return(x)
}

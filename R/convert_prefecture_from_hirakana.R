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
#' convert_prefecture_from_hirakana(c("トウキョウ", "おおさか"))
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
                  "熊本県","大分県","宮崎県","鹿児島県","沖縄県","全国")) #Prefecture(long)
  w <- enc2utf8(c("北海道","青森","岩手","宮城","秋田","山形",
                  "福島","茨城","栃木","群馬","埼玉","千葉",
                  "東京","神奈川","新潟","富山","石川","福井",
                  "山梨","長野","岐阜","静岡","愛知","三重",
                  "滋賀","京都","大阪","兵庫","奈良","和歌山",
                  "鳥取","島根","岡山","広島","山口","徳島",
                  "香川","愛媛","高知","福岡","佐賀","長崎",
                  "熊本","大分","宮崎","鹿児島","沖縄","全国")) #Prefecture(short)

  for(i in 1:length(x)){
    if(!any(str_detect(y, x[i]))) stop("存在しない地域が含まれています") #check;is Japan
    x[i] <- ifelse(any(str_detect(x, y)),
                   z[str_detect(y, x[i])], #Convert romen to japanese (long)
                   w[str_detect(y, x[i])]) #Convert romen to japanese (short)
  }

  return(x)
}

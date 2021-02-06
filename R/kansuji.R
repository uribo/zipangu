#' Convert kansuji character to arabic
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' Converts a given Kansuji element such as Ichi (1) and Nana (7) to an Arabic.
#' [kansuji2arabic_all()] converts only Kansuji in the string.
#' [kansuji2arabic_num()] convert kansuji that contain the positions (e.g. Hyaku,
#' Sen, etc) with the numbers represented by kansuji. [kansuji2arabic_str()]
#' converts kansuji in a string to numbers represented by kansuji while
#' retaining the non-kansuji characters.
#' @param str Input vector.
#' @param convert If `FALSE`, will return as numeric. The default value is `TRUE`,
#' and numeric values are treated as strings.
#' @param .under Number scale to be converted. The default value is infinity.
#' @return a character or numeric.
#' @rdname kansuji
#' @examples
#' kansuji2arabic("\u4e00")
#' kansuji2arabic(c("\u4e00", "\u767e"))
#' kansuji2arabic(c("\u4e00", "\u767e"), convert = FALSE)
#' # Keep Kansuji over 1000.
#' kansuji2arabic(c("\u4e00", "\u767e", "\u5343"), .under = 1000)
#' # Convert all character
#' kansuji2arabic_all("\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341")
#' kansuji2arabic_all("\u516b\u4e01\u76ee")
#' # Convert kansuji that contain the positions with the numbers represented by kansuji.
#' kansuji2arabic_num("\u4e00\u5104\u4e8c\u5343\u4e09\u767e\u56db\u5341\u4e94\u4e07")
#' kansuji2arabic_num("\u4e00\u5104\u4e8c\u4e09\u56db\u4e94\u4e07\u516d\u4e03\u516b\u4e5d")
#' # Converts kansuji in a string to numbers represented by kansuji.
#' kansuji2arabic_str("\u91d1\u4e00\u5104\u4e8c\u5343\u4e09\u767e\u56db\u5341\u4e94\u4e07\u5186")
#' kansuji2arabic_str("\u91d1\u4e00\u5104\u4e8c\u4e09\u56db\u4e94\u4e07\u516d\u4e03\u516b\u4e5d\u5186")
#' kansuji2arabic_str("\u91d11\u51042345\u4e076789\u5186")
#' @export
kansuji2arabic <- function(str, convert = TRUE, .under = Inf) {
  kanjiarabic_key <-
    c(0,
      seq.int(0, 10),
      10^c(seq.int(2, 4), 8, 12, 16)
    ) %>%
    purrr::set_names(
      stringr::str_split(
        paste0(
          "\u96f6",
          "\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341",
          "\u767e\u5343\u4e07",
          "\u5104\u5146\u4eac"),
        pattern = stringr::boundary("character"),
        simplify = TRUE)) %>%
    purrr::keep(
      ~ .x < .under) %>%
    purrr::map(
      ~ as.character(.x)
    )
  res <-
    dplyr::recode(str, !!!kanjiarabic_key)
  if (convert == FALSE)
    res <- res %>% as.numeric()
  res
}

#' @param ... Other arguments to carry over to [kansuji2arabic()]
#' @rdname kansuji
#' @export
kansuji2arabic_all <- function(str, ...) {
  purrr::map_chr(str, function(str, ...){
    stringr::str_split(str,
                       pattern = stringr::boundary("character")) %>%
      purrr::map(kansuji2arabic, ...) %>%
      purrr::reduce(c) %>%
      paste(collapse = "")
  }, ...)
}

kansuji2arabic_num_single <- function(str, consecutive = c("convert", "non"), ...) {
  consecutive <- match.arg(consecutive)

  if(is.na(str) || is.nan(str) || is.infinite(str) || is.null(str)){
    warning("Only strings consisting only of kansuji characters can be converted.")
    return(NA)
  }

  n <- stringr::str_split(str,
                          pattern = stringr::boundary("character"))%>%
    purrr::reduce(c)

  if(any(stringr::str_detect(n, pattern = "[^\u96f6\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u5104\u5146\u4eac]"))){
    warning("Only strings consisting only of kansuji characters can be converted.")
    return(NA)
  }

  n <- n %>% purrr::map(kansuji2arabic) %>% as.numeric()

  if(!any(n >= 10) && length(n) > 1){
    if(consecutive == "convert") return(kansuji2arabic_all(str, ...))
    if(consecutive == "non") return(str)
  }

  if(length(n) > 2 && any(n >= 10000) && all(n != 10) && all(n !=100) && all(n != 1000)){
    for(i in 1:(length(n) - 1)){
      if(n[i] < 1000 && n[i + 1] < 10){
        n[i + 1] <- as.numeric(stringr::str_c(c(n[i], n[i + 1]), collapse = ""))
        n[i] <- NA
      }
    }
    n <- stats::na.omit(n)
  }


  if(!any(n >= 10000)){
    if(length(n) == 1){
      res <- n
    }else{
      res <- NULL
      for(i in 1:length(n)){
        if(i == length(n) && n[i - 1] >= 10)
          res[i] <- n[i]
        else if(length(n[i - 1]) == 0 && n[i] >= 10)
          res[i] <- n[i]
        else if(n[i] <= 9 && n[i + 1] >= 10 )
          res[i] <- n[i] * n[i + 1]
        else if(n[i] >=10 && n[i - 1] >=10)
          res[i] <- n[i]
      }
    }
    res <- sum(stats::na.omit(res))
  }else{
    if(length(n) == 1){
      res <- n
    }else{
      ans <- NULL
      l <- 1
      k <- 1
      digits_location <- which(n >= 10000)
      digits <- sum(n >= 10000)
      digits_number <- n[n >= 10000]
      if(max(which(n >= 10000)) <= max(which(!n >= 10000))){
        digits <- digits + 1
        digits_number <- c(digits_number, 1)
        digits_location <- c(digits_location, (max(which(n >= 0)) + 1))
      }
      for (j in 1:digits) {
        m <- digits_location[k] - 1
        nn <- n[l:m]
        res <- NULL
        for (i in 1:length(nn)) {
          if(length(nn) <= 1)
            res[i] <- nn[i]
          else if(i == length(nn) && nn[i - 1] >= 10)
            res[i] <- nn[i]
          else if(length(nn[i - 1]) == 0 && nn[i] >= 10)
            res[i] <- nn[i]
          else if(nn[i] <= 9 && nn[i + 1] >= 10 )
            res[i] <- nn[i] * nn[i + 1]
          else if(nn[i] >=10 && nn[i - 1] >=10)
            res[i] <- nn[i]
          else if(nn[i] <= 9 && nn[i + 1] <=9){
            warning("This format of kansuji characters cannot be converted.")
            return(NA)
          }
        }
        ans[k] <- sum(stats::na.omit(res)) * digits_number[k]
        l <- digits_location[k] + 1
        k <- k + 1
      }
      res <- sum(stats::na.omit(ans))
    }
  }
  return(as.character(res))
}

#' @rdname kansuji
#' @export
kansuji2arabic_num <- function(str, consecutive = c("convert", "non"), ...){
  consecutive <- match.arg(consecutive)

  purrr::map(str, kansuji2arabic_num_single, consecutive, ...) %>% unlist()
}

kansuji2arabic_str_single <- function(str, consecutive = c("convert", "non"), widths = c("all", "halfwidth"), ...){
  consecutive <- match.arg(consecutive)
  widths <- match.arg(widths)

  if(is.na(str) || is.nan(str) || is.infinite(str) || is.null(str)){
    warning("It is a type that cannot be converted.")
    return(NA)
  }

  if(widths == "all"){
    arabicn_half <- "1234567890"
    arabicn_full <- "\uff11\uff12\uff13\uff14\uff15\uff16\uff17\uff18\uff19\uff10"

    arabicn_half <- unlist(stringr::str_split(arabicn_half, ""))
    arabicn_full <- unlist(stringr::str_split(arabicn_full, ""))

    names(arabicn_half) <- arabicn_full

    str <- stringr::str_replace_all(str, arabicn_half)
  }
  str <- arabic2kansuji::arabic2kansuji(str)


  str_num <- stringr::str_split(str, pattern = "[^\u96f6\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u5104\u5146\u4eac]")[[1]]
  str_num[str_num == ""] <- NA
  str <- stringr::str_replace_all(str, pattern = "[\u96f6\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u5104\u5146\u4eac]",  replacement = "\u3007\u3007")
  doc_cha <- stringr::str_split(str, pattern = "[\u96f6\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u5104\u5146\u4eac]")[[1]]
  str_num <- kansuji2arabic_num(stats::na.omit(str_num), consecutive)

  j <- 1
  for(i in 1:length(doc_cha)){
    if(!stringr::str_detect(doc_cha[i], pattern = "") && i == 1){
      doc_cha[i] <- str_num[j]
      j <- j + 1
    }
    else if(consecutive == "non"){
      if((stringr::str_detect(doc_cha[i - 1], pattern = "[^0123456789]")
          && stringr::str_detect(doc_cha[i - 1], pattern = "[^\u96f6\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d]"))
         && !stringr::str_detect(doc_cha[i], pattern = "")){
        doc_cha[i] <- str_num[j]
        j <- j + 1
      }
    }
    else if(stringr::str_detect(doc_cha[i - 1], pattern = "[^0123456789]")
            && !stringr::str_detect(doc_cha[i], pattern = "")){
      doc_cha[i] <- str_num[j]
      j <- j + 1
    }
    if((length(str_num) + 1)  ==  j) break
  }
  ans <- stringr::str_c(doc_cha, collapse = "")
  return(ans)
}

#' @param consecutive If you select "convert", any sequence of 1 to 9 kansuji will
#'  be replaced with Arabic numerals. If you select "non", any sequence of 1-9
#'  kansuji will not be replaced by Arabic numerals.
#' @param widths If you select "all", both full-width and half-width Arabic numerals
#'  are taken into account when calculating kansuji, but if you select "halfwidth",
#'  only half-width Arabic numerals are taken into account when calculating kansuji.
#' @rdname kansuji
#' @export
kansuji2arabic_str <- function(str, consecutive = c("convert", "non"), widths = c("all", "halfwidth"),...){
  consecutive <- match.arg(consecutive)
  widths <- match.arg(widths)

  purrr::map(str, kansuji2arabic_str_single, consecutive, widths, ...) %>% unlist()
}

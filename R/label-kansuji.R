#' Label numbers in Kansuji format
#'
#' @description
#' Automatically scales and labels with the Kansuji Myriad Scale (e.g. "Man",
#' "Oku", etc).
#' Use [label_kansuji()] converts the label value to either Kansuji value or a
#' mixture of Arabic numerals and the Kansuji Scales for ten thousands,
#' billions, and ten quadrillions.
#' Use [label_kansuji_suffix()] converts the label value to an Arabic numeral
#' followed by the Kansuji Scale with the suffix.
#'
#' @param unit Optional units specifier.
#' @param sep Separator between number and Kansuji unit.
#' @param prefix Symbols to display before value.
#' @param big.mark Character used between every 3 digits to separate thousands.
#' @param number If Number is arabic, it will return a mixture of Arabic and the
#'  Kansuji Myriad Scale; if Kansuji, it will return only Kansuji numerals.
#' @param ... Other arguments passed on to [base::prettyNum()], [scales::label_number()] or
#'  [arabic2kansuji::arabic2kansuji_all()].
#' @rdname label_kansuji
#'
#' @return All `label_()` functions return a "labelling" function, i.e. a function
#'  that takes a vector x and returns a character vector of length(x) giving a
#'  label for each input value.
#'
#' @section Examples:
#' ```{r, child = "man/rmd/setup.Rmd"}
#' ```
#'
#' ```{r, eval = FALSE, echo = TRUE}
#' library("scales")
#' demo_continuous(c(1, 1e9), label = label_kansuji())
#' demo_continuous(c(1, 1e9), label = label_kansuji_suffix())
#' ```
#' @export
label_kansuji <- function(unit = NULL, sep = "", prefix = "", big.mark = "", number = c("arabic", "kansuji"), ...){
  number <- match.arg(number)
  if(number == "arabic"){
    function(x){
      purrr::map_chr(x, function(x){
        x <- prettyNum(x, scientific = FALSE) %>% arabic2kansuji::arabic2kansuji_all()
        x.kansuji <- stringr::str_split(x, pattern = "[^\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343]")[[1]]
        x.kansuji[x.kansuji == ""] <- NA
        x.kansuji <- stats::na.omit(x.kansuji)
        for(i in 1:length(x.kansuji)){
          if(is.na(x.kansuji[i])) break
          x <- stringr::str_replace(x, pattern = x.kansuji[i], replacement = prettyNum(zipangu::kansuji2arabic_num(x.kansuji[i]), big.mark = big.mark, ...))
        }
        paste0(prefix, x, unit, sep = sep)
      }
      )
    }
  }else if(number == "kansuji"){
    function(x){
      x <- prettyNum(x, scientific = FALSE) %>% arabic2kansuji::arabic2kansuji_all(...)
      paste0(prefix, x, unit, sep = sep)
    }
  }
}

#' @param accuracy A number to round to. Use (e.g.) 0.01 to show 2 decimal
#' places of precision.
#' @param significant.digits Determines whether or not the value of accurary is
#' valid as a significant figure with a decimal point. The default is FALSE, in
#' which case if accurary is 2 and the value is 1.10, 1.1 will be displayed,
#' but if TRUE and installed `{scales}` package, 1.10 will be displayed.
#' @rdname label_kansuji
#' @export
label_kansuji_suffix <- function(accuracy = 1, unit = NULL, sep = NULL, prefix = "", big.mark = "", significant.digits = FALSE, ...) {
  function(x) {

    breaks <- c(0, MAN = 10000, OKU = 1e+08, CHO = 1e+12, KEI = 1e+16)

    n_suffix <- cut(abs(x),
                    breaks = c(0, 10000, 1e+08, 1e+12, 1e+16, Inf),
                    labels = c("", "\u4e07", "\u5104", "\u5146", "\u4eac"),
                    right = FALSE)
    n_suffix[is.na(n_suffix)] <- ""
    suffix <- paste0(sep, n_suffix, unit)

    n_suffix <- cut(abs(x),
                    breaks = c(unname(breaks), Inf),
                    labels = c(names(breaks)),
                    right = FALSE)
    n_suffix[is.na(n_suffix)] <- ""
    scale <- 1 / breaks[n_suffix]
    scale[which(scale %in% c(Inf, NA))] <- 1

    if(significant.digits){
      if(requireNamespace("scales", quietly = TRUE))
        scales::number(x,
                       accuracy = accuracy,
                       scale = unname(scale),
                       suffix = suffix,
                       big.mark = big.mark,
                       ...)
      else{
        warning("`scales` package needs to be installed.", call. = FALSE)
        paste0(prefix, prettyNum(round(x * scale, digits = nchar(1 / (accuracy * 10))), big.mark = big.mark, ...), suffix, sep = sep)
      }
    }else{
      paste0(prefix, prettyNum(round(x * scale, digits = nchar(1 / (accuracy * 10))), big.mark = big.mark, ...), suffix, sep = sep)
    }
  }
}

#' Create kana vector
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' Generates a vector consisting of the elements of kana.
#' Options exist for the inclusion of several elements.
#' @param type "hiragana" ("hira") or "katakana" ("kata")
#' @param ... Arguments passed on to [hiragana]
#' @rdname kana
#' @examples
#' kana(type = "hira", core = TRUE)
#' kana(type = "hira", core = TRUE, handakuon = TRUE)
#' @export
kana <- function(type, ...) {
  type <- rlang::arg_match(type,
                           c("hira", "hiragana",
                             "kata", "katakana"))
  switch (type,
    "hira" = hiragana(...),
    "hiragana" = hiragana(...),
    "kata" = katakana(...),
    "katakana" = katakana(...)
  )
}

#' @param core is include core kana characters.
#' @param dakuon e.g. ga, gi, gu, ge, go
#' @param handakuon e.g. pa, pi, pu, pe, po
#' @param kogaki small character
#' @param historical old style
#' @rdname kana
#' @export
hiragana <- function(core = TRUE, dakuon = FALSE, handakuon = FALSE, kogaki = FALSE, historical = FALSE) {
  x <-
    seq.int(12353, 12438)
  if (core == TRUE) {
    x_at <-
      c(seq.int(2, 10, by = 2),
        seq.int(11, 30, by = 2),
        c(31, 33, 36, 38, 40),
        seq.int(42, 46),
        seq.int(47, 59, by = 3),
        seq.int(62, 66),
        seq.int(68, 72, by = 2),
        seq.int(73, 77),
        c(79, 82, 83))
  } else {
    x_at <-
      NULL
  }
  if (historical == TRUE) {
    x_at <-
      c(x_at, 80, 81)
  }
  if (dakuon == TRUE) {
    x_at <-
      c(x_at,
        c(seq.int(12, 30, by = 2),
          c(c(32, 34),
            seq.int(37, 41, by = 2)),
          seq.int(48, 60, by = 3),
          84))
  }
  if (handakuon == TRUE) {
    x_at <-
      c(x_at,
        seq.int(49, 61, by = 3))
  }
  if (kogaki == TRUE) {
    x_at <-
      c(x_at,
        seq.int(1, 10, by = 2),
        35,
        seq.int(67, 71, by = 2),
        c(78, 85, 86))
  }
  if (is.null(x_at)) {
    rlang::warn(
      "There is no matching character. Please specify TRUE for either arguments."
    )
  }
  purrr::map_chr(x[sort(x_at)],
                 intToUtf8)
}

#' @export
#' @rdname kana
katakana <- function(core = TRUE, dakuon = FALSE, handakuon = FALSE, kogaki = FALSE, historical = FALSE) {
  x <-
    hiragana(core = core, dakuon = dakuon, handakuon = handakuon, kogaki = kogaki, historical = historical) %>%
    stringi::stri_trans_general(id = "kana")
  if (kogaki == TRUE) {
    x <-
      x[seq.int(1, length(x)-2)]
  }
  x
}

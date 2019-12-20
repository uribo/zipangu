#' Read Japan post's zip-code file
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' @details
#' Reads zip-code data in csv format provided by japan post group and parse it as a data.frame.
#' Corresponds to the available "oogaki", "kogaki", "roman" and "jigyosyo" types.
#' These file types must be specified by the argument.
#' @param path local file path or zip file URL
#' @param type Input file type, one of "oogaki", "kogaki", "roman", "jigyosyo"
#' @return [tibble][tibble::tibble]
#' @seealso [https://www.post.japanpost.jp/zipcode/dl/readme.html](https://www.post.japanpost.jp/zipcode/dl/readme.html),
#' [https://www.post.japanpost.jp/zipcode/dl/jigyosyo/readme.html](https://www.post.japanpost.jp/zipcode/dl/jigyosyo/readme.html)
#' @examples
#' # Input sources
#' read_zipcode(path = system.file("zipcode_dummy/13TOKYO_oogaki.CSV", package = "zipangu"),
#'              type = "oogaki")
#' read_zipcode(system.file("zipcode_dummy/13TOKYO_kogaki.CSV", package = "zipangu"),
#'              "oogaki")
#' read_zipcode(system.file("zipcode_dummy/KEN_ALL_ROME.CSV", package = "zipangu"),
#'              "roman")
#' read_zipcode(system.file("zipcode_dummy/JIGYOSYO.CSV", package = "zipangu"),
#'              "jigyosyo")
#' \dontrun{
#' # Or directly from a URL
#' read_zipcode("https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip")
#' }
#' @rdname read_zipcode
#' @export
read_zipcode <- function(path, type = c("oogaki", "kogaki", "roman", "jigyosyo")) {
  # nocov start
  if (is_japanpost_zippath(path)) {
    dl <- dl_zipcode_file(path)
    path <- dl[[1]]
    type <- dl[[2]]
  }
  # nocov end
  rlang::arg_match(type)
  read_csv_jp <-
    purrr::partial(utils::read.csv,
                   fileEncoding = "cp932",
                   stringsAsFactors = FALSE)
  address_level <- c("prefecture", "city", "street")
  col_vars <-
    list(yomi = c("jis_code", "old_zip_code", "zip_code",
                  paste0(address_level, "_kana"),
                  address_level,
                  "is_street_duplicate",
                  "is_banchi",
                  "is_cyoumoku",
                  "is_zipcode_duplicate",
                  "status",
                  "modify_type"
    ),
    roman = c("zip_code",
              address_level,
              paste0(address_level, "_roman")),
    jigyosyo = c("jis_code", "name_kana", "name",
                 address_level,
                 "street_sub",
                 "jigyosyo_identifier",
                 "old_zip_code",
                 "grouped",
                 "individual_id",
                 "multiple_type",
                 "update_type"))
  if (type == "oogaki") {
    df <-
      read_csv_jp(file = path,
                  col.names = col_vars$yomi,
                  colClasses = c(rep("character", 9),
                                     rep("double", 3),
                                     rep("double", 3)))
  } else if (type == "kogaki") {
    df <-
      dplyr::mutate_at(read_csv_jp(file = path,
                                   col.names = col_vars$yomi,
                                   colClasses = c(rep("character", 9),
                                                  rep("double", 3),
                                                  rep("double", 3))),
                       stringr::str_subset(col_vars$roman, "^is_"),
                                   as.logical)
  } else if (type == "roman") {
    df <-
      dplyr::mutate_at(read_csv_jp(file = path,
                                  col.names = col_vars$roman,
                                  colClasses = rep("character", 7)),
                       stringr::str_subset(col_vars$roman, "roman$"),
                       stringr::str_to_title)
  } else if (type == "jigyosyo") {
    df <-
      read_csv_jp(file = path,
                  col.names = col_vars$jigyosyo,
                  colClasses = c(rep("character", 10),
                                 rep("integer", 3)))
  }
  tibble::as_tibble(
    dplyr::mutate_if(
      dplyr::mutate_if(df,
                       is.character,
                       stringi::stri_trans_general,
                       id = "nfkc"),
      is.character,
      stringr::str_trim)
  )
}

#' Test zip-code
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#' @param x Zip-code. Number or character. Hyphens may be included,
#' but the input must contain a 7-character number.
#' @rdname is_zipcode
#' @examples
#' is_zipcode(7000027)
#' is_zipcode("700-0027")
#' @return A logical vector.
#' @export
is_zipcode <- function(x) {
  checked <- stringr::str_detect(x,
                                 "^[0-9]{3}-?[0-9]{4}$")
  if (rlang::is_false(checked))
    rlang::inform("7\u6841\u306e\u6570\u5024\u3067\u306f\u3042\u308a\u307e\u305b\u3093")
  checked
}

#' Insert and remove zip-code connect character
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}
#' Inserts a hyphen as a delimiter in the given zip-code string.
#' Or exclude the hyphen.
#' @inheritParams is_zipcode
#' @param remove Default is `FALSE`. If `TRUE`, remove the hyphen.
#' @rdname zipcode_spacer
#' @examples
#' zipcode_spacer(7000027)
#' zipcode_spacer("305-0053")
#' zipcode_spacer("305-0053", remove = TRUE)
#' @export
zipcode_spacer <- function(x, remove = FALSE) {
  purrr::map_chr(x,
                 ~ if (rlang::is_true(is_zipcode(.x)))
                   if (rlang::is_false(remove)) {
                     if (stringr::str_detect(.x,
                                             "-",
                                             negate = FALSE)) {
                       .x
                     } else {
                       paste0(stringr::str_sub(.x, 1, 3),
                              "-",
                              stringr::str_sub(.x, 4, 7))
                     }
                   } else {
                     stringr::str_remove_all(.x, "-")
                   }
                 else
                   NA_character_)
}

#' Check if it is a zip file provided by japanpost
#' @param url character.
#' @return A logical vector.
is_japanpost_zippath <- function(url) {
  stringr::str_detect(url,
                      "https://www.post.japanpost.jp/zipcode/dl/.+/.+.zip")
}

#' Download a zip-code file
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}
#' @inheritParams read_zipcode
#' @param exdir The directory to extract zip file. If `NULL`, use temporary folder.
#' @rdname dl_zipcode_file
#' @examples
#' \dontrun{
#' dl_zipcode_file(path = "https://www.post.japanpost.jp/zipcode/dl/oogaki/zip/02aomori.zip")
#' dl_zipcode_file("https://www.post.japanpost.jp/zipcode/dl/oogaki/zip/02aomori.zip",
#'                 exdir = getwd())
#' }
#' @export
dl_zipcode_file <- function(path, exdir = NULL) {
  # nocov start
  if (rlang::is_true(is_japanpost_zippath(path))) {
    if (is.null(exdir))
      exdir <- tempdir()
    type <-
      stringr::str_extract(path, "oogaki|kogaki|roman|jigyosyo")
    unzip_path <-
      stringr::str_to_upper(stringr::str_replace(basename(path),
                                                 "zip",
                                                 "CSV")) %>%
      stringr::str_remove("\\?.+")
    dl_file_path <-
      list.files(exdir,
                 pattern = unzip_path,
                 full.names = TRUE)
    if (sum(file.exists(dl_file_path)) == 0) {
      tmp_zip <-
        tempfile(fileext = ".zip")
      utils::download.file(url = path,
                           destfile = tmp_zip)
      utils::unzip(zipfile = tmp_zip,
                   exdir = exdir)
      path <-
        list.files(exdir,
                   pattern = ".CSV",
                   full.names = TRUE)
    } else {
      path <- dl_file_path
    }
    list(path, type)
  } else {
    rlang::abort("zip file URL not found.")
  }
  # nocov end
}

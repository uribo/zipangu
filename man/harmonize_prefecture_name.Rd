% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prefecture.R
\name{harmonize_prefecture_name}
\alias{harmonize_prefecture_name}
\title{Harmonize the notation of Japanese prefecture names.}
\usage{
harmonize_prefecture_name(x, to)
}
\arguments{
\item{x}{Input vector.}

\item{to}{Option. Whether to use longer ("long") or shorter ("short")
prefectures.}
}
\description{
\Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
}
\details{
Convert with and without terminal notation, respectively.
\itemize{
\item long option, long formal name
\item Use the short option to omit the trailing characters
}
}
\examples{
x <- c("\u6771\u4eac\u90fd", "\u5317\u6d77\u9053", "\u6c96\u7e04\u770c")
harmonize_prefecture_name(x, to = "short")
x <- c("\u6771\u4eac", "\u5317\u6d77\u9053", "\u6c96\u7e04")
harmonize_prefecture_name(x, to = "long")
}

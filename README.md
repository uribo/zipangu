
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zipangu <img src="man/figures/logo.png" align="right" width="120px" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/zipangu)](https://cran.r-project.org/package=zipangu)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/zipangu?color=FF5254)](https://cran.r-project.org/package=zipangu)
[![minimal R
version](https://img.shields.io/badge/R%3E%3D-3.2.0-blue.svg)](https://cran.r-project.org/)

[![Travis build
status](https://travis-ci.org/uribo/zipangu.svg?branch=master)](https://travis-ci.org/uribo/zipangu)
[![R build
status](https://github.com/uribo/zipangu/workflows/R-CMD-check/badge.svg)](https://github.com/uribo/zipangu)
[![Codecov test
coverage](https://codecov.io/gh/uribo/zipangu/branch/master/graph/badge.svg)](https://codecov.io/gh/uribo/zipangu?branch=master)
<!-- badges: end -->

The goal of `{zipangu}` is to replace the functionality provided by the
`{Nippon}` archived from CRAN. Add some functions to make it easier to
treat data that address, year, and Kanji.

## Installation

You can install the released version of `{zipangu}` from CRAN with:

``` r
install.packages("zipangu")
```

and also, the developmment version from GitHub

``` r
install.packages("remotes")
remotes::install_github("uribo/zipangu")
```

## API

``` r
library(zipangu)
```

### Address

``` r
separate_address("東京都千代田区大手町一丁目")
#> $prefecture
#> [1] "東京都"
#> 
#> $city
#> [1] "千代田区"
#> 
#> $street
#> [1] "大手町一丁目"
```

### Zip-code

``` r
read_zipcode(system.file("zipcode_dummy/13TOKYO_oogaki.CSV", package = "zipangu"), "oogaki")
#> # A tibble: 1 x 15
#>   jis_code old_zip_code zip_code prefecture_kana city_kana street_kana
#>   <chr>    <chr>        <chr>    <chr>           <chr>     <chr>      
#> 1 13101    100          1000001  トウキヨウト    チヨダク  チヨダ     
#> # … with 9 more variables: prefecture <chr>, city <chr>, street <chr>,
#> #   is_street_duplicate <dbl>, is_banchi <dbl>, is_cyoumoku <dbl>,
#> #   is_zipcode_duplicate <dbl>, status <dbl>, modify_type <dbl>
```

You can also load a file directly by specifying a
URL.

``` r
read_zipcode("https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip")
```

Utilities

``` r
is_zipcode(7000027)
#> [1] TRUE
is_zipcode("700-0027")
#> [1] TRUE
zipcode_spacer("305-0053")
#> [1] "305-0053"
zipcode_spacer("305-0053", remove = TRUE)
#> [1] "3050053"
```

### Calendar

#### Year (Japanese imperial year)

``` r
convert_jyear("R1")
#> [1] 2019
```

#### Public holidays in Japan

Given a year and holiday name as input, returns the date.

``` r
jholiday_spec(2020, "New Year's Day", lang = "en")
#> [1] "2020-01-01"
```

Holiday names can be specified in English (“en”) and Japanese (“jp”) by
default, en is used.

``` r
jholiday_spec(2020, "Coming of Age Day", lang = "en")
#> [1] "2020-01-13"
jholiday_spec(2020, "\u6210\u4eba\u306e\u65e5", lang = "jp")
#> [1] "2020-01-13"
```

Check the list of holidays for a year with the `jholiday()`.

``` r
jholiday(2020, lang = "jp")
#> $元日
#> [1] "2020-01-01"
#> 
#> $成人の日
#> [1] "2020-01-13"
#> 
#> $建国記念の日
#> [1] "2020-02-11"
#> 
#> $天皇誕生日
#> [1] "2020-02-23"
#> 
#> $春分の日
#> [1] "2020-03-20"
#> 
#> $昭和の日
#> [1] "2020-04-29"
#> 
#> $憲法記念日
#> [1] "2020-05-03"
#> 
#> $みどりの日
#> [1] "2020-05-04"
#> 
#> $こどもの日
#> [1] "2020-05-05"
#> 
#> $海の日
#> [1] "2020-07-23"
#> 
#> $スポーツの日
#> [1] "2020-07-24"
#> 
#> $山の日
#> [1] "2020-08-10"
#> 
#> $敬老の日
#> [1] "2020-09-21"
#> 
#> $秋分の日
#> [1] "2020-09-22"
#> 
#> $文化の日
#> [1] "2020-11-03"
#> 
#> $勤労感謝の日
#> [1] "2020-11-23"
```

Use `is_jholiday()` function to evaluate whether today is a holiday.

``` r
is_jholiday("2020-01-10")
#> [1] FALSE
is_jholiday("2020-02-23")
#> [1] TRUE
```

### Convert

#### Hiragana to Katakana and more…

``` r
str_jconv("アイウエオ", 
          str_conv_hirakana, to = "hiragana")
#> [1] "あいうえお"
str_conv_zenhan("ｶﾞｯ", "zenkaku")
#> [1] "ガッ"
str_conv_romanhira("aiueo", "hiragana")
#> [1] "あいうえお"
```

#### Kansuji

``` r
kansuji2arabic(c("一", "百"))
#> [1] "1"   "100"
kansuji2arabic_all("北海道札幌市中央区北一条西二丁目")
#> [1] "北海道札幌市中央区北1条西2丁目"
```

### Data set

``` r
jpnprefs
#> # A tibble: 47 x 5
#>    jis_code prefecture_kanji prefecture    region   major_island
#>    <chr>    <chr>            <chr>         <chr>    <chr>       
#>  1 01       北海道           Hokkaido      Hokkaido Hokkaido    
#>  2 02       青森県           Aomori-ken    Tohoku   Honshu      
#>  3 03       岩手県           Iwate-ken     Tohoku   Honshu      
#>  4 04       宮城県           Miyagi-ken    Tohoku   Honshu      
#>  5 05       秋田県           Akita-ken     Tohoku   Honshu      
#>  6 06       山形県           Yamagata-ken  Tohoku   Honshu      
#>  7 07       福島県           Fukushima-ken Tohoku   Honshu      
#>  8 08       茨城県           Ibaraki-ken   Kanto    Honshu      
#>  9 09       栃木県           Tochigi-ken   Kanto    Honshu      
#> 10 10       群馬県           Gunma-ken     Kanto    Honshu      
#> # … with 37 more rows
```

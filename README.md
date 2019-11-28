
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zipangu

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

You can install the released version of `{zipangu}` from GitHub with:

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

### Year (Japanese imperial year)

``` r
convert_jyear("R1")
#> [1] 2019
```

### Kansuji

``` r
kansuji2arabic(c("一", "百"))
#> [1] "1"   "100"

kansuji2arabic_all("北海道札幌市中央区北一条西二丁目")
#> [1] "北海道札幌市中央区北1条西2丁目"
```

### Dataset

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

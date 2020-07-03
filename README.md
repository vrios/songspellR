
<!-- README.md is generated from README.Rmd. Please edit that file -->

# songspellR

<!-- badges: start -->

<!-- badges: end -->

The goal of songspellR is to automate several tasks in bioacoustic
analyses, specially syllable detection and classification, using a
simplified and straightforward interface

## Installation

(not yet on cran) You can install the released version of songspellR
from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("songspellR")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("vrios/songspellR")
```

## Example

This is a basic example which shows you how to detect syllables and
split a recording autommatically:

``` r
#library(songspellR)
## basic example code
#songs = findSyllables(plotSyllables  = T,dir(here::here("inst/extdata"), full.names = TRUE,include.dirs = T), samplingRate = 44100)
#syls = waveCutter(songs, write.specs = F)
```

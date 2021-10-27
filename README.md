
<!-- README.md is generated from README.Rmd. Please edit that file -->

# songspellR
songspelleR development has been put on indefinite hiatus. R packages [soundgen](http://cogsci.se/soundgen.html) and [warbler](https://marce10.github.io/warbleR/) cover all of the intended functionality, and thus should be used instead
<!-- badges: start -->
[![DOI](https://zenodo.org/badge/276634269.svg)](https://zenodo.org/badge/latestdoi/276634269)

<!-- badges: end -->

The goal of songspellR is to automate several tasks in bioacoustic
analyses, specially syllable detection and classification, using a
simplified and straightforward interface

Note that songspellR is still very much in beta stage, and may suffer
major changes in funcionality and interface. It should not be used in
serious applications yet

## Installation

(not yet on cran) You can install the released version of songspellR
when it becomes available from [CRAN](https://CRAN.R-project.org) with:

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

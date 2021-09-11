#'Find "syllables" (discrete acoustic events) in animal sounds

#'
#' @param files A vector of wave files
#' @param low lower frequency for filter
#' @param high lower frequency for filter
#' @param plotSyllables logical, should the spectrogram with the syllables be plotted?
#' @param samplingRate Sampling rate
#' @param shortestPause Smallest separation between syllables
#' @param shortestSyl Shortest event that cam be considered a syllables
#' @param plot should plot syllables according to soundgen?
#' @param sylThres percentage of mean amplitude envelope for audio event. Syllables are only detected when above this threshold
#' @param windowLength window size for audio events
#' @param overlap overlap between windows
#'
#' @return Dataframe with following collumns:
#' "sound.files" : original file from wich syllables were extracted,
#' "selec" : syllable id, unique inside the sound.file, but not between files,
#' "start" : syllable start,
#' "end" : syllable end
#'
#' @examples
#' \dontrun{
#' songs = findSyllables(plotSyllables  = F,dir(here::here("inst/extdata"),
#'  full.names = TRUE,include.dirs = T), samplingRate = 44100)
#'  }

#'

#' @importFrom magrittr %>%
#' @importFrom  stats setNames
#' @importFrom dplyr bind_rows
#' @importFrom stats rnorm
#' @import "tuneR"
#' @import "soundgen"
#' @import "seewave"
#' @import "purrr"
#' @import "grDevices"
#' @import "graphics"
#' @export

findSyllables <- function(files, low =1000, high =22000, plotSyllables =FALSE,samplingRate =NULL, shortestPause =25, shortestSyl =10, plot =FALSE, sylThres =.50, windowLength =20, overlap = 80) {

  if (is.null(samplingRate)) {
    stop("SamplingRate must be supplied")
  }
  if( !is.character(files) && class(files) != "Wave" && !is.list(files)){
    stop("files must be : a filename, a liste of filenames, a Wave object or a list of Wave objects")
  }

  if(is.character(files) || is.character(files[[1]])){
    dirs <- unique(dirname(files))
    if (length(dirs) > 1) {
      stop("All files must be on the same directory")
    }
    files <- purrr::map(files, tuneR::readWave)

    }
  dur <- purrr::map(files, seewave::duration)

  filtered <- purrr::map(
    files,
    seewave::ffilter,
    from =
      low, to =
      high, output = "Wave"
  )

  # spectro(filtered[[1]],scale=F)
  # dur2=purrr::map(filtered,seewave::duration)
  syls <- purrr::map(filtered, "left") %>%
    setNames(files) %>%
    purrr::map(
      .,
      soundgen::segment,
      samplingRate = samplingRate,
      shortestPause =shortestPause,
      shortestSyl =shortestSyl,
      plot =plot,
      sylThres =        sylThres,
      windowLength =        windowLength,
      overlap = overlap
    ) %>%
    purrr::map(., "syllables") %>%
    purrr::map(., `[`, c("syllable", "start", "end"))


  syls <- dplyr::bind_rows(syls, .id = "column_label") %>%
    stats::setNames(., c("sound.files", "selec", "start", "end"))
  syls$start <- syls$start / 1000
  syls$end <- syls$end / 1000

  ## plot spectrograms with syllables
  if (plotSyllables == T) {
    songspellR::plotSyllables(syls)
    # u <- 1
    # uniq <- unique(syls$sound.files)
    # for (u in seq_along(uniq)) {
    #   XU <- syls[syls$sound.files == uniq[u], ]
    #   file <- XU$sound.files[1]
    #   wav <- tuneR::readWave(file)
    #   # x11()
    #   originalFileName <-
    #     tools::file_path_sans_ext(basename(uniq[u]))
    #   newSpecFileName <- paste0(originalFileName, ".tiff")
    #   tiff(
    #     filename = newSpecFileName,
    #     width = 1080,
    #     height =
    #       720,
    #     compression = "lzw"
    #   )
    #   seewave::spectro(
    #     wav,
    #     scale = F,
    #     flim =
    #       c(0, 22),
    #     collevels = seq(-50, 0, 1)
    #   )
    #   ys <-
    #     ((low / 1000) + 1) + stats::rnorm(length(XU$start), 0, 0.3)
    #   text(
    #     x = XU$start,
    #     y = ys + 0.2,
    #     labels = XU$selec,
    #     col = "black"
    #   )
    #   segments(
    #     x0 = XU$start,
    #     x1 = XU$end,
    #     y0 = ys,
    #     col = "red",
    #     lwd = 2
    #   )
    #   dev.off()
    # }
  }
  return(syls)
}
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))

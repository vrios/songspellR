#' waveCutter
#'
#' Takes a dataframe with event starts and ends (see output from findSyllables), and produces .wav files for each of these selections, along with a corresponding spectrogram
#'
#'
#' @param X Vector of filenames
#' @param padding Time to be added before and after each selection, is seconds or milliseconds
#' @param units time unit for padding, either "seconds" (default) or "ms"
#' @param low  in Hz, lower frequency limit for filter, optional
#' @param high in Hz, higher frequency limit for filter, optional
#' @param write.wavs logical, should the wav files for each selection be saved?
#' @param write.specs logical, should the spectrograms files for each selection be saved?
#'
#' @return Returns a dataframe with six columns: X = original filenames, "waves" = .wav filenames, "spectrograms" = spectrogram filenames
#' @importFrom magrittr %>%
#' @import "purrr"
#' @import "soundgen"
#' @import "seewave"
#' @export

waveCutter <- function(X # file vector
                       , padding = .03 #time to be added before and after selection
                       , units = "seconds"
                       , low =1000, high =22000
                       , write.wavs = TRUE
                       , write.specs = FALSE
                       ) {
  if (units != "ms" & units != "seconds") {
    stop("Time units for padding must be in \"seconds\" or miliseconds (\"ms\")
         , default is seconds")
  }
  if (units == "ms") {
    X$start <- (X$start - padding) / 1000
    X$end <- (X$end + padding) / 1000
  }

  if (units == "seconds") {
    X$start <- (X$start - padding)
    X$end <- (X$end + padding)
  }
  wavfilenames <- c()
  specfilenames <- c()
  waves <-c()


  ### find sylables in files

  uniq <- unique(X$sound.files)
  for (u in seq_along(uniq)) {
    XU <- X[X$sound.files == uniq[u],]
    file <- XU$sound.files[1]
    originalFileName <- tools::file_path_sans_ext(basename(as.character(file)))

    wav <- tuneR::readWave(filename = file)
    wav.filter <- seewave::ffilter(wav, from = low, to = high, output = "Wave")

    originalDir <- dirname(X$sound.files[1])
    sylDir <- file.path(originalDir, "syllables")
    specDir <- file.path(originalDir, "spectrograms")


    if (!dir.exists(sylDir) & write.wavs == T) {
      dir.create(sylDir)
    }
    if (!dir.exists(specDir) & write.specs == T) {
      dir.create(specDir)
    }

    for (i in seq_along(XU$selec)) {

      # control for start and end of file
      XU$start[i] <- ifelse(XU$start[i] < 0, 0, XU$start[i])
      XU$end[i] <- ifelse(XU$end[i] > seewave::duration(wav),
                          seewave::duration(wav), XU$end[i])
      start <- XU$start[i]
      end <- XU$end[i]
      syl <- XU$selec[i]

      ### find sections in wave
      wavcut <- seewave::cutw(wav.filter,
        from = start,
        to = end, output = "wave"
      )
      wavcut <- tuneR::normalize(wavcut, unit = as.character(wav@bit))
      sylName <- paste0(originalFileName, "-syl", syl, "-"
                        , round(start, digits = 3), "s")
      newWavName <- file.path(sylDir, paste0(sylName, ".wav"))
      newSpecFileName <- file.path(specDir, paste0(sylName, ".jpg"))

      specfilenames <- rbind(specfilenames, newSpecFileName)
      wavfilenames <- rbind(wavfilenames, newWavName)
      waves <- rbind(waves,wavcut@left)

      if (write.wavs == T) {
        tuneR::writeWave(object = wavcut, filename = newWavName)
      }
      if (write.specs == T) {
        jpeg(filename = newSpecFileName)
        seewave::spectro(wavcut,
          scale = F, main = sylName
          # ,collevels = seq(-90, 0, 1), palette = viridis
        )
        dev.off()
      }
    }
    XU -> X[X$sound.files == uniq[u],]
  }
  return(cbind(X, "wave.files" = wavfilenames, "spectrograms" = specfilenames,waves=waves))
}

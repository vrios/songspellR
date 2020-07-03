#' plotSyllables
#'
#' plot spectrograms with syllables identified by findSyllables()
#'
#' @param syls songs
#' @param low lowest frequency to plot
#' @param high highest frequency to plot
#' @param labels cluster labels
#'
#' @return returns nothing
#' @export
#'

plotSyllables <- function(syls,low =1000, high =22000, labels = F) {
  u <- 1
  uniq <- unique(syls$sound.files)
  for (u in seq_along(uniq)) {
    XU <- syls[syls == uniq[u],]
    file <- XU[1,1]
    wav <- tuneR::readWave(file)
    originalFileName <-
      tools::file_path_sans_ext(basename(uniq[u]))
    newSpecFileName <- paste0(originalFileName, ".tiff")
    tiff(
      filename = newSpecFileName,
      width = 1080,
      height =
        720,
      compression = "lzw"
    )
   # if (labels==F){labels = XU$selec}
    seewave::spectro(
      wav,
      scale = F,
      flim = c(0, 22),
      collevels = seq(-50, 0, 1)
    )
    ys <-
      ((low / 1000) + 1) + stats::rnorm(length(XU$start), 0, 0.3)
    text(
      x = XU$start,
      y = ys + 0.2,
      labels = labels,
      col = "black",cex = 2
    )
    segments(
      x0 = XU$start,
      x1 = XU$end,
      y0 = ys,
      col = "red",
      lwd = 2
    )
    dev.off()
  }
}

### from http://dtw.r-forge.r-project.org/
#' DTW Omit NA
#'
#' @param x first time sequence to compare
#' @param y second time sequence to compare
#'
#' @return returns the dinamic time warp distance between the two series
#' @export
#' @import "dtw"
#' @importFrom stats na.omit

dtwOmitNA <- function(x, y) {
  a <- stats::na.omit(x)
  b <- stats::na.omit(y)
  return(dtw::dtw(a, b, distance.only = TRUE, open.end = TRUE)$normalizedDistance)
}

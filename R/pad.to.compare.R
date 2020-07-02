#' pad.to.compare
#'
#' @param z object to pad
#'
#' @return returns padded audios
#' @export
#'

pad.to.compare <- function(z) {
  max.z <- max(lengths(z))
  pad <- function(x) {
    if (length(x) < max.z) {
      x <- matrix(c(x, rep(NA, max.z - length(x))))
    }
    return(x)
  }
  zz <- lapply(z, pad)
  mm=matrix(unlist(zz), ncol = max.z, byrow = TRUE)
  return(mm)
}

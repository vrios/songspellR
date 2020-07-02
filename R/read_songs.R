#' read_songs
#'
#' @param files to read
#'
#' @return returns read files
#' @export
#'

read_songs <- function(files) {
  purrr::map(files, tuneR::readWave)

}

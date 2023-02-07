#' Title
#'
#' @param .data data
#' @param .tavg tavg
#' @param .lat lat
#'
#' @return a data frame
#' @importFrom SPEI thornthwaite
#' @export
#'
#' @examples
#' # tobefilled
thornthwaite <- function(.data, .tavg, .lat){

  .lat <- unique(.lat)
  SPEI::thornthwaite(Tave = .tavg, lat = .lat)

}

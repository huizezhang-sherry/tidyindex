#' Rescaling functions
#'
#' @param var variable
#' @param na.rm logical; whether to remove NAs
#'
#' @return a vector of rescaled variable
#' @export
#' @rdname rescale
rsc_zscore <- function(var, na.rm = TRUE){
 (var - mean(var, na.rm = na.rm))/ sd(var, na.rm = na.rm)
}

#' @export
#' @rdname rescale
rsc_minmax <- function(var, na.rm = TRUE){
  (var - min(var))/diff(range(var, na.rm = na.rm ))
}

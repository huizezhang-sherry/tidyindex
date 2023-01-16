#' Rescaling functions
#'
#' @param var variable
#' @param na.rm logical; whether to remove NAs
#' @param min min
#' @param max max
#'
#' @return a vector of rescaled variable
#' @export
#' @rdname rescale
rsc_zscore <- function(var, na.rm = TRUE){

 (var - mean(var, na.rm = na.rm))/ sd(var, na.rm = na.rm)
}

#' @export
#' @rdname rescale
rsc_minmax <- function(var, min = NULL, max  = NULL, na.rm = TRUE){

  if (is.null(min)) min <- min(var, na.rm = na.rm)
  if (is.null(max)) max <- max(var, na.rm = na.rm)

  (var - min)/diff(c(min, max))
}

#' @export
#' @rdname rescale
rsc_center <- function(var, na.rm = TRUE){
  var - mean(var, na.rm = na.rm)
}


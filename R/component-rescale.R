#' Rescaling functions
#'
#' guide on implementing new rescaling functions: a vector function that
#' takes a single variable, var, with additional parameters
#'
#' A known problem: `dt %>% rescaling(life_exp = rescale_minmax, var = life_exp)` will fail
#'
#' @param var variable
#' @param na.rm logical; whether to remove NAs
#' @param min min
#' @param max max
#' @param censor logical; whether to censor points outside min and max, if provided
#'
#' @return a vector of rescaled variable
#' @export
#' @seealso [rescaling()]
#' @rdname rescale
rescale_zscore <- function(var, na.rm = TRUE){

 (var - mean(var, na.rm = na.rm))/ sd(var, na.rm = na.rm)
}

#' @export
#' @rdname rescale
rescale_minmax <- function(var, min = NULL, max  = NULL, na.rm = TRUE, censor = TRUE){

  if (is.null(min)) min <- min(var, na.rm = na.rm)
  if (is.null(max)) max <- max(var, na.rm = na.rm)

  res <- (var - min)/diff(c(min, max))

  if (censor){
    res[res > 1] <- 1
    res[res <0] <- 0
  }

  res
}

#' @export
#' @rdname rescale
rescale_center <- function(var, na.rm = TRUE){
  var - mean(var, na.rm = na.rm)
}


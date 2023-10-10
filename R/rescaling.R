#' The rescaling module
#'
#' The rescale module accepts a [dplyr::mutate()] alike expression to change
#' the scale of the variable(s). Currently available rescaling:
#' \code{rescale_zscore()}, \code{rescale_minmax()}, and \code{rescale_center}
#'
#' @param data an index table object, see [tidyindex::init()]
#' @param ... expression, in the syntax of \code{NEW_NAME = rescale_*(...)}
#' @param var the variable(s) to rescale, accept tidyselect syntax
#' @param na.rm used in \code{rescale_*()}; logical; whether to remove NAs
#' @param min,max used in \code{rescale_minmax()}, the minimum and maximum value
#' @param censor logical; whether to censor points outside min and max, if provided
#' @rdname rescale
#' @export
#' @examples
#' dt <- hdi %>% init()
#' dt |> rescaling(life_exp = rescale_zscore(life_exp))
#' dt |> rescaling(life_exp2 = rescale_minmax(life_exp, min = 20, max = 85))
#' dt |> rescaling(life_exp = rescale_minmax(life_exp, min = 20, max = 85))
rescaling <- function(data, ...){
  dot <- rlang::list2(...)
  dot_mn <- names(dot) |> sym()
  dot <- dot[[1]]

  if (!inherits(dot, "rescale")){
    cli::cli_abort("A rescale object from {.fn rescale_} is required as input.")
  }

  if (!inherits(data, "idx_tbl")){
    cli::cli_abort("The data object needs to be an {.code idx_tbl} object.")
  }

  data$data <- data$data |> mutate(!!dot_mn := do.call(
    attr(dot, "fn"),
    c(attr(dot, "args"), var = attr(dot, "var"))
    ))

  data$steps <- data$steps |>
    rbind(dplyr::tibble(module = "rescaling", op = dot, name = as.character(dot_mn)))
  return(data)

}


#' @export
#' @rdname rescale
rescale_zscore <- function(var, na.rm = TRUE){

  fn <- function(var, na.rm = TRUE){
    (var - mean(var, na.rm = na.rm))/ sd(var, na.rm = na.rm)
  }

  new_rescale("rescle_zscore", var = enquo(var), fn = fn, na.rm = na.rm)

}

#' @export
#' @rdname rescale
rescale_minmax <- function(var, min = NULL, max  = NULL, na.rm = TRUE, censor = TRUE){

  fn <- function(var, min = NULL, max  = NULL, na.rm = TRUE, censor = TRUE){
    if (is.null(min)) min <- min(var, na.rm = na.rm)
    if (is.null(max)) max <- max(var, na.rm = na.rm)

    res <- (var - min)/diff(c(min, max))
    if (censor) res[res > 1] <- 1; res[res < 0] <- 0
    res
  }

  new_rescale("rescle_minmax", var = enquo(var), fn = fn,
              max = max, min = min, na.rm = na.rm, censor = censor)

}

#' @export
#' @rdname rescale
rescale_center <- function(var, na.rm = TRUE){
  fn <- function(var, na.rm = TRUE) {var - mean(var, na.rm = na.rm)}
  new_rescale("rescle_center", var = enquo(var), fn = fn, na.rm = na.rm)
}

new_rescale <- function(type, var, fn, ...){
  dots <- rlang::list2(...)
  name <- type
  attr(name, "var") <- var
  attr(name, "fn") <- fn
  attr(name, "args") <- dots
  class(name) <- "rescale"
  name
}

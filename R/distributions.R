#' Distribution functions
#'
#' @return a character representation of the distribution
#' @export
#' @rdname distributions
gamma <- function() "gam"

#' @export
#' @rdname rescale
normal <- function() "nor"

#' @export
#' @rdname rescale
weibull <- function() "wei"

#' @export
#' @rdname rescale
loglogistic <- function() "glo"

#' @export
#' @rdname rescale
lognormal <- function() "ln3"

#' @export
#' @rdname rescale
gev <- function() "gev"

#' @export
#' @rdname rescale
pearsonIII <- function() "pe3"


find_lmom_dist <- function(dist){
  dist <- switch(dist,
                 normal = "nor",
                 gamma = "gam",
                 weibull = "wei",
                 gev = "gev",
                 pearson3 = "pe3",
                 glogist = "glo",
                 glnorm = "ln3")

  if (is.null(dist)){
    cli::cli_abort("The distribution specified is not valid:
          currently accepting: {.field normal, gamma, weibull, gev, pearson3, glogist, glnorm}")
  }
  dist
}

# build_fit_lmomco_expr <- function(dist, col){
#   par_fun <- map(dist, build_lmom_par_fun)
#   expr <- map2(col, par_fun, ~expr(list(do.call(!!.y, list(lmoms(!!.x))))))
#   return(expr)
# }
#
#

build_lmom_par_fun <- function(dist){
  paste0("par", dist)
}



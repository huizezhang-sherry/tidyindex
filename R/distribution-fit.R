#' The distribution fit module
#'
#' This module fits a distribution to the variable of interest. Currently
#' implemented distributions are: gamma, \code{dist_gamma()},
#' generalized logistic, \code{dist_glo()}, generalized extreme value,
#' \code{dist_gev()}, and Pearson Type III, \code{dist_pe3()}
#'
#' @param data an index table object
#' @param ... a distribution fit object, currently implemented are
#' \code{dist_gamma()}, \code{dist_glo()}, \code{dist_gev()}, and
#' \code{dist_pe3()}
#' @param var used in \code{dist_*()} functions, the variable to fit
#' @param method used in \code{dist_*()} functions, the fitting method,
#' currently support "lmoms" for L-moment fit
#' @return an index table object
#' @rdname dist-fit
#' @export
#' @examples
#' library(dplyr)
#' library(lmomco)
#' tenterfield |>
#'   mutate(month = lubridate::month(ym)) |>
#'   init(id = id, time = ym, group = month) |>
#'   temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12)) |>
#'   distribution_fit(.fit = dist_gamma(.agg, method = "lmoms"))
distribution_fit <- function(data, ...){
  dot <- rlang::list2(...)
  dot_mn <- names(dot) |> sym()
  dot <- dot[[1]]

  check_idx_tbl(data)
  check_dist_fit_obj(dot)
  group_var <- get_group_var(data)
  id <- get_id(data)
  time <- get_temporal_index(data)

  distfit_vars_root <- rlang::quo_get_expr(attr(dot, "var"))
  distfit_vars <- grep(distfit_vars_root, data$steps$name, value = TRUE)
  dot_mn <- paste0(dot_mn, sub(distfit_vars_root, "", distfit_vars))

  dt <- data$data |> dplyr::ungroup() |> dplyr::nest_by(id, !!sym(group_var))
  res <- purrr::map2(distfit_vars, dot_mn, ~compute_distfit(dt, .x, .y, dot))


  data$data <- data$data |>
    dplyr::bind_cols(purrr::reduce(res, dplyr::bind_cols)) |>
    dplyr::arrange(id, !!sym(time))

  data$steps <- data$steps |>
    rbind(dplyr::tibble(
      id = nrow(data$steps) + 1,
      module = "distribution_fit",
      op = list(dot),
      name = as.character(dot_mn)))
  return(data)
}

compute_distfit <- function(data, var, name, dot){
  res <- data |>
    mutate(!!name[[1]] := list(do.call(attr(dot, "fn"),
                                         list(var = data[[var[[1]]]])))
    ) |>
    tidyr::unnest(!!name[[1]]) |>
    ungroup() |>
    mutate(data = pmap(list(data, fit), cbind)) |>
    tidyr::unnest(data) |>
    dplyr::select(-fit)


  res_mn <- colnames(res)
  new_nm <- c(name, glue::glue("{name[[1]]}_obj"))
  res_mn[(length(res_mn)-1):length(res_mn)] <- new_nm
  names(res) <- as.character(res_mn)
  res[,new_nm]
}



#' @export
#' @rdname dist-fit
dist_gamma <- function(var, method = "lmoms"){

  check_lmomco_installed()
  fn <- switch(method,
    lmoms = function(var) {
      para <- do.call("pargam", list(do.call("lmoms", list(var))))
      fit <- do.call("cdfgam", list(x = var, para = para))
      tibble(para = list(para), fit = list(fit))
    },
    mle = function(var, dist) fn_mle,
    mom = function(var, dist) fn_mom
  )
  new_dist_fit("distfit_gamma", var = enquo(var),
               dist = "gamma", fn = fn)
}

#' @export
#' @rdname dist-fit
dist_glo <- function(var, method = "lmoms"){

  check_lmomco_installed()
  fn <- switch(method,
    lmoms = function(var) {
      para <- do.call("parglo", list(do.call("lmoms", list(var))))
      fit <- do.call("cdfglo", list(x = var, para = para))
      tibble(para = list(para), fit = list(fit))
    },
    mle = function(var, dist) fn_mle,
    mom = function(var, dist) fn_mom
  )
  new_dist_fit("distfit_glo", var = enquo(var), dist = "glo", fn = fn)
}

#' @export
#' @rdname dist-fit
dist_gev <- function(var, method = "lmoms"){

  check_lmomco_installed()
  fn <- switch(method,
    lmoms = function(var) {
      para <- do.call("pargev", list(do.call("lmoms", list(var))))
      fit <- do.call("cdfgev", list(x = var, para = para))
      tibble(para = list(para), fit = list(fit))
    },
    mle = function(var, dist) fn_mle,
    mom = function(var, dist) fn_mom
  )
  new_dist_fit("distfit_gev", var = enquo(var), dist = "gev", fn = fn)
}

#' @export
#' @rdname dist-fit
dist_pe3 <- function(var, method = "lmoms"){

  check_lmomco_installed()
  fn <- switch(method,
    lmoms = function(var) {
      para <- do.call("parpe3", list(do.call("lmoms", list(var))))
      fit <- do.call("cdfpe3", list(x = var, para = para))
      tibble(para = list(para), fit = list(fit))
    },
    mle = function(var, dist) fn_mle,
    mom = function(var, dist) fn_mom)
  new_dist_fit("distfit_pe3", var = enquo(var), dist = "pe3", fn = fn)
}

new_dist_fit <- function(type, var, dist, fn, ...){
  dots <- rlang::list2(...)
  name <- type
  attr(name, "var") <- var
  attr(name, "fn") <- fn
  attr(name, "dist") <- dist
  class(name) <- "dist_fit"
  name
}

globalVariables(c("fn_mle", "fn_mom", "variables", "fit"))

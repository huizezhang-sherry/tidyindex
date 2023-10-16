#' The normalise module
#'
#' The normalise module takes a probability value from a distribution fit
#  output, and transforms it to a z-score value. Currently support
#' \code{norm_quantile()} to convert based on the normal quantile function
#' @param data an index table object
#' @param ... the expression to be evaluated
#' @param var used in \code{norm_quantile()}; the variable to be converted
#' @return an index table object
#' @export
#' @examples
#' tenterfield |>
#'   mutate(month = lubridate::month(ym)) |>
#'   init(id = id, time = ym, group = month) |>
#'   temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12)) |>
#'   distribution_fit(.fit = dist_gamma(.agg, method = "lmoms")) |>
#'   normalise(index = norm_quantile(.fit))
normalise <-function(data, ...){
  dot <- rlang::list2(...)
  dot_mn <- names(dot) |> sym()
  dot <- dot[[1]]

  check_idx_tbl(data)
  check_normalise_obj(dot)
  group_var <- get_group_var(data)
  id <- get_id(data)
  time <- get_temporal_index(data)

  data$data <- data$data |> mutate(!!dot_mn := do.call(
    attr(dot, "fn"), list(var = attr(dot, "var"))
  ))

  data$steps <- data$steps |>
    rbind(dplyr::tibble(
      id = nrow(data$steps) + 1,
      module = "normalise",
      op = list(dot),
      name = as.character(dot_mn)))
  return(data)

}


#' @export
#' @rdname rescale
norm_quantile <- function(var){
  fn <- function(var) {qnorm(var)}
  new_normalise("norm_quantile", var = enquo(var), fn = fn)
}

new_normalise <- function(type, var, fn, ...){
  dots <- rlang::list2(...)
  name <- type
  attr(name, "var") <- var
  attr(name, "fn") <- fn
  class(name) <- "normalise"
  name
}

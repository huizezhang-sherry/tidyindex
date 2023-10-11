#' The distribution fit module
#'
#' @param .data an index table object
#' @param .dist distributions
#' @param .gran granularity
#' @param .var variable
#' @param .n_boot number of bootstrap samples, default to 1
#' @param .boot_seed the seed of bootstrap sampling
#' @param .method fitting methods, one of lmoms (L-moment), mle (Maximum Likelihood),
#' and mom (Method of moment)
#'
#' @return a data frame
#' @export
#'
#' @examples
#'# TODO: need to add examples
dist_fit <- function(.data,
                      .dist,
                      .gran = "month",
                      .var,
                      .n_boot = 1,
                      .boot_seed = 123,
                      .method = "lmoms") {
  data <- .data
  var <- enquo(.var)
  dist <- as.list(eval(.dist))
  gran <- .gran
  method <- .method
  check_idx_tbl(data)

  id <- data$roles |> filter(roles == "id") |> pull(variables) |> sym()
  index <- data$roles |> filter(roles == "time") |> pull(variables) |> sym()
  roles <- data$roles
  op <- data$op
  data <- data$data

  ########################################
  # implementing bootstrap
  if (.n_boot != 1) {
    res <- bootstrap_aggregation(
      data =  data, col = var, date = index,
      n_boot = .n_boot, boot_seed = .boot_seed)
  } else{
    res <- data |> mutate(.boot = 1)
  }

  ########################################
  # estimate parameters
  if (method == "lmoms") {
    if (.n_boot != 1) {
      fit_expr <- build_fit_expr(dist, quo(.boot_agg), method)
    } else{
      fit_expr <- build_fit_expr(dist, var, method)
    }
    expr <- fit_expr$expr
    op_expr <- fit_expr$op_expr
    # TODO: make sure lubridate is loaded to have gran = month work

    if (.n_boot != 1){
      res <- res |>
        group_by(.period = do.call(gran, list(!!index)), !!id, .boot, .scale)
    } else{
      res <- res |>
        group_by(.period = do.call(gran, list(!!index)), !!id, .scale)
    }
    res <- res |> mutate(!!!expr)
  }

  ########################################
  # to long form, always
  res <- res |>
    to_long(cols = names(expr), names_to = "aaa", values_to = ".fit") |>
    tidyr::separate("aaa", into = c(".dist", ".method"))

  #res <- res |> ungroup()

  roles <- roles |>
    dplyr::bind_rows(dplyr::tibble(variables = ".period", roles = "temporal grouping")) |>
    dplyr::bind_rows(dplyr::tibble(variables = ".dist", roles = "parameter")) |>
    dplyr::bind_rows(dplyr::tibble(variables = ".method", roles = "parameter")) |>
    dplyr::bind_rows(dplyr::tibble(variables = ".fit", roles = "fitted object"))

  op <- op |>
    dplyr::bind_rows(dplyr::tibble(
      module = "dist fit", step = as.character(method), var = NA, args = "dist",
      val = as.character(unlist(dist)), res = ".fit"))

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("idx_tbl", class(res))
  return(res)
}

bootstrap_aggregation <- function(data, col, date, n_boot, boot_seed){
  set.seed(boot_seed)
  col_str <- rlang::quo_get_expr(col)
  purrr::map_dfr(1:n_boot, ~data |> mutate(.boot = .x)) |>
    group_by(id, .period = month(!!date)) |>
    tidyr::nest(data = -c(id, .period, .boot)) |>
    rowwise() |>
    mutate(
      .boot_agg = list(tibble(.boot_agg = sample(data[[col_str]], nrow(data), replace = TRUE)))) |>
    ungroup() |>
    unnest(c(data, .boot_agg))
}


build_fit_expr <- function(dist, var, method) {

  dist <- map(dist, build_lmom_par_fun)
  method <- list(method)
  dt <-
    expand.grid(dist = dist,
                method = method,
                var = quo_name(var))

  expr <- purrr::map2(dt$dist, dt$method,
       ~ expr(list(do.call(!!!.x, list(do.call(!!!.y, list(!!var)))))))


  # op_expr
  a <- deparse(as.call(c(as.symbol(method[[1]]), as.symbol(rlang::quo_get_expr(var)))))
  op_expr <-purrr::map_chr(dist, ~paste0(as.symbol(.x), "(", a, ")"))

  # WARNING: expr outputs a list of expressions to evaluate but names before is only one!
  names(expr) <- paste0(dt$dist, "-", dt$method)
  list(expr = expr, op_expr = op_expr)
}

globalVariables(".boot")

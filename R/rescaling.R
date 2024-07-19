#' The rescaling module
#'
#' The rescale module changes the scale of the variable(s) using one of the
#' available rescaling functions: \code{rescale_zscore()},
#' \code{rescale_minmax()}, and \code{rescale_center}.
#'
#' @param data an index table object, see [tidyindex::init()]
#' @param ... used in \code{rescaling}, a rescaling object of class
#' \code{rescale}, currently one of the \code{rescale_zscore()},
#' \code{rescale_minmax()}, and \code{rescale_center()},
#' @param var the variable(s) to rescale, accept tidyselect syntax
#' @param na.rm used in \code{rescale_*()}, logical, whether to remove NAs
#' @param min,max used in \code{rescale_minmax()}, the minimum and maximum value
#' @param censor used in \code{rescale_minmax()}, logical;
#' whether to censor points outside min and max, if provided
#' @return an index table object
#' @rdname rescale
#' @export
#' @examples
#' dt <- hdi |> init()
#' dt |> rescaling(life_exp = rescale_zscore(life_exp))
#' dt |> rescaling(life_exp2 = rescale_minmax(life_exp, min = 20, max = 85))
#' hdi_init <- hdi |>
#'   init(id = country) |>
#'   add_paras(hdi_scales, by = "var")
#' hdi_init |>
#'   rescaling(rescale_minmax(c(life_exp, exp_sch, avg_sch, gni_pc),
#'   min = min, max = max))
rescaling <- function(data, ...){
  dot <- rlang::list2(...)

  # dot_mn is only used when there is one variable
  dot_mn <- if (length(names(dot)) == 1){
    names(dot)
  } else if (length(dot) == 1){
    attr(dot[[1]], "var") |> as.character()
  }
  dot <- dot[[1]]

  check_idx_tbl(data)
  check_rescale_obj(dot)

  vars <- attr(dot, "var")
  args <- attr(dot, "args")
  args_quo_idx <- purrr::map_lgl(args, rlang::is_quosure)
  args_quo <- args[args_quo_idx]
  args_not_quo <- args[!args_quo_idx]

  args_quo_sym_idx <- purrr::map_lgl(
    args_quo, ~rlang::quo_get_expr(.x) |> rlang::is_symbol())
  args_quo_sym <- args_quo[args_quo_sym_idx]
  args_quo_not_sym <- args_quo[!args_quo_sym_idx]

  args_quo_sym <- map(args_quo_sym, rlang::quo_get_expr)

  if (length(args_quo_sym) == 0) {
    # if no additional prameters - process directly
    args_quo_sym <- map(args_quo_sym, function(x) {
      data$data |> dplyr::pull(x)
    })
    args <- c(args_not_quo, args_quo_not_sym, args_quo_sym)
    data$data <- data$data |> mutate(!!dot_mn := do.call(
      attr(dot, "fn"), c(args, var = vars)
      ))
  } else{
    # process additional parameters used for rescaling: max, min etc, either
    # from the data or from the para table
    args_quo_sym_mn <- as.character(args_quo_sym)
    if (all(args_quo_sym_mn %in% colnames(data$data))){
      args_quo_sym <- map(vars, ~map(args_quo_sym, function(xx) {
        data$data |> dplyr::pull(xx)}))
    } else if (all(args_quo_sym_mn %in% colnames(data$paras))){
      args_quo_sym <- map(vars, ~map(args_quo_sym, function(xx) {
        data$paras |> dplyr::filter(variables == .x) |> dplyr::pull(xx)}))
    } else{
      cli::cli_abort("can't find the column {names(args_quo_sym)} in the data or para table")
    }

    # compute the rescaled values
    res_lst <- purrr::map2(vars, args_quo_sym, ~{
      args <- c(args_not_quo, args_quo_not_sym, .y)
      data$data |>
        mutate(aaa = do.call(attr(dot, "fn"), c(var = .x, args)
        )) |> pull(aaa)
    })
    names(res_lst) <- if (is.null(dot_mn)) {as.character(vars)} else {dot_mn}
    data$data <- data$data |>
      dplyr::select(-tidyr::all_of(intersect(names(data$data), names(res_lst)))) |>
      dplyr::bind_cols(res_lst)
  }

  data$steps <- data$steps |>
    rbind(dplyr::tibble(
      id = nrow(data$steps) + 1,
      module = "rescaling",
      op = list(dot),
      name = as.character(dot_mn)))
  return(data)

}



#' @export
#' @rdname rescale
rescale_zscore <- function(var, na.rm = TRUE){

  fn <- function(var, na.rm = TRUE){
    (var - mean(var, na.rm = na.rm)) / sd(var, na.rm = na.rm)
  }

  new_rescale("rescale_zscore", var = enquo(var), fn = fn, na.rm = na.rm)

}

#' @export
#' @rdname rescale
rescale_minmax <- function(var, min = NULL, max  = NULL, na.rm = TRUE, censor = TRUE){
  min <- enquo(min)
  max <- enquo(max)

  fn <- function(var, min = NULL, max  = NULL, na.rm = TRUE, censor = TRUE){
    #browser()
    if (is.null(min)) min <- min(var, na.rm = na.rm)
    if (is.null(max)) max <- max(var, na.rm = na.rm)

    res <- (var - min)/(max - min)
    if (censor) res[res > 1] <- 1; res[res < 0] <- 0
    res
  }
  enexpr(var) |> as.list() -> aa
  # if in `c()` syntax remove `c()` as the first element of the list
  if (length(aa) > 1) {var <- aa[-1]} else {var <- aa}
  new_rescale("rescale_minmax", var = var, fn = fn,
              max = max, min = min, na.rm = na.rm, censor = censor)

}

#' @export
#' @rdname rescale
rescale_center <- function(var, na.rm = TRUE){
  fn <- function(var, na.rm = TRUE) {var - mean(var, na.rm = na.rm)}
  new_rescale("rescale_center", var = enquo(var), fn = fn, na.rm = na.rm)
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

#' The dimension reduction module
#'
#' @param data an `idx_tbl` object
#' @param ... expression to evaluate
#' @param formula a formula of the dimension reduction expression
#' @param weight a variable in the `paras` table of an `idx_tbl` object
#'
#' @return an index table object
#' @rdname dr
#' @export
dimension_reduction <- function(data, ...){

  dot_name <- names(rlang::dots_list(...))
  # only do one action for now
  dot <- rlang::dots_list(...)[[1]]
  all_attrs <- names(attributes(dot))

  if (!inherits(dot, "dim_red")){
    cli::cli_abort("A dimension reduction object is required as input.
                   Create from {.code aggregate_*()} or {.code manual_input()}")
  }


  if ("var" %in% all_attrs){
    v <- attr(dot, "var")
    vars <- tidyselect::eval_select(rlang::parse_expr(v), data$data)
    vars_nm <- names(vars)
  }

  if ("weight" %in% all_attrs){
    w <- attr(dot, "weight")
    weight <- tidyselect::eval_select(rlang::parse_expr(w), data$paras)
    weight_nm <- names(weight)
  }

  if ("formula" %in% all_attrs){
    dot_fml <- attr(dot, "formula") |> rlang::parse_expr()
  }

  if (dot == "aggregate_linear"){
    weight <- data$paras |> filter(variables %in% vars_nm) |> pull(weight_nm)
    pieces <-  paste0(vars_nm, "*", weight, collapse = "+")
    dot_fml <- paste("~", pieces) |> stats::as.formula() |> rlang::f_rhs()
    data$data <- data$data |> mutate(!!dot_name := rlang::eval_tidy(dot_fml, data = .))
    exprs <- NA
    vars <- list(vars_nm)
    params <-  list(weight = weight)
  }

  if (dot == "aggregate_geometrical"){
    dot_fml <- build_geometrical_expr(vars_nm)
    data$data <- data$data |> mutate(!!dot_name := rlang::eval_tidy(dot_fml, data = .))
    exprs <- NA
    vars <- list(vars_nm)
    params <- NA
  }

  if (dot ==  "manual_input"){
    data$data <- data$data |> mutate(!!dot_name := rlang::eval_tidy(dot_fml, data = .))
    exprs <- deparse(dot_fml)
    vars <- NA
    params <- NA
  }

  data$steps <- data$steps |> rbind(dplyr::tibble(
    id = nrow(data$steps) + 1,
    module = "dimension_reduction",
    op = list(dot),
    name = as.character(dot_name)))



  return(data)
}

#' @rdname dr
#' @export
aggregate_linear <- function(formula, weight){
  vars <- rlang::f_text(formula)
  weight <- enquo(weight) |> rlang::quo_text()
  new_dimension_reduction("aggregate_linear", vars = vars,  weight = weight, formula = NULL)
}

#' @rdname dr
#' @export
aggregate_geometrical <- function(formula){
  vars <- rlang::f_text(formula)
  new_dimension_reduction("aggregate_geometrical", vars = vars,  weight = NULL, formula = NULL)
}

#' @rdname dr
#' @export
manual_input <- function(formula){
  formula <- rlang::f_text(formula)
  new_dimension_reduction("manual_input", formula = formula, vars = NULL, weight = NULL)
}

new_dimension_reduction <- function(type, formula, vars, weight){
  name <- type
  attr(name, "var") <- vars
  attr(name, "weight") <- weight
  attr(name, "formula") <- formula
  class(name) <- "dim_red"
  name
}

build_geometrical_expr <- function(vars){
  glue::glue("~(", paste0(vars,  collapse = "*"), ")^(1/{length(vars)})") |>
    stats::as.formula() |>
    rlang::f_rhs()
}

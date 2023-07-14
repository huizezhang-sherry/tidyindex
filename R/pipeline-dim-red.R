#' A dimension reduction module
#'
#' need detailed documentation on the module
#' @param data an `idx_tbl` object
#' @param ... expression to evaluate
#'
#' @return an `idx_tbl` object
#' @export
dimension_reduction <- function(data, ...){
  dot_name <- names(dots_list(...))
  dot <- dots_list(...)[[1]]
  all_attrs <- names(attributes(dot))

  if ("var" %in% all_attrs){
    v <- attr(dot, "var")
    vars <- tidyselect::eval_select(parse_expr(v), data$data)
    vars_nm <- names(vars)
  }

  if ("weight" %in% all_attrs){
    w <- attr(dot, "weight")
    weight <- tidyselect::eval_select(parse_expr(w), data$roles)
    weight_nm <- names(weight)
  }

  if ("formula" %in% all_attrs){
    dot_fml <- attr(dot, "formula") %>% parse_expr()
  }

  if (dot == "aggregate_linear"){
    weight <- data$roles %>% filter(variables %in% vars_nm) %>% pull(weight_nm)
    pieces <-  paste0(vars_nm, "*", weight, collapse = "+")
    dot_fml <- paste("~", pieces) %>% as.formula() %>% f_rhs()
    data$data <- data$data %>% mutate(!!dot_name := eval_tidy(dot_fml, data = .))
    dot_fml <- pieces %>% sym()
  }

  if (dot == "aggregate_geometrical"){
    dot_fml <- glue::glue("~(", paste0(vars_nm,  collapse = "*"), ")^(1/{length(vars_nm)})") %>% as.formula() %>% f_rhs()
    data$data <- data$data %>% mutate(!!dot_name := eval_tidy(dot_fml, data = .))
  }

  if (dot ==  "manual_input"){
    data$data <- data$data %>% mutate(!!dot_name := eval_tidy(dot_fml, data = .))
  }

  data$roles <- data$roles %>%
    dplyr::bind_rows(dplyr::tibble(variables = dot_name))
  data$op <- data$op %>% dplyr::bind_rows(dplyr::tibble(
    module = "dimension_reduction",
    step = as.character(dot),
    var = deparse(dot_fml),
    res = dot_name))

  return(data)
}

#' @export
aggregate_linear <- function(formula, weight){
  vars <- rlang::f_text(formula)
  weight <- enquo(weight) %>% quo_text()
  new_dimension_reduction("aggregate_linear", vars = vars,  weight = weight, formula = NULL)
}

#' @export
aggregate_geometrical <- function(formula, weight){
  vars <- rlang::f_text(formula)
  new_dimension_reduction("aggregate_geometrical", vars = vars,  weight = NULL, formula = NULL)
}

#' @export
manual_input <- function(formula){
  formula <- rlang::f_text(formula)
  new_dimension_reduction("manual_input", formula = formula, vars = NULL, weight = NULL)
}

#' @export
new_dimension_reduction <- function(type, formula, vars, weight){
  name <- type
  attr(name, "var") <- vars
  attr(name, "weight") <- weight
  attr(name, "formula") <- formula
  class(name) <- "dim_red"
  name
}

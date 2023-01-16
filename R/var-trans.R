#' Variable transformation
#'
#' @param data data
#' @param method the method use
#' @param vars variables
#' @param ... expression
#' @param param_tbl parameter table
#' @param new_name the new name
#'
#' @return an indri object
#' @export
var_trans <- function(data, ..., method = NULL, vars = NULL, param_tbl, new_name = NULL){
  dots <- enquos(...)
  method <- enquo(method)
  vars <- enquo(vars)
  if (inherits(data, "indri")){
    id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
    if ("time" %in% data$roles$roles){
      index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
    }

    op <- data$op
    roles <- data$roles
    data <- data$data
  } else{
    id <- enquo(id)
    index <- enquo(index)
  }

  if (rlang::quo_is_null(method)){
    new_data <- data %>% dplyr::mutate(!!!dots)
    fmls <- purrr::map_chr(dots, ~rlang::quo_get_expr(.x) %>% deparse)
    step <- "formula"
  } else{


    if (!rlang::quo_is_null(vars)){
      vars <- tidyselect::eval_select(vars, data) %>% names()
      params <- c(list(var = data %>% dplyr::select(vars)), map(dots, ~eval(rlang::quo_get_expr(.x))))
      new_data <- data
      new_data[,vars] <- purrr::pmap(params, get(rlang::quo_get_expr(method)))
    } else{
      if (is.null(new_name)) new_name <- ".var"
      # check if ".var is taken and kindly remind user if so
      new_data <- data %>%
        dplyr::mutate({{new_name}} := as.vector(do.call(!!method, list(!!!dots))))
    }
    fmls <- deparse(as.call(c(as.symbol(quo_name(method)), dots)))
    step <- quo_name(method)

  }


  new_var <- setdiff(colnames(new_data), colnames(data))
  if (length(new_var) == 0) new_var <- "N/A"
  roles <- roles %>%
    dplyr::bind_rows(dplyr::tibble(variables = new_var, roles = "intermediate"))

  op <- op %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "variable transformation", step = step,
      var = fmls, args = NA, val = NA, res = new_var
    ))

  res <- list(data = new_data, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}




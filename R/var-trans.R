#' Variable transformation
#'
#' @param data data
#' @param .method the method use
#' @param .vars variables
#' @param ... expression
#' @param .new_name the new name
#'
#' @return an indri object
#' @export
var_trans <- function(data, ..., .method = NULL, .vars = NULL, .new_name = NULL){
  dots <- enquos(...)
  method <- enquo(.method)
  vars <- enquo(.vars)
  new_name <- .new_name
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
    new_var <- names(dots)
  } else{


    if (!rlang::quo_is_null(vars)){
      vars <- tidyselect::eval_select(vars, data) %>% names()
      # gather all the arguments
      dots_params <- map(dots, ~rlang::eval_tidy(rlang::quo_get_expr(.x), data = data))
      params <- c(list(var = vars), dots_params)
      # concatenate all the arguments into a string
      # i.e. "vars = life_exp, min = 0.000000, max = 5.000000"
      args <- purrr::map_chr(
        1:length(params[[1]]),
        function(ind) {paste0(names(params), " = ", purrr::map_chr(params, ~ .x[ind]), collapse = ", ")})
      # construct the expression to be evaluated in strings, i.e.
      # [[1]]
      # [1] "rescale_minmax(vars = life_exp, min = 0.000000, max = 5.000000)"
      exprs <- map(args, ~paste0(rlang::quo_get_expr(method), "(", .x, ")"))
      new_data <- data
      # evaluate the string
      new_data[,vars] <- map(exprs, ~rlang::eval_tidy(rlang::parse_expr(.x), data = data))
      fmls <- unlist(exprs)
    } else{
      if (is.null(new_name)) new_name <- ".var"
      # check if ".var is taken and kindly remind user if so
      new_data <- data %>%
        dplyr::mutate({{new_name}} := as.vector(do.call(!!method, list(!!!dots))))
      fmls <- deparse(as.call(c(as.symbol(quo_name(method)), dots)))
    }

    step <- quo_name(method)
    new_var <- setdiff(colnames(new_data), colnames(data))
    if (length(new_var) == 0) new_var <- vars#paste0(vars, collapse = ", ")

  }

  roles <- roles %>%
    dplyr::bind_rows(dplyr::tibble(variables = new_var, roles = "intermediate"))

  op <- op %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "var_trans", step = step,
      var = fmls, args = NA, val = NA, res = new_var
    ))

  res <- list(data = new_data, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}




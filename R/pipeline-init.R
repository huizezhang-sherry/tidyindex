#' Initialise the pipeline
#'
#' @param data the dataset
#' @param ... additional argument
#' @param new_meta a tibble or data frame object of metadata
#' @param var_col the variable column in the metadata
#'
#' @return a list object
#' @rdname init
#' @export
init <- function(data, ...){
  dots <-  dplyr::enquos(...)

  # role of a variable: indicators, pillar, index, others
  # TODO rename: roles -> meta, ops -> steps
  roles <- tibble(
    variables = map(dots, ~tidyselect::eval_select(.x, data) %>% names()),
    roles = names(dots)) %>%
    unnest(variables)
  roles <- dplyr::tibble(variables = colnames(data)) %>% dplyr::left_join(roles)

  op <- dplyr::tibble(op = NULL)

  res <- list(data = data, roles = roles, op = op)
  class(res) <- "idx_tbl"
  return(res)
}

#' @rdname init
#' @export
add_meta <- function(data, new_meta, var_col){
  var_col <- enquo(var_col) %>% rlang::quo_name()
  if (!inherits(data, "idx_tbl")) not_idx_tbl()

  lhs_by <- colnames(data$roles)[1]
  data$roles <- data$roles %>% dplyr::full_join(new_meta, by = stats::setNames(var_col, lhs_by))
  return(data)
}

update_meta_cell <- function(data, variable, col, value){
  variable <- enquo(variable) %>% rlang::quo_name()
  col <- enquo(col) %>% rlang::quo_get_expr()
  if (!inherits(data, "idx_tbl")) not_idx_tbl()
  data$roles <- data$roles %>% mutate(!!col := ifelse(variables == {variable}, value, !!col))
  cli::cli_inform("metadata {.var {col}} for {.var {variable}} has been changed to {value}")
  return(data)
}

get_meta <- function(data, vars, cols){
  # check data is the role table of the idx_tbl
  cols <- enquo(cols) %>% rlang::quo_get_expr()
  data %>% filter(variables %in% vars) %>% pull({cols})
}



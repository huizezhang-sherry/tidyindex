#' Title
#'
#' @param obj an indri object
#' @param var the variable to try alternative expression
#' @param exprs the new expressions to test
#' @param raw_data the initial indri object created
#'
#' @return an indri object
#' @export
#'
switch_exprs <- function(obj, var, exprs, raw_data){

  var <- enquo(var) %>% rlang::quo_name()
  exprs <- enquos(exprs)
  ops <- obj$op %>% mutate(id = dplyr::row_number())
  row_to_switch <- ops %>% dplyr::filter(res == !!var) %>% pull(id)

  ops_before <- ops %>% filter(id < row_to_switch)
  res <- run_ops(raw_data, ops_before)

  res



}

# temporarily
globalVariables(c("id"))

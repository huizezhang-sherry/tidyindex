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
  exprs <- rlang::enexpr(exprs)
  exprs <- as.list(exprs)[-1]
  ops <- obj$op %>% mutate(id = dplyr::row_number())
  row_to_switch <- ops %>% dplyr::filter(res == !!var) %>% pull(id)
  module <- ops %>% dplyr::filter(res == !!var) %>% pull(module)
  orig_expr <-  ops %>% dplyr::filter(res == !!var) %>% pull(var)

  ops_before <- ops %>% filter(id < row_to_switch)
  res <- run_ops(raw_data, ops_before)

  all_exprs <- c(unname(orig_expr), map(exprs, rlang::as_label)) %>% map(rlang::parse_expr)
  names <- paste0(".index", 0:(length(all_exprs)-1))
  args <- purrr::map2(all_exprs, names, ~list(.x, data = res) %>% rlang::set_names(c(.y, "data")))
  res2 <- map(args, ~do.call(module, .x))

  out <- merge_indris(new_obj = res2, old_obj = res)
  out
}

# temporarily
globalVariables(c("id"))

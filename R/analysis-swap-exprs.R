#' Title
#'
#' @param obj an index table
#' @param .var the variable to try alternative expression
#' @param .exprs the new expressions to test
#' @param .raw_data the initial index table created
#'
#' @return an index table
#' @export
#'
swap_exprs <- function(obj, .var, .exprs, .raw_data){
  var <- enquo(.var) %>% rlang::quo_name()
  exprs <- as.list(.exprs)
  row_swap <- obj$op %>% dplyr::filter(res == !!var)

  ops_before <- obj$op %>% filter(id < row_swap$id)
  res <- run_ops(.raw_data, ops_before)

  # this part needs to be generalised
  if (row_swap$step == "aggregate_geometrical"){
    vars <- unlist(row_swap$var)
    expr <- paste0("~c(", paste(vars, collapse = ", "), ")") %>% stats::as.formula()
    old_expr <- list(aggregate_geometrical(expr, weight = NULL))
  }

  all_exprs <- c(old_expr, exprs)
  names <- paste0(row_swap$res, seq_len(length(all_exprs)))
  args <- purrr::map2(all_exprs, names, ~list(.x, data = res) %>% rlang::set_names(c(.y, "data")))
  res2 <- map(args, ~do.call(row_swap$module, .x))

  ops_after <- obj$op %>% filter(id > row_swap$id)
  if (nrow(ops_after) >= 1){
    ops_table <- map(
      names,
      ~ops_after %>%
        mutate(var = gsub(res_str, .x, var),
               modify = grepl(res_str, var),
               res = ifelse(modify, paste0(res, as.numeric(sub("[^0-9]+", "", .x))), res))
    )
    res2 <- purrr::map2(res2,  ops_table, ~run_ops(.x, .y))
  }

  out <- merge_index_tables(new_obj = res2, old_obj = res)
  out
}

# temporarily
globalVariables(c("id", "res_str", "."))

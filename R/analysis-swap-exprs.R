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
  exprs <- as.list(rlang::enexpr(.exprs))[-1]
  raw_data <- .raw_data
  ops <- obj$op %>% mutate(id = dplyr::row_number())
  row_to_swap <- ops %>% dplyr::filter(res == !!var) %>% pull(id)
  module <- ops %>% dplyr::filter(res == !!var) %>% pull(module)
  orig_expr <-  ops %>% dplyr::filter(res == !!var) %>% pull(var)
  new_name <- ops %>% dplyr::filter(res == !!var) %>% pull(res)

  ops_before <- ops %>% filter(id < row_to_swap)
  res <- run_ops(raw_data, ops_before)

  all_exprs <- c(unname(orig_expr), map(exprs, rlang::as_label)) %>% map(rlang::parse_expr)
  names <- paste0(new_name, 0:(length(all_exprs)-1))
  args <- purrr::map2(all_exprs, names, ~list(.x, data = res) %>% rlang::set_names(c(.y, "data")))
  res2 <- map(args, ~do.call(module, .x))

  ops_after <- ops %>% filter(id > row_to_swap)
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
globalVariables(c("id"))

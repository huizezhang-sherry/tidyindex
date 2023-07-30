#' Title
#'
#' @param obj obj
#' @param .id module
#' @param .param the parameter to swap
#' @param .values values
#' @param .raw_data the original data
#'
#'
#' @return  an index table
#' @export
swap_values <- function(obj, .id, .param, .values, .raw_data){
  param <- rlang::ensym(.param) %>% rlang::as_string()

  ops <- obj$op %>% mutate(id = dplyr::row_number())
  row_swap <- obj$op %>% dplyr::filter(id == .id)

  param_exist <- param %in% names(row_swap$params)
  if (!param_exist) cli::cli_abort("Can't find the operation, please check on  {.field .id} and {.field .param}")

  ops_before <- obj$op %>% filter(id < row_swap$id)
  res <- run_ops(.raw_data, ops_before)
  #param_values <- as.list(enexpr(.values))[-1] %>% map(sym)
  param_values <- as.list(enexpr(.values))[-1] %>%
    map(~if(rlang::is_call(.x)) {
      rlang::eval_tidy(.x) %>% syms()
      } else{.x}) %>%
    unlist()

  # this part needs to be generalised
  if (row_swap$step == "aggregate_linear"){
    vars <- unlist(row_swap$var)
    formula <- paste0("~c(", paste(vars, collapse = ", "), ")") %>% stats::as.formula()
    all_exprs <- map(param_values, ~aggregate_linear(formula = formula, weight = !!sym(.x)))
  }

  names <- paste0(row_swap$res, seq_len(length(all_exprs)))
  args <- purrr::map2(all_exprs, names, ~list(.x, data = res) %>% rlang::set_names(c(.y, "data")))
  res2 <- map(args, ~do.call(row_swap$module, .x))

  ops_after <- ops %>% filter(id > row_swap$id)
  if (nrow(ops_after) >= 1){
    ops_table <- update_ops_table(ops_after, names, res_str)
    res2 <- purrr::map2(res2,  ops_table, ~run_ops(.x, .y))
  }

  res <- merge_index_tables(res2, res)
  res


}

update_ops_table <- function(table, names, str){
  res <- map(
    names,
    ~table %>%
      mutate(var = gsub(str, .x, var),
             modify = grepl(str, var),
             res = ifelse(modify, paste0(res, as.numeric(sub("[^0-9]+", "", .x))), res)))

  str <- table %>% mutate(modify = grepl(str, var)) %>% filter(modify) %>% pull(res)
  names <- paste0(str, 0:(length(res)-1))
  m <- res[[1]]$modify
  going <- TRUE

  while(going){
    res <- purrr::map2(
      names, res,
      ~.y %>%
        mutate(var = gsub(paste0("\\b", str, "\\b"), .x, var),
               modify = grepl(paste0("\\b", str, "\\b"), var),
               res = ifelse(modify, paste0(res, as.numeric(sub("[^0-9]+", "", .x))), res)))

    a <- table %>% mutate(modify = grepl(str, var)) %>% filter(modify) %>% pull(res)
    str <- setdiff(a, str)
    names <- paste0(str, 0:(length(res)-1))
    m <- res[[1]]$modify
    going <- ifelse(str == "index", FALSE, TRUE)
  }

  res <- purrr::map2(
    names, res,
    ~.y %>% mutate(res = ifelse(res == "index", .x, res))
  )

  res

}

globalVariables(c("module", "var","modify"))

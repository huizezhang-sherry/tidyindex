#' Title
#'
#' @param obj obj
#' @param .module module
#' @param .step step
#' @param .res res
#' @param .var var
#' @param .values values
#' @param .raw_data the original data
#'
#'
#' @return  an index table
#' @export
swap_values <- function(obj, .module, .step, .res, .var, .values, .raw_data){
  module_str <- rlang::ensym(.module) %>% rlang::as_string()
  step_str <- rlang::ensym(.step) %>% rlang::as_string()
  res_str <- rlang::ensym(.res) %>% rlang::as_string()
  var_str <- rlang::ensym(.var) %>% rlang::as_string()
  raw_data <- .raw_data
  values <- .values

  ops <- obj$op %>% mutate(id = dplyr::row_number())
  line_to_swap <- ops %>%
    dplyr::filter(module == module_str, step == step_str, res == res_str)
  row_to_swap <- line_to_swap %>% dplyr::pull(id)

  if (nrow(line_to_swap) != 1){
    cli::cli_abort(
    "No matching operations found,
    please input {.field .module}, {.field .step}, {.field .res} that can uniquely identify an operation")
  }

  ops_before <- ops %>% filter(id < row_to_swap)
  res <- run_ops(raw_data, ops_before)

  orig_expr <-  line_to_swap %>% pull(var)

  orig_call <- orig_expr %>% rlang::parse_expr() %>% as.list()
  new_calls <- c(list(orig_call %>% as.call()),
                 map(values, function(val) {orig_call[var_str] <- val; orig_call %>% as.call()}))
  names <- paste0(res_str,0:(length(new_calls)-1))
  args <- purrr::map2(new_calls, names,  ~list(data = res, .x) %>% rlang::set_names(c("data", .y)))
  res2 <- map(args, ~do.call(module_str, .x))



  ops_after <- ops %>% filter(id > row_to_swap)
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

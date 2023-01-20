#' Title
#'
#' @param obj obj
#' @param module module
#' @param step step
#' @param res res
#' @param var var
#' @param values values
#' @param raw_data the original data
#'
#'
#' @return  an indri object
#' @export
switch_values <- function(obj, module, step, res, var, values, raw_data){
  module_str <- rlang::ensym(module) %>% rlang::as_string()
  step_str <- rlang::ensym(step) %>% rlang::as_string()
  res_str <- rlang::ensym(res) %>% rlang::as_string()
  var_str <- rlang::ensym(var) %>% rlang::as_string()

  ops <- obj$op %>% mutate(id = dplyr::row_number())
  line_to_switch <- ops %>%
    dplyr::filter(module == module_str, step == step_str, res == res_str)
  row_to_switch <- line_to_switch %>% dplyr::pull(id)

  if (nrow(line_to_switch) != 1){
    cli::cli_abort(
    "No matching operations found,
    please input {.field module}, {.field step}, {.field res} that can uniquely identify an operation")
  }

  ops_before <- ops %>% filter(id < row_to_switch)
  res <- run_ops(raw_data, ops_before)

  orig_expr <-  line_to_switch %>% pull(var)

  orig_call <- orig_expr %>% rlang::parse_expr() %>% as.list()
  new_calls <- c(list(orig_call %>% as.call()),
                 map(values, function(val) {orig_call[var_str] <- val; orig_call %>% as.call()}))
  names <- paste0(res_str,0:(length(new_calls)-1))
  args <- purrr::map2(new_calls, names,  ~list(data = res, .x) %>% rlang::set_names(c("data", .y)))
  res2 <- map(args, ~do.call(module_str, .x))

  ops_after <- ops %>% filter(id > row_to_switch)
  ops_table <- map(
    names,
    ~ops_after %>%
      mutate(var = str_replace(var, res_str, .x),
             modify = str_detect(var, res_str),
             res = ifelse(modify, paste0(res, parse_number(.x)), res))
    )
  try <- purrr::map2(res2,  ops_table, ~run_ops(.x, .y))

  res <- merge_indris(try, res)
  res


}

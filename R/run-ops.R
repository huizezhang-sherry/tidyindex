run_ops <- function(raw_data, ops){

  i <- 1
  while(i <= nrow(ops)){
    expr <- rlang::expr(ops$var[i]) %>% rlang::eval_tidy(raw_data)
    args <- list(data = raw_data, var = rlang::parse_expr(expr))
    args <- rlang::set_names(args, c("data", ops$res[i]))
    raw_data <- do.call(ops$module[i], args)
    i <- i + 1
  }

  raw_data
}

# temporarily
globalVariables(c("roles"))

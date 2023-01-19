run_ops <- function(raw_data, ops){
  # internal function
  #if(!inherits(object, "indri")) cli::cli_abort("Need an indri object")
  #data <- object$data
  #ops <- object$op
  # init_roles <- c("indicators", "id", "time")
  # raw_vars <- object$roles %>% dplyr::filter(roles %in% init_roles) %>% dplyr::pull(variables)
  # id <- object$roles %>% dplyr::filter(roles %in% "id") %>% dplyr::pull(variables)
  # indicators <- object$roles %>% dplyr::filter(roles %in% "indicators") %>% dplyr::pull(variables)
  # raw <- data %>% dplyr::select(raw_vars) %>%
  #   init(id = id, indicators = indicators)

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

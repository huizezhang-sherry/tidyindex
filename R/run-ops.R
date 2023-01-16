run_ops <- function(object){
  #browser()

  if(!inherits(object, "indri")) cli::cli_abort("Need an indri object")
  data <- object$data
  ops <- object$op
  init_roles <- c("indicators", "id", "time")
  raw_vars <- object$roles %>% dplyr::filter(roles %in% init_roles) %>% dplyr::pull(variables)
  id <- object$roles %>% dplyr::filter(roles %in% "id") %>% dplyr::pull(variables)
  indicators <- object$roles %>% dplyr::filter(roles %in% "indicators") %>% dplyr::pull(variables)
  raw <- data %>% dplyr::select(raw_vars) %>%
    init(id = id, indicators = indicators)

  expr <- rlang::expr(ops$var[1]) %>% rlang::eval_tidy(data)
  do.call(var_trans, list(data = raw, rlang::parse_expr(expr)))

}

# temporarily
globalVariables(c("roles"))

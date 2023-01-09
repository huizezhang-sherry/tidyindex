#' Dimension reduction
#'
#' @param data data
#' @param expr expression to evaluate
#' @param new_name the new name
#'
#' @return a list object
#' @export
dim_red <- function(data, expr, new_name){

  dots <- enexpr(expr)
  if (inherits(data, "indri")){
    id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
    index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()

    op <- data$op
    roles <- data$roles
    data <- data$data
  } else{
    id <- enquo(id)
    index <- enquo(index)
  }

  # currently only formula
  data[[new_name]] <- rlang::eval_tidy(dots, data)

  op <- op %>%
    dplyr::bind_rows(data.frame(
      module = "dimension reduction", step = "formula", var = deparse(dots),
      args = NA, val = NA, res = new_name
    ))

  res <- list(data = data, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}

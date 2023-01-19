#' Dimension reduction
#'
#' @param data data
#' @param ... expression to evaluate
#' @param new_name the new name
#'
#' @return a list object
#' @export
dim_red <- function(data, ..., new_name){
#browser()
  dots <- enquos(...)
  if (inherits(data, "indri")){
    id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
    if ("time" %in% data$roles$roles){
      index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
    }


    op <- data$op
    roles <- data$roles
    data <- data$data
  } else{
    id <- enquo(id)
    index <- enquo(index)
  }

  # currently only formula
  new_data <- data %>% dplyr::mutate(!!!dots)
  fmls <- purrr::map_chr(dots, ~rlang::quo_get_expr(.x) %>% deparse)
  step <- "formula"
  new_var <- names(dots)

  roles <- roles %>%
    dplyr::bind_rows(dplyr::tibble(variables = new_var, roles = "intermediate"))
  op <- op %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "dim_red", step = "formula", var = fmls,
      args = NA, val = NA, res = new_var
    ))

  res <- list(data = new_data, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}

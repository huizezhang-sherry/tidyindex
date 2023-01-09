#' Calculating PET
#'
#' @param data the data
#' @param method method to calculate PET
#' @param id the site identifier
#' @param ... the variable to use
#'
#' @return a data frame with the variable pet calculated
#' @export
#'
#' @examples
#' if (require(SPEI, quietly = TRUE)){
#' tenterfield %>%
#'   init(id = id, time = ym, indicators = prcp:tavg) %>%
#'   calc_pet(method = "thornthwaite", id = id, Tave = tavg, lat = -29.0479)
#' }
calc_pet <- function(data, method, id = id, ...){

  dots <- enquos(...)
  if (inherits(data, "indri")){
    id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
    index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
    roles <- data$roles
    op <- data$op
    data <- data$data
  } else{
    id <- enquo(id)
  }

  res <- data %>%
    group_by(!!id) %>%
    mutate(pet = as.vector(do.call(method, list(!!!dots)))) %>%
    ungroup()

  exprs <- map(dots, rlang::quo_get_expr)
  if_sym <- purrr::map_lgl(dots, rlang::quo_is_symbol)
  op <- op %>%
    dplyr::bind_rows(
      tibble(module = "var trans", step = method,
             var = as.character(exprs[if_sym]),
             args = names(exprs[!if_sym]), val = as.character(exprs[!if_sym]), res = "pet")
      )

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}


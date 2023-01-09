#' Initialise the pipeline
#'
#' @param data the dataset
#' @param ... additional argument
#'
#' @return a list object
#' @export
init <- function(data, ...){

  dots <-  dplyr::enquos(...)
  roles <- tibble(
    variables = map(dots, ~tidyselect::eval_select(.x, data) %>% names()),
    roles = names(dots)) %>%
    unnest(variables)

  no_roles <- !names(data) %in% roles$variables
  if (any(no_roles)){
    no_roles_tibble <- data.frame(variables = names(data)[no_roles]) %>%
      mutate(roles = NA)
    roles <- roles %>%
      rbind(no_roles_tibble)
  }

  op <- data.frame(op = NULL, args = NULL, vals = NULL)

  res <- list(data = data, roles = roles, op = op)
  class(res) <- "indri"
  return(res)
}




#' Title
#'
#' @param .data  data
#' @param ...  others
#'
#' @return a tidied indri
#' @export
#'
#' @examples
#' # tobefilled
tidy.indri <- function(.data, ...){
  if (!inherits(.data, "indri")) not_indri()

  ops <- .data$op

  ops %>%
    rowwise() %>%
    dplyr::transmute(module = module, step = step,  a = list(rlang::parse_expr(var) %>% as.list())) %>%
    ungroup() %>%
    mutate(a = map(a, ~as_tibble(map(.x, deparse), .name_repair = "unique") %>% pivot_longer(cols = everything(), names_to = "args", values_to = "value"))) %>%
    unnest(a)
}



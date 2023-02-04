#' Title
#'
#' @param .data data
#' @param ... indexes to compute
#'
#' @return output
#' @export
#'
#' @examples
#' library(lmomco)
#' library(lubridate)
#' library(SPEI)
#' res <- tenterfield %>%
#' init(id = id, time = ym) %>%
#'   compute_indexes(
#'     spi = idx_spi(.dist = loglogistic()),
#'     spei = idx_spei(),
#'     edi = idx_edi()
#'   )
compute_indexes <- function(.data, ...){
  if (!inherits(.data, "indri")) not_indri()

  idx <- enquos(...)
  exprs <- map(idx, rlang::quo_get_expr)
  exprs <- map(exprs, ~.x %>% as.list())
  fns <- map(exprs, ~.x[[1]])
  args <- map(exprs, ~.x[-1])
  calls <- purrr::map2(fns, args, ~as.call(list(.x, data = .data, unlist(.y))))
  res <- map(calls, eval) %>% purrr::map_dfr(only_index, .id = "index")

  res

}

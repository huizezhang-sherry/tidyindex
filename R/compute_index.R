#' Title
#'
#' @param .data data
#' @param .index_value logical; whether to output index values
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
#'  init(id = id, time = ym) %>%
#'  compute_indexes(
#'     spi = idx_spi(.dist = loglogistic()),
#'     spei = idx_spei(),
#'     edi = idx_edi()
#'  )
#' res %>%
#'  ggplot(aes(x = ym, y = .index, color = .idx)) +
#'  geom_line() +
#'  theme_benchmark()
compute_indexes <- function(.data, .index_value = TRUE, ...){
  if (!inherits(.data, "indri")) not_indri()

  idx <- enquos(...)
  exprs <- map(idx, rlang::quo_get_expr)
  exprs <- map(exprs, ~.x %>% as.list())
  fns <- map(exprs, ~.x[[1]])
  args <- map(exprs, ~.x[-1])
  calls <- purrr::map2(fns, args, ~as.call(list(.x, data = .data, unlist(.y))))
  res <- map(calls, eval)

  out <- dplyr::tibble(.idx = names(fns), values = res)

  if (.index_value){
    out <- out %>% tidyr::unnest_wider(values) %>% dplyr::select(-roles, -op) %>% unnest(data)
  }

  return(out)
}

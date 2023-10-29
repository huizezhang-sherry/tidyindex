#' Calculate multiple indexes at once
#'
#' @param .data an \code{idx_tbl} object
#' @param ... expressions of indexes to be calculated
#' @return an \code{idx_res} object
#' @rdname compute-idx
#' @export
#'
#' @examples
#' library(dplyr)
#' library(lmomco)
#' library(generics)
#' res <- tenterfield |>
#'   mutate(month = lubridate::month(ym)) |>
#'   init(id = id, time = ym, group = month) |>
#'   compute_indexes(
#'     spi = idx_spi(),
#'     spei = idx_spei(.lat = lat, .tavg = tavg),
#'     edi = idx_edi()
#'  )
#'
#' res |> augment()
compute_indexes <- function(.data, ...){
  check_idx_tbl(.data)

  idx <- enquos(...)
  exprs <- map(idx, rlang::quo_get_expr)
  exprs <- map(exprs, ~.x |> as.list())
  fns <- map(exprs, ~.x[[1]])
  args <- map(exprs, ~.x[-1])
  args2 <- map(args, ~append(.x, list(.data), after =0))
  calls <- purrr::map2(fns, args2, ~rlang::call2(.x, data = .data, !!!.y))
  res <- map(calls, eval)
  out <- dplyr::tibble(.idx = names(fns), values = res)
  class(out) <- c("idx_res", class(out))

  return(out)
}

#' @param x an \code{idx_res} object, calculated from \code{compute_indexes}
#' @param ... Unused, included for generic consistency only
#' @importFrom generics augment
#' @export
#' @rdname compute-idx
augment.idx_res <- function(x, ...){

  a <- x$values
  names(a) <- x[[1]]
  res <- purrr::map_dfr(a, function(x){
    idx_name <- x$steps |> dplyr::filter(id == max(id)) |> dplyr::pull(name)
    orig_vars <- x$paras |> dplyr::pull(variables)
    x$data |>
      dplyr::select(dplyr::all_of(c(orig_vars, idx_name))) |>
      tidyr::pivot_longer(
        cols = idx_name, names_to = ".index", values_to = ".value")
  }, .id = ".id")
  return(res)

}

globalVariables(c("name"))

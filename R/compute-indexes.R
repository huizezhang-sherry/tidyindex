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
  out <- dplyr::tibble(.idx = names(fns), values = res) |>
    tidyr::unnest(values)

  return(out)
}

#' @param x an \code{idx_res} object, calculated from \code{compute_indexes}
#' @param .id a character string, the name of the first column
#' @param ... Unused, included for generic consistency only
#' @importFrom generics augment
#' @export
#' @rdname compute-idx
augment.idx_res <- function(x, .id = ".id", ...){
  a <- x$values
  names(a) <- x[[1]]
  res <- purrr::map_dfr(a, function(data){
    idx_name <- data$steps |> dplyr::filter(id == max(id)) |> dplyr::pull(name)
    agg_names <- data$steps |> filter(module == "temporal") |> pull(name)
    fit_names <- data$steps |> filter(module == "distribution_fit") |> pull(name)
    if (!any(grepl("[0-9]+", idx_name))){
      scale <- data$steps |> filter(module == "temporal") |> utils::head() |>
        pull(op)
      if (length(scale) > 1){
        new_nm <- paste0(idx_name,"_", attr(scale[[1]], "scale"))
        data$data <- data$data |> dplyr::rename(!!sym(new_nm) := all_of(idx_name))
        idx_name <- new_nm
      } else{
        data$.scale <- scale
      }

    }
    orig_vars <- data$paras |> dplyr::pull(variables)
    if (length(idx_name) > 1){
      res <- data$data |>
        tidyr::pivot_longer(
          cols = all_of(c(agg_names, fit_names, idx_name)),
          names_to = c(".value", ".scale"),
          names_pattern = "(.*)_(.*)") |> dplyr::select(-dplyr::contains("obj"))
    } else{
      res <- data$data |> dplyr::select(-dplyr::contains("obj"))
    }
    res
  }, .id = .id)
  return(res)

}

globalVariables(c("name", "op", "values"))

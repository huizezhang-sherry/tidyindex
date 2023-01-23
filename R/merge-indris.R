merge_indris <- function(new_obj, old_obj){
  obj <- new_obj
  col_names <- map(obj, ~.x$data %>% colnames())
  common_cols <- col_names %>% purrr::reduce(intersect)
  names <- map(col_names, ~.x[!.x %in% common_cols])
  new <- purrr::map2(obj, names, ~.x$data[.y]) %>% purrr::reduce(dplyr::bind_cols)
  data <- dplyr::bind_cols(old_obj$data, new)
  nrow_old_op <- nrow(old_obj$op)


  new_roles <- purrr::map2(
    obj, names, ~.x$roles %>% dplyr::filter(variables == .y)
    ) %>%
    purrr::reduce(dplyr::bind_rows)
  roles <- dplyr::bind_rows(old_obj$roles, new_roles)

  new_ops <- purrr::map(obj, ~.x$op %>% filter(row_number() > nrow_old_op)) %>%
    purrr::reduce(dplyr::bind_rows) %>%
    dplyr::distinct()
  op <- dplyr::bind_rows(old_obj$op, new_ops)

  res <- list(data = data, roles = roles, op = op)
  class(res) <- "indri"
  return(res)
}

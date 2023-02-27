merge_index_tables <- function(new_obj, old_obj){
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

  new_ops <- purrr::map(obj, ~.x$op %>% filter(dplyr::row_number() > nrow_old_op)) %>%
    purrr::reduce(dplyr::bind_rows) %>%
    dplyr::distinct()
  op <- dplyr::bind_rows(old_obj$op, new_ops)

  res <- list(data = data, roles = roles, op = op)
  class(res) <- "idx_tbl"
  return(res)
}


#' only the index
#'
#' @param .data data
#'
#' @return only the index
#' @export
#'
#' @examples
#' #tobefilled
only_index <- function(.data){
  if(!inherits(.data, "idx_tbl")) not_idx_tbl()

  ops <- .data$op
  idx_name <- ops$res[length(ops$res)]

  roles <- .data$roles
  rls_name <- roles %>% filter(roles %in% c("id", "time")) %>% pull(variables)

  .data$data %>%
    dplyr::select(rls_name, idx_name)

}


#' print methods
#'
#' @param x data
#' @param ... additional argument
#'
#' @return the print
#' @export
print.idx_tbl <- function(x, ...){
  cat("Index pipeline: \n")

  if (nrow(x$op) ==0){
    cli::cli_text(NULL, default = " Summary: {.field NULL}")
  } else{
    cat("\n")
    cat("Summary: \n")
    op <- x$op %>%
      rowwise() %>%
      mutate(print =cli::cli_text("{.emph {module}}: {.code {var}} -> {.field {res}}"))
  }

  cat("\n")
  cat("Data: \n")
  print(x$data)
}


run_ops <- function(raw_data, ops){

  i <- 1
  while(i <= nrow(ops)){
    expr <- rlang::expr(ops$var[i]) %>% rlang::eval_tidy(raw_data)
    args <- list(data = raw_data, var = rlang::parse_expr(expr))
    args <- rlang::set_names(args, c("data", ops$res[i]))
    raw_data <- do.call(ops$module[i], args)
    i <- i + 1
  }

  raw_data
}

# temporarily
globalVariables(c("roles"))


#' Title
#'
#' @param .data  data
#' @param ...  others
#'
#' @return a tidied index table
#' @importFrom broom tidy
#' @export
#'
#' @examples
#' # tobefilled
tidy.idx_tbl <- function(.data, ...){
  if (!inherits(.data, "idx_tbl")) not_idx_tbl()

  ops <- .data$op

  ops %>%
    rowwise() %>%
    dplyr::transmute(module = module, step = step,  a = list(rlang::parse_expr(var) %>% as.list())) %>%
    ungroup() %>%
    mutate(a = map(a, ~as_tibble(map(.x, deparse), .name_repair = "unique") %>% pivot_longer(cols = everything(), names_to = "args", values_to = "value"))) %>%
    unnest(a)
}



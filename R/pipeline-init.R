#' Initialise the pipeline
#'
#' `add_paras()` joins a standalone parameter table of each variable to the
#' `paras` element of an index object.
#'
#' @param data a tibble or data frame to be converted into a index object
#' @param para_tbl a tibble or data frame object of metadata
#' @param by a single column name (support tidyselect) in the `para_tbl` that
#' maps to the variable name in the data
#'
#' @return a list object
#' @rdname init
#' @export
#' @examples
#' init(hdi)
#' init(gggi)
#' init(gggi) |> add_paras(gggi_weights, by = "variable")
#'
init <- function(data){
  if (!(inherits(data, "tbl_df") || inherits(data, "data.frame")))
    cli::cli_abort(
    "Currently only support a tibble or a data frame as the input
    of tidyindex workflow.")

  paras <- dplyr::tibble(variables = colnames(data))
  steps <- dplyr::tibble(steps = NULL)

  res <- list(data = dplyr::as_tibble(data), paras = paras, steps = steps)
  class(res) <- "idx_tbl"
  return(res)
}

#' @rdname init
#' @export
add_paras <- function(data, para_tbl, by){
  if (!inherits(data, "idx_tbl")) not_idx_tbl()
  by <- enquo(by) %>% rlang::quo_name()

  lhs_by <- colnames(data[["paras"]])[1]
  data[["paras"]] <- data[["paras"]] %>%
    dplyr::full_join(para_tbl, by = stats::setNames(by, lhs_by))
  return(data)
}


#' The print methods
#'
#' @param x an index object
#' @rdname init
#' @export
print.idx_tbl <- function(x){
  cat("Index pipeline: \n")

  if (nrow(x$steps) ==0){
    cli::cli_text(NULL, default = " Summary: {.field NULL}")
  } else{
    cat("\n")
    cat("Steps: \n")
    op <- x$steps %>%
      rowwise() %>%
      mutate(print =cli::cli_text("{.emph {module}}: {.code {var}} -> {.field {res}}"))
  }

  cat("\n")
  cat("Data: \n")
  print(x$data)
}

#' print methods
#'
#' @param x data
#' @param ... additional argument
#'
#' @return the print
#' @export
print.indri <- function(x, ...){
  cat("Index pipeline: \n")

  cat("\n")
  cat("Summary: \n")

  op <- x$op %>%
    rowwise() %>%
    mutate(print = cli::cli_text("{.emph {module}}: {.code {var}} -> {.field {res}}"))

  cat("\n")
  cat("Data: \n")
  print(x$data)
}


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
  if(!inherits(.data, "indri")){
    cli::cli_abort("The function {.fn only_index} requires an indri object")
  }

  ops <- .data$op
  idx_name <- ops$res[length(ops$res)]

  roles <- .data$roles
  rls_name <- roles %>% filter(roles %in% c("id", "time")) %>% pull(variables)

  .data$data %>%
    dplyr::select(rls_name, idx_name)

}



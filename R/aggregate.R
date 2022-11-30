#' Aggregate across time
#'
#' @param data a data frame
#' @param var the variable to aggregate along
#' @param scale the time scale to aggregate
#' @param ... ignore
#' @param id the site identifier
#' @param index the temporal identifier
#'
#' @return a data frame with the variable specified aggregated in scale
#' @export
#' @examples
#' # first 11 rows should be NA since aggregate by 12 months
#' (res <- tenterfield %>% aggregate(var = prcp, scale = 12))
#' res %>% dplyr::filter(!is.na(.agg))
#'
#' # with multiple scales
#' tenterfield %>% aggregate(var = prcp, scale = c(12, 24))
aggregate <- function(data, var, scale, ..., id = NULL, index = NULL){

  if (length(scale) > 1) scale <- as.list(enexpr(scale))
  var <- enquo(var)
  id <- enquo(id)
  index <- enquo(index)
  if (length(scale) > 1){
    new_nm <- paste0(".agg_", scale)
  } else{
    new_nm <- paste0(".agg")
  }

  cls_with_id_idx <- c("tsibble", "cubble")
  if (any(cls_with_id_idx %in% class(data))){
    # extract id and index use the relevant functions from each class
  } else if (rlang::is_null(id) | rlang::is_null(index)){
    cli::cli_abort("Please specify the {.field id} and {.field index} column of the data")
  }

  expr <- map(scale, ~{expr(c(rep(NA, !!.x-1), rowSums(embed(!!var, !!!.x), na.rm = TRUE)))})
  names(expr) <- new_nm
  res <- data %>% group_by(!!id) %>% mutate(!!!expr) %>% ungroup()

  # TODO: make a decision on whether to omit NAs at front
  # if (length(scale) == 1){
  #   res <- res %>% filter(!is.na(!!sym(new_nm)))
  # }

  if (length(scale) == 1){
    res[[".scale"]] <- scale
  } else{
    nm <- paste0(".agg")
    res <- res %>%
      to_long(
        cols = new_nm,
        names_to = ".scale",
        values_to = nm
      ) %>%
      mutate(.scale = as.numeric(gsub(".agg_", "", .scale)))
  }

  attr(res, "id") <- id
  attr(res, "index") <- index
  class(res) <- c("indri", class(res))
  return(res)

}

globalVariables(".scale")

#' Aggregate across time
#'
#' @param data a data frame
#' @param var the variable to aggregate along
#' @param scale the time scale to aggregate
#' @param ... ignore
#' @param id the site identifier
#' @param index the temporal identifier
#' @param na.rm logical, whether to remove the pending NAs when aggregated
#'
#' @return a data frame with the variable specified aggregated in scale
#' @export
#' @examples
#' # first 11 NA rows are removed unless specified through na.rm = FALSE
#' tenterfield %>%
#'   init(id = id, time = ym, indicators = prcp:tavg) %>%
#'   aggregate(var = prcp, scale = 12)
#'
#' # with multiple scales
#' tenterfield %>%
#'   init(id = id, time = ym, indicators = prcp:tavg) %>%
#'   aggregate(var = prcp, scale = c(12, 24))
aggregate <- function(data, var, scale, ..., id = NULL, index = NULL, na.rm = TRUE){

  if (length(scale) > 1) scale <- as.list(enexpr(scale))
  var <- enquo(var)
  if (inherits(data, "indri")){
    id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
    index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
    roles <- data$roles
    op <- data$op
    data <- data$data
  } else{
    id <- enquo(id)
    index <- enquo(index)
  }

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

  if (na.rm){
    cli::cli_inform("Removing the pending NAs due to aggregation")
    res <- res %>% filter(!is.na(.agg))
  }

  op <- op %>%
    dplyr::bind_rows(
      data.frame(module = "temporal", step = "aggregate", var = quo_name(var),
                     args = "scale", val = as.character(scale), res = ".agg")
      )

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}

globalVariables(c(".scale", ".agg"))


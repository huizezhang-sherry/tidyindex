#' Aggregate across time
#'
#' @param data a data frame
#' @param .var the variable to aggregate along
#' @param .scale the time scale to aggregate
#' @param ... ignore
#' @param na.rm logical, whether to remove the pending NAs when aggregated
#' @param .new_name output name
#'
#' @return a data frame with the variable specified aggregated in scale
#' @importFrom slider slide_dbl
#' @export
#' @examples
#' # first 11 NA rows are removed unless specified through na.rm = FALSE
#' tenterfield %>%
#'   init(id = id, time = ym, indicators = prcp:tavg) %>%
#'   aggregate(.var = prcp, .scale = 12)
#'
#' # with multiple scales
#' tenterfield %>%
#'   init(id = id, time = ym, indicators = prcp:tavg) %>%
#'   aggregate(.var = prcp, .scale = c(12, 24))
aggregate <- function(data, .var, .scale, ..., na.rm = TRUE, .new_name = ".agg"){

  if (length(scale) > 1) scale <- as.list(enexpr(.scale))
  var <- enquo(.var)

  if (missing(...)) dot <- sym("sum") else dot <- expr(...)
  new_name <- .new_name
  scale <- .scale
  if (!inherits(data, "idx_tbl")) not_idx_tbl()

  id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
  index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
  roles <- data$roles
  op <- data$op
  data <- data$data


  cls_with_id_idx <- c("tsibble", "cubble")
  if (any(cls_with_id_idx %in% class(data))){
    # extract id and index use the relevant functions from each class
  } else if (rlang::is_null(id) | rlang::is_null(index)){
    cli::cli_abort("Please specify the {.field id} and {.field index} column of the data")
  }

  expr <- map(scale, ~{expr(slider::slide_dbl(.x = !!var, .f = !!!dot, .before = !!.x-1, .complete = TRUE))})
  if (length(scale) > 1){
    names(expr) <-  paste0(new_name, "_", scale)
  } else{
    names(expr) <- new_name
  }

  res <- data %>% group_by(!!id) %>% mutate(!!!expr) %>% ungroup()

  if (length(scale) == 1){
    res[[".scale"]] <- scale
  } else{
    res <- res %>%
      to_long(
        cols = names(expr),
        names_to = ".scale",
        values_to = new_name
      ) %>%
      mutate(.scale = as.numeric(gsub(paste0(new_name, "_"), "", .scale)))
  }

  if (na.rm){
    cli::cli_inform("Removing the pending NAs due to aggregation")
    res <- res %>% filter(!is.na(!!sym(new_name)))
  }

  roles <- roles %>%
    dplyr::bind_rows(dplyr::tibble(variables = ".agg", roles = "intermediate")) %>%
    dplyr::bind_rows(dplyr::tibble(variables = ".scale", roles = "parameter"))

  op <- op %>%
    dplyr::bind_rows(
      dplyr::tibble(module = "temporal", step = "aggregate", var = as.character(expr),
                    res = new_name)
      )

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("idx_tbl", class(res))
  return(res)

}

globalVariables(c(".scale", ".agg"))


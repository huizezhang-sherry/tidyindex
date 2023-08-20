#' The normalising module
#'
#' @param .data an index table object
#' @param .var the variable to normalise
#' @param .new_name character, the new variable name after `augment`
#'
#' @return an index table object
#' @export
#'
#' @examples
#' library(lubridate)
#' library(lmomco)
#' tenterfield %>%
#'   init(id = id, time = ym, indicators = prcp:tavg) %>%
#'   aggregate(.var = prcp, .scale = 12) %>%
#'   dist_fit(.dist = gamma(), .method = "lmoms", .var = .agg) %>%
#'   augment(.var = .agg)
augment <-function(.data, .var = var, .new_name = ".index"){
  data <- .data
  var <- enquo(.var)
  dist <- as.list(eval(dist))
  new_name <- .new_name
  if (!inherits(data, "idx_tbl")) not_idx_tbl()

  id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
  index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
  op <- data$op
  method <- op %>% filter(module == "dist fit") %>% pull(step) %>% unique()
  dist <- op %>% filter(step == "dist fit", args == "dist") %>% pull(val)
  roles <- data$roles
  data <- data$data

  # TODO add if method is mle

  if (method == "lmoms"){
    res <- data %>% ungroup()

    if (any(data$.boot > 1)){
      res <- res %>% dplyr::nest_by(.period, !!id, .fit, .dist, .boot)
    } else{
      res <- res %>% dplyr::nest_by(.period, !!id, .fit, .dist)
    }
    res <- res %>%
      # msg to inform removing null fit
      filter(!is.null(.fit)) %>%
      mutate(
        expr = list(expr(list(tibble(
          .fitted =do.call(
            paste("cdf", .fit$type, sep = ""),
            list(data[[quo_name(var)]], .fit)))
        ))))
  }

  res <- res %>%
    mutate(fit = eval(expr)) %>%
    ungroup() %>%
    mutate(data = pmap(list(data, fit), cbind))

  if ("boot" %in% colnames(data)){
    res <- res %>% dplyr::select(.period, id, data, .dist, boot)
  } else{
    res <- res %>% dplyr::select(.period, id, data, .dist)
  }

  res <- res %>% tidyr::unnest(data)

  res <- res %>% mutate(!!new_name := qnorm(.fitted)) %>% dplyr::arrange(!!index)


  roles <- roles %>%
    filter(variables %in% names(res)) %>%
    dplyr::bind_rows(dplyr::tibble(variables = ".fitted", roles = "intermediate")) %>%
    dplyr::bind_rows(dplyr::tibble(variables = new_name, roles = "index"))

  op <- op %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "normalise", step = "augment", var = NA ,
      args = "cdf", val = NA, res = ".fitted"
    )) %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "normalise", step = "qnorm", var = "qnorm(.fitted)", res = ".index"
    ))

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("idx_tbl", class(res))
  return(res)

}


globalVariables(c(".period", ".fit", ".dist", "fit", ".fitted", "variables",
                  "step", "val", ".boot_agg", "boot", "month"))

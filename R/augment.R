#' Title
#'
#' @param data data
#' @param id id
#' @param date date
#' @param col col
#' @param gamma_adjust gamma_adjust
#'
#' @return asa
#' @export
#'
#' @examples
#' # add later
augment <-function(data, id = id, date = date, col = col, gamma_adjust =TRUE){
  dt_idx <- attr(data, "index")
  dt_id <- attr(data, "id")
  index <- if (!is.null(dt_idx)) dplyr::quo(!!sym(dt_idx)) else dplyr::enquo(dt_idx)
  id <- if (!is.null(dt_id)) dplyr::quo(!!sym(dt_id)) else dplyr::enquo(dt_id)
  col <- enquo(col)

  method <-  unique(data$.method)
  dist <- unique(data$.dist)

  # TODO add if method is mle

  if (method == "lmoms"){
    res <- data %>%
      dplyr::nest_by(.period, !!id, .fit, .dist) %>%
      mutate(
        expr = list(expr(list(tibble(
          .fitted =do.call(
            paste("cdf", .fit$type, sep = ""),
            list(data[[quo_name(col)]], .fit)))
        ))))
  }

  res <- res %>%
    mutate(fit = eval(expr)) %>%
    ungroup() %>%
    mutate(data = pmap(list(data, fit), cbind)) %>%
    dplyr::select(.period, id, data) %>%
    tidyr::unnest(data)

  res <- res %>% mutate(.index = qnorm(.fitted)) %>% dplyr::arrange(!!index)
  return(res)

}


globalVariables(c(".period", ".fit", ".dist", "fit", ".fitted"))

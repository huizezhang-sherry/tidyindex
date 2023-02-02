#' Title
#'
#' @param .data data
#' @param .var col
#' @param .gamma_adjust gamma_adjust
#' @param .new_name
#'
#' @return asa
#' @export
#'
#' @examples
#' # add later
augment <-function(.data, .var = var, .gamma_adjust =TRUE, .new_name = ".index"){
  data <- .data
  var <- enquo(.var)
  dist <- as.list(eval(dist))
  new_name <- .new_name
  if (inherits(data, "indri")){
    id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
    index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()

    op <- data$op
    method <- op %>% filter(step == "normalise", args == "method") %>% pull(val)
    dist <- op %>% filter(step == "normalise", args == "dist") %>% pull(val)

    roles <- data$roles
    data <- data$data
  } else{
    id <- enquo(id)
    index <- enquo(index)
  }

  # TODO add if method is mle

  if (method == "lmoms"){
    res <- data %>%
      dplyr::nest_by(.period, !!id, .fit, .dist) %>%
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
    mutate(data = pmap(list(data, fit), cbind)) %>%
    dplyr::select(.period, id, data, .dist) %>%
    tidyr::unnest(data)

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
      module = "normalise", step = "augment", var = "qnorm(.fitted)", res = ".index"
    ))

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}


globalVariables(c(".period", ".fit", ".dist", "fit", ".fitted", "variables", "step", "val"))

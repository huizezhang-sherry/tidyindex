#' Title
#'
#' @param data data
#' @param id id
#' @param date date
#' @param var col
#' @param gamma_adjust gamma_adjust
#'
#' @return asa
#' @export
#'
#' @examples
#' # add later
augment <-function(data, id = id, date = date, var = var, gamma_adjust =TRUE){

  var <- enquo(var)
  dist <- as.list(eval(dist))
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

  res <- res %>% mutate(.index = qnorm(.fitted)) %>% dplyr::arrange(!!index)

  roles <- roles %>%
    filter(variables %in% names(res)) %>%
    dplyr::bind_rows(dplyr::tibble(variables = ".fitted", roles = "intermediate")) %>%
    dplyr::bind_rows(dplyr::tibble(variables = ".index", roles = "index"))

  op <- op %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "normalise", step = "augment", var = ".fit",
      args = "cdf", val = NA, res = ".fitted"
    )) %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "normalise", step = "augment", var = ".fitted",
      args = "qnorm", val = NA, res = ".index"
    ))

  res <- list(data = res, roles = roles, op = op)
  class(res) <- c("indri", class(res))
  return(res)

}


globalVariables(c(".period", ".fit", ".dist", "fit", ".fitted", "variables", "step", "val"))

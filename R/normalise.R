#' Title
#'
#' @param data a data frame
#' @param dist distributions
#' @param gran granularity
#' @param date date
#' @param id id
#' @param col col
#' @param n_boot number of bootstrap samples, default to 1
#' @param boot_seed the seed of bootstrap sampling
#' @param method fitting methods, one of lmoms (L-moment), mle (Maximum Likelihood),
#' and mom (Method of moment)
#' @param gamma_adjust adjustment for gamma, add reference
#'
#' @return a data frame
#' @export
#'
#' @examples
#'# TODO: need to add examples
normalise <- function(data,
                      dist,
                      gran = "month",
                      date,
                      id,
                      col,
                      n_boot = 1,
                      boot_seed = 123,
                      method = "lmoms",
                      gamma_adjust = TRUE) {
  col <- enquo(col)
  index <-
    if (!is.null(attr(data, "index"))) {
      dplyr::quo(!!sym(attr(data, "index")))
    } else {
      dplyr::enquo(date)
    }
  id <-
    if (!is.null(attr(data, "id"))) {
      dplyr::quo(!!sym(attr(data, "id")))
    } else {
      dplyr::enquo(id)
    }
  dist <- as.list(eval(dist))

  ########################################
  # implementing bootstrap
  if (n_boot != 1) {
    # res <- bootstrap_aggregation(
    #   data =  data, col = col, date = date,
    #   n_boot = n_boot, boot_seed = boot_seed)
    # col <- syms("boot_agg")
  } else{
    res <- data %>% mutate(.boot = 1)
  }

  ########################################
  # estimate parameters
  if (method == "lmoms") {
    expr <- build_fit_expr(dist, col, method)
    # TODO: make sure lubridate is loaded to have gran = month work
    res <- res %>%
      group_by(.period = do.call(gran, list(!!index)), !!id, .boot) %>%
      mutate(!!!expr)
  }

  ########################################
  # to long form, always
  res <- res %>%
    to_long(cols = names(expr), names_to = "aaa", values_to = ".fit") %>%
    tidyr::separate("aaa", into = c(".dist", ".method"))
    if (n_boot == 1)
      res <- res %>% dplyr::select(-.boot)


    res <- res %>% ungroup()

    attr(res, "id") <- quo_name(id)
    attr(res, "index") <- quo_name(index)
    class(res) <- c("indri", class(res))

    return(res)
}

build_fit_expr <- function(dist, col, method) {

  dist <- map(dist, build_lmom_par_fun)
  method <- list(method)
  dt <-
    expand.grid(dist = dist,
                method = method,
                col = quo_name(col))

  expr <- purrr::map2(dt$dist, dt$method,
       ~ expr(list(do.call(!!!.x, list(do.call(!!!.y, list(!!col)))))))

  # WARNING: expr outputs a list of expressions to evaluate but names before is only one!
  names(expr) <- paste0(dt$dist, "-", dt$method)
  expr
}

globalVariables(".boot")

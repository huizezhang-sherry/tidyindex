#' The scaling module
#'
#' Specify either as an expression (like mutate) or using .method.
#'
#' When using .method, specifies the varaibles it applies to (`.vars`), can be multiple, use tidyselect syntax
#' additional parameters will be parsed from `...`
#' `.new_names` needs to be of same length as `.vars`
#'
#' @param data an index table object
#' @param .method the method use for rescaling, currently rescale_minmax, rescale_zscore, rescale_center
#' @param .vars variables to rescale
#' @param ... expression
#' @param .new_name the new name for the rescaled variable, optional
#' @param var variable, argument in the rescale_* functions
#' @param na.rm logical; whether to remove NAs,  argument in the rescale_* functions
#' @param min,max the minimum and maximum value used in rescale_minmax
#' @param censor logical; whether to censor points outside min and max, if provided
#' @rdname rescale
#' @export
#' @examples
#'
#' dt <- hdi %>% init(id = country, indicators = life_exp:gni_pc)
#' # only print out the operation table
#' show_summary <- function(obj) obj %>% .[["op"]]
#'
#' # single variable:
#' show_summary(dt %>% rescaling(life_exp = rescale_minmax(life_exp)))
#' show_summary(dt %>% rescaling(.method = rescale_minmax, .vars = life_exp, min = 20, max = 85))
#' show_summary(dt %>% rescaling(.method = rescale_minmax, .vars = life_exp, .new_name = "life_exp2"))
#'
#' # use tidyselect to apply the .method to multiple variables
#' show_summary(dt %>% rescaling(.method = rescale_minmax, .vars = life_exp:exp_sch))
#' # can also supply additional parameters
#' show_summary(dt %>% rescaling(.method = rescale_minmax,
#'                  .vars = life_exp:exp_sch,
#'                  min = c(20, 0), max = c(85, 18),
#'                  .new_name = c("life_exp2", "exp_sch")))
rescaling <- function(data, ..., .method = NULL, .vars = NULL, .new_name = NULL){
  dots <- enquos(...)
  .method <- enquo(.method)
  .vars <- enquo(.vars)
  new_name <- .new_name
  if (!inherits(data, "idx_tbl")) not_idx_tbl()

  id <- data$roles %>% filter(roles == "id") %>% pull(variables) %>% sym()
  if ("time" %in% data$roles$roles){
    index <- data$roles %>% filter(roles == "time") %>% pull(variables) %>% sym()
  }
  op <- data$op
  roles <- data$roles
  data <- data$data

  if (!rlang::quo_is_null(.method)){

    # dots will be evaluated - don't put `life_exp`...
    params <- map(dots, ~rlang::eval_tidy(rlang::quo_get_expr(.x), data = data)) %>% as.list()

    # if use `.vars` to apply the method to multiple variables
    if (!rlang::quo_is_null(.vars)){
      .vars <- tidyselect::eval_select(.vars, data) %>% names()
      first <- list(.vars)
      names(first) <- names(formals(get(quo_name(.method))))[[1]]
      params <- c(first, params)
    }

    # concatenate all the arguments into a string
    # i.e. "vars = life_exp, min = 0.000000, max = 5.000000"
    args <- purrr::map_chr(
      1:length(params[[1]]),
      function(ind) {paste0(names(params), " = ", purrr::map_chr(params, ~ .x[ind]), collapse = ", ")})

    # construct the expression to be evaluated in strings, i.e.
    # [[1]]
    # [1] "rescale_minmax(vars = life_exp, min = 0.000000, max = 5.000000)"
    exprs <- map(args, ~paste0(rlang::quo_get_expr(.method), "(", .x, ")"))
    dots <- map(exprs, ~quo(!!rlang::parse_expr(.x)))

    if (rlang::is_null(new_name)){ new_name <- .vars} else{
      if (length(new_name) !=  length(.vars)) cli::cli_abort(
        "When apply a method to multiple variables, {.code .new_name} should either be {.code NULL} or
      has the same length as {.code .var}")
    }

    names(dots) <- new_name
  }

  # where the actual evaluation takes place
  new_data <- data %>% dplyr::mutate(!!!dots)

  #sort out attributes to update roles and op
  if (rlang::quo_is_null(.method)){
    dots <- purrr::map_chr(dots, ~rlang::quo_get_expr(.x) %>% deparse)
    step <- "formula"
    new_name <- names(dots)
  } else{
    step <- rlang::quo_get_expr(.method) %>% deparse()
    dots <- purrr::map_chr(dots, ~rlang::quo_get_expr(.x) %>% deparse())
  }

  roles <- roles %>%
    dplyr::bind_rows(dplyr::tibble(variables = new_name, roles = "intermediate"))

  op <- op %>%
    dplyr::bind_rows(dplyr::tibble(
      module = "rescaling", step = step,
      var = dots, res = new_name
    ))

  res <- list(data = new_data, roles = roles, op = op)
  class(res) <- c("idx_tbl", class(res))
  return(res)

}


#' @export
#' @rdname rescale
rescale_zscore <- function(var, na.rm = TRUE){

  (var - mean(var, na.rm = na.rm))/ sd(var, na.rm = na.rm)
}

#' @export
#' @rdname rescale
rescale_minmax <- function(var, min = NULL, max  = NULL, na.rm = TRUE, censor = TRUE){

  if (is.null(min)) min <- min(var, na.rm = na.rm)
  if (is.null(max)) max <- max(var, na.rm = na.rm)

  res <- (var - min)/diff(c(min, max))

  if (censor){
    res[res > 1] <- 1
    res[res < 0] <- 0
  }

  res
}

#' @export
#' @rdname rescale
rescale_center <- function(var, na.rm = TRUE){
  var - mean(var, na.rm = na.rm)
}


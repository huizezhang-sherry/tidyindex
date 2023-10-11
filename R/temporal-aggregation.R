#' The temporal processing module
#'
#' The temporal processing module is used to aggregate data along the temporal
#' dimension. Current available aggregation recipe includes
#'  \code{temporal_rolling_window}.
#'
#' @param data an index table object, see [tidyindex::init()]
#' @param ... an temporal processing object of class \code{temporal_agg}
#'
#' @return an index table object
#' @importFrom slider slide_dbl
#' @rdname temporal-aggregate
#' @export
#' @examples
#' tenterfield |>
#'   init() |>
#'   temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12))
#'
#' # with multiple scales
#' tenterfield |>
#'   init() |>
#'   temporal_aggregate(temporal_rolling_window(prcp, scale = c(12, 24)))
temporal_aggregate <- function(data, ...){
  dot <- rlang::list2(...)
  dot_mn <- names(dot)
  if (inherits(dot[[1]], "list")) dot <- dot[[1]]

  check_idx_tbl(data)
  map(dot, check_temp_agg_obj)


  res <- purrr::map2(
    dot, names(dot),
    ~{data$data |> dplyr::transmute(!!.y := do.call(
    attr(.x, "fn"),
    c(attr(.x, "args"), var = attr(.x, "var"), scale = attr(.x, "scale"))
  ))
  })

  data$data <- data$data |> dplyr::bind_cols(purrr::reduce(res, cbind))

  if (inherits(dot, "list")){
    i <- 1
    name <- names(dot)
    for (i in seq_len(length(dot))){
      data$steps <- data$steps |>
        rbind(dplyr::tibble(
          id = nrow(data$steps) + 1,
          module = "temporal",
          op = dot[i],
          name = name[i]))
      i <- i + 1
    }

  }

  return(data)
}

#' @rdname temporal-aggregate
#' @export
temporal_rolling_window <- function(var, scale, .before = 0L, .step = 1L,
                                    .complete = FALSE, ...){
  fn <- function(var, scale, .before, .step, .complete, ...) {
    slider::slide_dbl(.x = var, .f = "sum", .before = scale - 1, ...)
  }

  if (length(scale) > 1){
    map(scale, ~{
      new_temporal_agg("rolling_window", var = enquo(var), fn, scale = .x,
                       .before = .before, .complete = .complete)
    }) |>
      rlang::set_names(paste0("rolling_window_", scale))
  } else{
    new_temporal_agg("rolling_window", var = enquo(var), fn, scale = scale,
                     .before = .before, .complete = .complete)
  }
}


new_temporal_agg <- function(type, var, fn, scale, ...){
  dots <- rlang::list2(...)
  name <- type
  attr(name, "var") <- var
  attr(name, "scale") <- scale
  attr(name, "fn") <- fn
  attr(name, "args") <- dots
  class(name) <- "temporal_agg"
  name
}


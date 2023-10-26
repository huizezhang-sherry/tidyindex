#' Misc functions used for computing drought indexes
#'
#' @param var the variable to be transformed, see [tidyindex::variable_trans()]
#' and [SPEI::thornthwaite()]
#' @param lat,na.rm,verbose see [SPEI::thornthwaite]
#' @rdname drought-idx
#' @examples
#' tenterfield |>
#'   init() |>
#'   variable_trans(pet = trans_thornthwaite(tavg, lat = -29))
#'
trans_thornthwaite <- function(var, lat, na.rm = FALSE, verbose = TRUE){
  lat <- enquo(lat) |> rlang::quo_get_expr()
  if (! rlang::is_symbol(lat)){
    lat <- eval(lat)
  }

  if (!requireNamespace("SPEI", quietly = TRUE)){
    stop("SPEI package is required for computing Thornthwaite PET") # nocov
  }

  fn <- function(var, lat, na.rm = FALSE, verbose = TRUE){
    SPEI::thornthwaite(
      Tave = var, lat = unique(lat), na.rm = na.rm, verbose = verbose
    ) |>
      unclass() |> as.vector()
  }

  new_trans("trans_thornthwaite", var = enquo(var), fn = fn, lat = lat)
}

#' @export
#' @rdname drought-idx
idx_spi <- function(data, .dist = "gamma", .scale = 12){

  check_idx_tbl(data)
  dist_fn <- as.character(substitute(.dist))
  check_dist_fit_obj(do.call(dist_fn, list()))

  data |>
    temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = .scale)) |>
    distribution_fit(.fit = do.call(dist_fn, list(var = ".agg", method = "lmoms")))|>
    normalise(index = norm_quantile(.fit))
}

#' @export
#' @rdname drought-idx
idx_spei <- function(data, id, time, .pet_method = "thornthwaite", .tavg, .lat, .scale = 12, .dist = loglogistic(), .new_name = ".index"){
  tavg <- enquo(.tavg)
  lat <- enquo(.lat)
  check_idx_tbl(data)
  data |>
    var_trans(.method = !!.pet_method, .vars = tavg, lat = lat, .new_name = "pet") |>
    #var_trans(.method = .pet_method, .tavg = !!tavg, .lat = !!lat, .new_name = "pet") |>
    dimension_reduction(diff = aggregate_manual(~prcp - pet)) |>
    aggregate(.var = diff, .scale = .scale) |>
    dist_fit(.dist = .dist, .method = "lmoms", .var = .agg) |>
    augment(.var = .agg, .new_name = .new_name)
}


#' @export
#' @rdname drought-idx
idx_rdi <- function(data, id, time, .pet_method = "thornthwaite", .scale = .scale, .new_name = ".index"){

  check_idx_tbl(data)
  data |>
    var_trans(method = .pet_method, .vars = tavg, lat = lat, .new_name = "pet") |>
    dimension_reduction(r = aggregate_manual(~prcp/pet)) |>
    aggregate(.var = r, .scale = .scale) |>
    var_trans(y = log10(.agg),
              {.new_name} := rescale_zscore(y))
}

#' @export
#' @rdname drought-idx
idx_edi <- function(data, id, time, .scale = 12, .new_name = ".index"){

  check_idx_tbl(data)
  data |>
    dimension_reduction(
      mult = aggregate_manual(~prcp *rev(digamma(dplyr::row_number() + 1) - digamma(1)))
    ) |>
    aggregate(.var = mult, .scale = .scale, sum, .new_name = "ep") |>
    var_trans(.method = rescale_zscore, .vars = ep, .new_name = .new_name)
}



globalVariables(c("prcp", "w", "mult", "ep", "tavg", "pet", "r", "y", "lat"))



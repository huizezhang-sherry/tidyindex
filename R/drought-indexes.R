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

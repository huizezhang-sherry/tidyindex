#' Misc functions used for computing drought indexes
#'
#' @param var the variable to be transformed, see [tidyindex::variable_trans()]
#' @rdname drought-idx
trans_thornthwaite <- function(var, lat, na.rm = FALSE, verbose = TRUE){
  lat <- enquo(lat) |> rlang::quo_get_expr()
  if (! rlang::is_symbol(lat)){
    lat <- eval(lat)
  }

  fn <- function(var, lat, na.rm = FALSE, verbose = TRUE){
    SPEI::thornthwaite(
      Tave = var, lat = unique(lat), na.rm = na.rm, verbose = verbose
    ) |>
      unclass() |> as.vector()
  }

  new_trans("trans_thornthwaite", var = enquo(var), fn = fn, lat = lat)
}

#' Calculating PET
#'
#' @param data the data
#' @param method method to calculate PET
#' @param id the site identifier
#' @param ... the variable to use
#'
#' @return a data frame with the variable pet calculated
#' @export
#'
#' @examples
#' if (require(SPEI, quietly = TRUE)){
#' tenterfield %>%
#'   calc_pet(method = "thornthwaite", id = id, Tave = tavg, lat = -29.0479)
#' }
calc_pet <- function(data, method, id = id, ...){

  id <- enquo(id)
  dots <- enquos(...)
  data %>%
    group_by(!!id) %>%
    mutate(pet = as.vector(do.call(method, list(!!!dots)))) %>%
    ungroup()
}


#' Pre-built indexes
#'
#' @param data data
#' @param id id
#' @param time time
#' @param pet_method PET method
#' @param .scale scale
#' @param dist distribution
#'
#' @return calculated indexes
#' @export
#' @rdname indexes
#'
#' @examples
#' library(lmomco)
#' library(lubridate)
#' library(SPEI)
#' tenterfield %>% idx_spi(id = id, time = ym, dist = list(gev(), loglogistic()))
#' tenterfield %>% idx_spei(id = id, time = ym)
#' tenterfield %>% idx_edi(id = id, time = ym, .scale = 12)
idx_spei <- function(data, id, time, pet_method = "thornthwaite", .scale = 12,  dist = loglogistic()){
  id <- enquo(id)
  time <- enquo(time)

  data %>%
    init(id = !!id, time = !!time) %>%
    var_trans(.method = pet_method, Tave = tavg, lat = -29.0479, .new_name = "pet") %>%
    dim_red(diff = prcp - pet) %>%
    aggregate(.var = diff, .scale = .scale) %>%
    dist_fit(.dist = dist, .method = "lmoms", .var = .agg) %>%
    augment(.var = .agg)
}

#' @export
#' @rdname indexes
idx_spi <- function(data, id, time, dist = gamma(), .scale = 12){
  id <- enquo(id)
  time <- enquo(time)

  data %>%
    init(id = !!id, time = !!time) %>%
    aggregate(.var = prcp, .scale = .scale) %>%
    dist_fit(.dist = dist, .method = "lmoms", .var = .agg) %>%
    augment(.var = .agg)
}

#' @export
#' @rdname indexes
idx_rdi <- function(data, id, time, pet_method = "thornthwaite", .scale = .scale){
  id <- enquo(id)
  time <- enquo(time)
  data %>%
    init(id = !!id, time = !!time) %>%
    var_trans(method = pet_method, Tave = tavg, lat = -29.0479, new_name = "pet") %>%
    dim_red(expr = prcp/ pet, new_name = "r") %>%
    aggregate(.var = r, .scale = .scale) %>%
    var_trans(y = log10(.agg),
              index = rescale_zscore(y))
}

#' @export
#' @rdname indexes
idx_edi <- function(data, id, time, .scale = .scale){
  id <- enquo(id)
  time <- enquo(time)
  data %>%
    init(id = !!id, time = !!time) %>%
    var_trans(w = rev(digamma(dplyr::row_number() + 1) - digamma(1)),
              mult = prcp * w) %>%
    aggregate(.var = mult, .scale = .scale, sum, .new_name = "ep") %>%
    var_trans(index = rescale_zscore(ep))
}



globalVariables(c("prcp", "w", "mult", "ep", "tavg", "pet", "r", "y"))



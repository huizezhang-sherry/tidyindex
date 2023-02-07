#' Pre-built indexes
#'
#' @param data data
#' @param id id
#' @param time time
#' @param .pet_method PET method
#' @param .tavg average temperature
#' @param .lat latitude
#' @param .scale scale
#' @param .dist distribution
#' @param .new_name new names
#'
#' @return calculated indexes
#' @export
#' @rdname indexes
#'
#' @examples
#' library(lmomco)
#' library(lubridate)
#' tenterfield %>% init(id = id, time = ym) %>%
#'    idx_spei(.tavg = tavg, .lat = lat)
#' tenterfield %>% init(id = id, time = ym) %>% idx_spi()
#' tenterfield %>% init(id = id, time = ym) %>% idx_edi()
idx_spei <- function(data, id, time, .pet_method = "thornthwaite", .tavg, .lat, .scale = 12, .dist = loglogistic(), .new_name = ".index"){

  tavg <- enquo(.tavg)
  lat <- enquo(.lat)
  if (!inherits(data, "indri")) not_indri()
  data %>%
    var_trans(.method = .pet_method, .tavg = !!tavg, .lat = !!lat, .new_name = "pet") %>%
    dim_red(diff = prcp - pet) %>%
    aggregate(.var = diff, .scale = .scale) %>%
    dist_fit(.dist = .dist, .method = "lmoms", .var = .agg) %>%
    augment(.var = .agg, .new_name = .new_name)
}

#' @export
#' @rdname indexes
idx_spi <- function(data, id, time, .dist = gamma(), .scale = 12, .new_name = ".index"){

  if (!inherits(data, "indri")) not_indri()
  data %>%
    aggregate(.var = prcp, .scale = .scale)%>%
    dist_fit(.dist = .dist, .method = "lmoms", .var = .agg) %>%
    augment(.var = .agg, .new_name  = .new_name)
}

#' @export
#' @rdname indexes
idx_rdi <- function(data, id, time, .pet_method = "thornthwaite", .scale = .scale, .new_name = ".index"){

  if (!inherits(data, "indri")) not_indri()
  data %>%
    var_trans(method = .pet_method, Tave = tavg, lat = -29.0479, new_name = "pet") %>%
    dim_red(expr = prcp/ pet, new_name = "r") %>%
    aggregate(.var = r, .scale = .scale) %>%
    var_trans(y = log10(.agg),
              {.new_name} := rescale_zscore(y))
}

#' @export
#' @rdname indexes
idx_edi <- function(data, id, time, .scale = 12, .new_name = ".index"){

  if (!inherits(data, "indri")) not_indri()
  data %>%
    var_trans(w = rev(digamma(dplyr::row_number() + 1) - digamma(1)),
              mult = prcp * w) %>%
    aggregate(.var = mult, .scale = .scale, sum, .new_name = "ep") %>%
    var_trans(.method = rescale_zscore, var = ep, .new_name = .new_name)
}



globalVariables(c("prcp", "w", "mult", "ep", "tavg", "pet", "r", "y"))



## code to prepare `tenterfield` dataset goes here
library(rnoaa)
library(tidyverse)

get_climate <- function(monitor){
  meteo_pull_monitors(
    monitors = monitor, var = c("PRCP", "TMAX", "TMIN"),
    date_min = glue::glue("1990-01-01"),
    date_max = glue::glue("2020-12-31")
  ) %>%
    mutate(ym = tsibble::yearmonth(date)) %>%
    group_by(id, ym) %>%
    summarise(prcp = sum(prcp, na.rm =TRUE),
              tmax = mean(tmax/10, na.rm = TRUE),
              tmin = mean(tmin/10, na.rm = TRUE),
              tavg = mean((tmax + tmin)/2,  na.rm = TRUE)) %>%
    ungroup()
}
ids <- list(weatherdata::historical_prcp$id,
            weatherdata::historical_tmax$id,
            weatherdata::historical_tmin$id)
good_ids <- reduce(ids, intersect)
station_meta <- weatherdata::all_stations %>% filter(id %in% good_ids) %>% distinct(id, long, lat, name)
tenterfield <- get_climate("ASN00056032") %>%
  left_join(station_meta %>% filter(id == "ASN00056032"))
usethis::use_data(tenterfield, overwrite = TRUE)

##################################################################################

raw <- map_dfr(good_ids, get_climate)
climate_raw <- raw %>% left_join(station_meta)
bad <- climate_raw %>% filter(is.na(tmax) | is.na(tmin)) %>% group_by(id) %>% count()
aus_climate <- climate_raw %>% filter(!id %in% bad$id)
usethis::use_data(aus_climate, overwrite = TRUE)

# library(ozmaps)
# ozmaps::abs_ste %>%
#   rmapshaper::ms_simplify(keep = 0.05) %>%
#   ggplot() +
#   geom_sf() +
#   geom_point(data = aus_climate %>% filter(ym == tsibble::make_yearmonth(1990,1)),
#              aes(x = long, y = lat))


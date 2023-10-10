## code to prepare `tenterfield` dataset goes here
library(rnoaa)
library(tidyverse)

get_climate <- function(monitor){
  meteo_pull_monitors(
    monitors = monitor, var = c("PRCP", "TMAX", "TMIN"),
    date_min = glue::glue("1990-01-01"),
    date_max = glue::glue("2020-12-31")
  ) |>
    mutate(ym = tsibble::yearmonth(date)) |>
    group_by(id, ym) |>
    summarise(prcp = sum(prcp, na.rm =TRUE),
              tmax = mean(tmax/10, na.rm = TRUE),
              tmin = mean(tmin/10, na.rm = TRUE),
              tavg = mean((tmax + tmin)/2,  na.rm = TRUE)) |>
    ungroup()
}
ids <- list(weatherdata::historical_prcp$id,
            weatherdata::historical_tmax$id,
            weatherdata::historical_tmin$id)
good_ids <- reduce(ids, intersect)
station_meta <- weatherdata::all_stations |> filter(id %in% good_ids) |> distinct(id, long, lat, name)
tenterfield <- get_climate("ASN00056032") |>
  left_join(station_meta |> filter(id == "ASN00056032"))
usethis::use_data(tenterfield, overwrite = TRUE)

##################################################################################

raw <- map_dfr(good_ids, get_climate)
climate_raw <- raw |> left_join(station_meta)
bad <- climate_raw |> filter(is.na(tmax) | is.na(tmin)) |> group_by(id) |> count()
aus_climate <- climate_raw |> filter(!id %in% bad$id)
usethis::use_data(aus_climate, overwrite = TRUE)

# library(ozmaps)
# ozmaps::abs_ste |>
#   rmapshaper::ms_simplify(keep = 0.05) |>
#   ggplot() +
#   geom_sf() +
#   geom_point(data = aus_climate |> filter(ym == tsibble::make_yearmonth(1990,1)),
#              aes(x = long, y = lat))

##################################################################################
stations <- rnoaa::ghcnd_stations()
queensland_map <- ozmaps::abs_ste |> filter(NAME == "Queensland")
qstations<- stations |>
  filter(str_detect(id, "ASN")) |>
  filter(element %in% c("PRCP", "TMAX", "TMIN")) |>
  sf::st_as_sf(coords = c("longitude", "latitude"), crs = sf::st_crs(queensland), remove = FALSE) |>
  sf::st_filter(queensland_map) |>
  as_tibble()

all_three <- qstations |>
  filter(first_year <=  1990, last_year == 2022) |>
  count(id) |> filter(n == 3) |> pull(id)

good <- qstations |> filter(id %in% all_three)
queensland_map |>
  ggplot() +
  geom_sf(fill = "transparent") +
  geom_point(data = qstations |>
               distinct(id, longitude, latitude, element) |>
               filter(element == "PRCP", id %in% all_three),
             aes(x = longitude, y = latitude))

station_meta <- good |>
  select(id, longitude, latitude, name) |>
  distinct()

raw <-  station_meta |>
  meteo_pull_monitors(
    var = c("PRCP", "TMAX", "TMIN"),
    date_min = glue::glue("1990-01-01"),
    date_max = glue::glue("2022-04-30")
  )

queensland <- raw |>
  mutate(ym = tsibble::yearmonth(date)) |>
  group_by(id, ym) |>
  summarise(prcp = sum(prcp, na.rm =TRUE),
            tmax = mean(tmax/10, na.rm = TRUE),
            tmin = mean(tmin/10, na.rm = TRUE),
            tavg = mean((tmax + tmin)/2,  na.rm = TRUE)) |>
  ungroup() |>
  left_join(station_meta) |>
  rename(long = longitude, lat = latitude) |>
  # some stations that cause problems
  filter(!id %in% c("ASN00028004", "ASN00028004", "ASN00029126", "ASN00032004",
                    "ASN00038003", "ASN00039085", "ASN00039123", "ASN00039314",
                    "ASN00040068", "ASN00041095", "ASN00041175", "ASN00043020")) |>
  nest_by(id) |>
  filter(nrow(data) == 388) |> # 12 + 12 * 30 + 12 + 4 (1990 + 1991:2020 + 2021 +  2022) |>
  unnest(data) |>
  ungroup(id)
usethis::use_data(queensland, overwrite = TRUE)

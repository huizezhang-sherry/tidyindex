## code to prepare `tenterfield` dataset goes here
library(rnoaa)
library(tidyverse)

tenterfield <- meteo_pull_monitors(
  monitors = "ASN00056032", var = c("PRCP", "TMAX", "TMIN"),
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

usethis::use_data(tenterfield, overwrite = TRUE)

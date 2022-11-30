## code to prepare `tenterfield` dataset goes here
library(rnoaa)
library(tidyverse)

tenterfield <- meteo_pull_monitors(
  monitors = "ASN00056032", var = "PRCP",
  date_min = glue::glue("1990-01-01"),
  date_max = glue::glue("2020-12-31")
) %>%
  mutate(ym = tsibble::yearmonth(date)) %>%
  group_by(id, ym) %>%
  summarise(prcp = sum(prcp, na.rm =TRUE)) %>%
  ungroup()

usethis::use_data(tenterfield, overwrite = TRUE)

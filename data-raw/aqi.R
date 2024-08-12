## code to prepare `aqi` dataset goes here

# import necessary libraries
library(tidyverse)
library(tidyindex)
library(aqsr)

AQS_EMAIL = "YOUR_EMAIL"
AQS_KEY = "YOUR_KEY"
myuser <- create_user(email=AQS_EMAIL, key=AQS_KEY)

# get specific state, county and their ids
states_list <- aqs_list_states(myuser)
state <- "Texas"
state_id <- states_list$code[states_list$value_represented == state]
county_list <- aqs_list_counties(myuser, state_id)
county <- "Travis"
county_id <- county_list$code[county_list$value_represented == county]

# get specific pollutant id
pollutant_list <- aqs_list_parameters(myuser, pc="CRITERIA")
pollutant <- "PM2.5 - Local Conditions"
pollutant_id <- pollutant_list$code[pollutant_list$value_represented == pollutant]

# set begin and end date, then sample data
endpoint <- "byCounty"
begin_date <- "20240101"
end_date <- "20240331"

aqi_daily <- aqs_dailyData(aqs_user=myuser,
                           endpoint=endpoint,
                           state=state_id,
                           county=county_id,
                           bdate=begin_date,
                           edate=end_date,
                           param=pollutant_id) |> tibble::as_tibble()

#distinct(aqi_daily, pollutant_standard)

standards <- c(
  "Ozone"="Ozone 8-hour 2015",
  "Sulfur dioxide"="SO2 1-hour 2010",
  "Carbon monoxide"="CO 8-hour 1971",
  "Nitrogen dioxide (NO2)"="NO2 1-hour 2010",
  "PM2.5 - Local Conditions"="PM25 24-hour 2024",
  "PM10 Total 0-10um STP"="PM10 24-hour 2006"
)

aqi_travis <- filter(aqi_daily, pollutant_standard == standards[pollutant])

aqi_travis <- rename(aqi_travis, sample_measurement = arithmetic_mean)

aqi <- aqi_travis %>%
  dplyr::select(parameter, parameter_code, date_local, sample_measurement,
                aqi, longitude, latitude, site_number, local_site_name)
colnames(aqi) <- c("pollutant", "code", "date", "value", "aqi",
                   "long", "lat", "site_code", "site_name")
aqi <- aqi |> mutate(pollutant = "PM2.5", code = as.numeric(code),
                     date = as.Date(date), site_code = as.numeric(site_code))
usethis::use_data(aqi, overwrite = TRUE)

###############################################################################
###############################################################################

pollutant_table <- tibble(
  "pollutant" = character(),
  "pollutant_code" = character(),
  "low_breakpoint" = numeric(),
  "high_breakpoint"= numeric(),
  "group" = character())
pollutant_list <- c("Ozone", "PM2.5", "PM10", "CO", "SO2", "NO2")
code <- c("44201", "88101", "81102", "42101", "42401", "42602")
groups <- c("Good", "Moderate", "Unthealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy") |>
  rev()
low <- list("44201" = c(0, 0.055, 0.071, 0.086, 0.106),
            "88101" = c(0, 9.1, 35.5, 55.5, 125.5),
            "81102" = c(0, 55, 155, 255, 355),
            "42101" = c(0, 4.5, 9.5, 12.5, 15.5),
            "42401" = c(0, 36, 76, 186, 305),
            "42602" = c(0, 54, 101, 361, 650)) |>
  as_tibble() |>
  bind_cols(group = groups) |>
  pivot_longer(-group, names_to = "code", values_to = "low")

high <- list("44201" = c(0.054, 0.070, 0.085, 0.105, 0.2),
             "88101" = c(9, 35.4, 55.4, 125.4, 225.4),
             "81102" = c(54, 154, 254, 354, 424),
             "42101" = c(4.4, 9.4, 12.4, 15.4, 30.4),
             "42401" = c(35, 75, 185, 304, 604),
             "42602" = c(53, 100, 360, 649, 1249)) |>
  as_tibble() |>
  bind_cols(group = groups) |>
  pivot_longer(-group, names_to = "code", values_to = "high")



pollutant_ref_tbl <- tibble(pollutant = pollutant_list, code = code) |>
  crossing(group = groups) |>
  left_join(low, by = c("code", "group")) |>
  left_join(high, by = c("code", "group")) |>
  mutate(code = as.numeric(code))
usethis::use_data(pollutant_ref_tbl, overwrite = TRUE)

###############################################################################
###############################################################################
aqi_ref_tbl <- tibble(
  group = c("Good", "Moderate", "Unthealthy for Sensitive Groups",
            "Unhealthy", "Very Unhealthy"),
  low = c(0, 51, 101, 151, 201),
  high = c(50, 100, 150, 200, 300)
)
usethis::use_data(aqi_ref_tbl, overwrite = TRUE)

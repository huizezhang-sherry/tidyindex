## code to prepare `aqi` dataset goes here

# import necessary libraries
library(tidyverse)
library(tidyindex)
library(aqsr)

AQS_EMAIL = "walter.wang@utexas.edu"
AQS_KEY = "orangehawk17"
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

usethis::use_data(aqi_travis, overwrite = TRUE)

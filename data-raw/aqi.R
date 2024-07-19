## code to prepare `aqi` dataset goes here
library(aqsr)
library(tidyverse)
AQS_EMAIL="walter.wang@utexas.edu"
AQS_KEY="orangehawk17"
myuser <- create_user(email=AQS_EMAIL, key=AQS_KEY)

# get specific state, county and their ids
states_list <- aqs_list_states(myuser)
state <- "New York"
state_id <- states_list$code[states_list$value_represented == state]
county_list <- aqs_list_counties(myuser, state_id)
county <- "Bronx"
county_id <- county_list$code[county_list$value_represented == county]

# get specific pollutant id
pollutant_list <- aqs_list_parameters(myuser, pc="CRITERIA")
pollutant <- "PM2.5 - Local Conditions"
pollutant_id <- pollutant_list$code[pollutant_list$value_represented == pollutant]

# set begin and end date, then sample data
endpoint <- "byCounty"
begin_date <- "20230601"
end_date <- "20230630"
aqi <- aqs_sampleData(aqs_user=myuser,
                         endpoint=endpoint,
                         state=state_id,
                         county=county_id,
                         bdate=begin_date,
                         edate=end_date,
                         param=pollutant_id) |> tibble::as_tibble()
usethis::use_data(aqi, overwrite = TRUE)

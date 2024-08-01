library(tidyverse)
library(dplyr)
library(purrr)

aqi_dataset <- aqi_travis %>% dplyr::select(state, city, county, parameter, parameter_code, date_local, sample_measurement)
pipeline <- init(aqi)

lookup_helper <- function(sample, subset){
  return(subset %>% filter(sample >= low_breakpoint & sample <= high_breakpoint))
}

aqi_lookup <- function(dataset){
  # takes pollutant id (scalar) and current measurement of concentration (vector)
  # returns a tibble object with corresponding breakpoints and group info
  # aqi_table should be loaded from the environment
  id <- dataset$parameter_code[1]
  concentration <- dataset$sample_measurement
  if(id == "44201"){
    concentration <- trunc(concentration * 10^3)/10^3
  }
  else if (id == "88101" | id == "42101"){
    concentration <- trunc(concentration * 10)/10
  }
  else{
    concentration <- trunc(concentration)
  }
  subset <- pollutant_table %>% filter(pollutant_code == id)
  results <- map_dfr(concentration, ~ lookup_helper(.x, subset)) %>% left_join(aqi_table, "group")
  results$sample_measurement <- concentration
  return(results)
}

bps <- aqi_lookup(aqi_dataset)

pipeline <- bps %>% init() |> rescaling(minmax = rescale_minmax(sample_measurement,
                                       min=low_breakpoint,
                                       max=high_breakpoint))

pipeline <- pipeline |> variable_trans(AQI = trans_affine(minmax, a=AQI_high_breakpoint-AQI_low_breakpoint,
                                                          b=AQI_low_breakpoint))

# rewrite code - neater
# add comments?
# what is aqi - definition and importance
# talk about datasets
# how to build pipeline using tidy index
# 1combine 2initialize pipeline 3scale 4transform
# in 4 we introduce affine
# visualization




library(tidyverse)
library(dplyr)
library(purrr)

aqi <- aqi %>% dplyr::select(state_code, county_code, sample_measurement) %>%
  mutate(min_val = rnorm(1455), max_val = min_val + 100)
pipeline <- init(aqi)
min_vec <- rep(0, 1455)
max_vec <- aqi$sample_measurement
pipeline |> rescaling(sample_measurement = rescale_minmax(sample_measurement,
                                                          min=rep(0, 1455),
                                                          max=aqi$sample_measurement))

pipeline |> rescaling(sample_measurement2 = rescale_minmax(sample_measurement,
                                                          min=min_val,
                                                          max=max_val))

lookup_helper <- function(sample, subset){
  return(subset %>% filter(sample >= `Low Breakpoint` & sample <= `High Breakpoint`))
}

aqi_lookup <- function(id, concentration){
  # takes pollutant id (scalar) and current measurement of concentration (vector)
  # returns a tibble object with corresponding breakpoints and group info
  if(id == "44201"){
    concentration <- trunc(concentration * 10^3)/10^3
  }
  else if (id == "88101" | id == "42101"){
    concentration <- trunc(concentration * 10)/10
  }
  else{
    concentration <- trunc(concentration)
  }
  subset <- pollutant_table %>% filter(`Pollutant ID` == id)
  results <- map_dfr(concentration, ~ lookup_helper(.x, subset))
  return(results)
}

# TODO:
# rescale_minmax and trans_affine for vectors
# implement dataset for aqi check table
# write aqi index pipeline (in pseudocode)
#   - rescaling + transformation
# look up how to document a dataset


library(tidyindex)
library(dplyr)
library(purrr)
library(ggplot2)

# load dataset
aqi_dataset <- aqi_travis %>% dplyr::select(state, city, county, parameter, parameter_code, date_local, local_site_name, sample_measurement)

# helper functinos to lookup breakpoints
lookup_helper <- function(sample, subset){
  return(subset %>% filter(sample >= low_breakpoint & sample <= high_breakpoint))
}

aqi_lookup <- function(dataset){
  # takes the dataset of measurements as input
  # returns a tibble object with corresponding breakpoints and group info
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
  results$date <- dataset$date_local
  results$local_site_name <- dataset$local_site_name
  results$sample_measurement <- concentration
  return(results)
}

breakpoints <- aqi_lookup(aqi_dataset)

# initialize pipeline
pipeline <- init(breakpoints)

# perform minmax rescaling and affine transformation
pipeline <- pipeline |> rescaling(minmax = rescale_minmax(sample_measurement,
                                                          min=low_breakpoint,
                                                          max=high_breakpoint))

pipeline <- pipeline |> variable_trans(AQI = trans_affine(minmax,
                                                          a=AQI_high_breakpoint - AQI_low_breakpoint,
                                                          b=AQI_low_breakpoint))
pipeline$data$AQI <- round(pipeline$data$AQI)

# visualization
pipeline$data$date <- as.Date(pipeline$data$date)
ggplot(pipeline$data, aes(x = date, y = AQI, color = local_site_name)) +
  geom_line() +
  labs(title = "AQI Values Over Time by Site",
       x = "Date",
       y = "AQI",
       color = "Monitor Sites") +
  theme_minimal() +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




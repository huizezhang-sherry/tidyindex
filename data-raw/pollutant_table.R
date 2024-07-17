library(tidyverse)
pollutant_table <- tibble(
                "Pollutant Name" = character(),
                "Pollutant ID" = character(),
                "Low Breakpoint" = numeric(),
                "High Breakpoint"= numeric(),
                "Group" = character())
pollutant_list <- c("Ozone", "PM2.5 - Local Conditions", "PM10 Total 0-10um STP", "Carbon monoxide", "Sulfur dioxide", "Nitrogen dioxide (NO2)")
ids <- c("44201", "88101", "81102", "42101", "42401", "42602")

low <- list("44201" = c(0, 0.055, 0.071, 0.086, 0.106),
           "88101" = c(0, 9.1, 35.5, 55.5, 125.5),
           "81102" = c(0, 55, 155, 255, 355),
           "42101" = c(0, 4.5, 9.5, 12.5, 15.5),
           "42401" = c(0, 36, 76, 186, 305),
           "42602" = c(0, 54, 101, 361, 650))

high <- list("44201" = c(0.054, 0.070, 0.085, 0.105, 0.2),
            "88101" = c(9, 35.4, 55.4, 125.4, 225.4),
            "81102" = c(54, 154, 254, 354, 424),
            "42101" = c(4.4, 9.4, 12.4, 15.4, 30.4),
            "42401" = c(35, 75, 185, 304, 604),
            "42602" = c(53, 100, 360, 649, 1249))

groups <- c("Good", "Moderate", "Unthealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy")

for (i in 1:length(ids)){
  for (j in 1:length(groups)){
    pollutant_table <- pollutant_table %>% add_row(
                      "Pollutant Name" = pollutant_list[i],
                      "Pollutant ID" = ids[i],
                      "Low Breakpoint" = low[[i]][j],
                      "High Breakpoint" = high[[i]][j],
                      "Group" = groups[j])
  }
}
usethis::use_data(pollutant_table, overwrite = TRUE)

library(tidyverse)

aqi_table <- tibble("AQI Low Breakpoint" = numeric(),
                    "AQI High Breakpoint" = numeric(),
                    "Group" = character())
groups <- c("Good", "Moderate", "Unthealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy")
low <- c(0, 51, 101, 151, 201)
high <- c(50, 100, 150, 200, 300)

for (i in 1:length(groups)){
  aqi_table <- aqi_table %>% add_row("AQI Low Breakpoint" = low[i],
                                     "AQI High Breakpoint" = high[i],
                                     "Group" = groups[i])
}

usethis::use_data(aqi_table, overwrite = TRUE)

library(tidyverse)

aqi_table <- tibble("AQI_low_breakpoint" = numeric(),
                    "AQI_high_breakpoint" = numeric(),
                    "group" = character())
groups <- c("Good", "Moderate", "Unthealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy")
low <- c(0, 51, 101, 151, 201)
high <- c(50, 100, 150, 200, 300)

for (i in 1:length(groups)){
  aqi_table <- aqi_table %>% add_row("AQI_low_breakpoint" = low[i],
                                     "AQI_high_breakpoint" = high[i],
                                     "group" = groups[i])
}

usethis::use_data(aqi_table, overwrite = TRUE)

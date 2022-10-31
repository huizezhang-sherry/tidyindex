to_long <- function(data, cols, names_to, values_to, ...){
  data %>%
    pivot_longer(cols = cols, names_to = names_to, values_to = values_to, ...)
}

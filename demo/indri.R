library(lubridate)
library(lmomco)

# work
(res <- tenterfield %>%
  aggregate(var = prcp, scale = 12, index = ym, id = id) %>%
  # need to load package lubridate and lmomco
  normalise(dist = gamma(), method = "lmoms", var = prcp))

# work
(res <- tenterfield %>%
  aggregate(var = prcp, scale = 12, index = ym, id = id) %>%
  normalise(dist = list(gamma(), loglogistic()), method = "lmoms", var = prcp))


(res <- tenterfield %>%
    aggregate(var = prcp, scale = 12, index = ym, id = id) %>%
    filter(!is.na(.agg)) %>%
    normalise(dist = gamma(), method = "lmoms", var = .agg) %>%
    augment(col = .agg))


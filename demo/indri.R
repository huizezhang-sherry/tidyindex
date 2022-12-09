# work
res <- tenterfield %>%
  aggregate(var = prcp, scale = 12, index = ym, id = id) %>%
  # need to load package lubridate and lmomco
  normalise(dist = gamma(), method = "lmoms", col = prcp)

# testing
res <- tenterfield %>%
  aggregate(var = prcp, scale = 12, index = ym, id = id) %>%
  normalise(dist = list(gamma(), loglogistic()), method = "lmoms", col = prcp)

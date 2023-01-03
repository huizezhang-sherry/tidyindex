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
    normalise(dist = gamma(), method = "lmoms", var = .agg) %>%
    augment(col = .agg))

# calculating SPEI using different methods on PET
# there is also the penman method, which requires monthly mean daily wind speed at 2m height
library(SPEI)
(stations <- ghcnd_stations())
tent_lat <- stations %>% filter(id == "ASN00056032") %>% pull(latitude) %>% unique()
res2 <- tenterfield %>%
  calc_pet(method = "thornthwaite", id = id, Tave = tavg, lat = -29.0479) %>%
  mutate(d = prcp - pet) %>%
  aggregate(var = d, scale = 12, index = ym, id = id) %>%
  normalise(dist = loglogistic(), method = "lmoms", var = .agg) %>%
  augment(col = .agg)

res3 <- tenterfield %>%
    calc_pet(method = "hargreaves", id = id, Tmin = tmin, Tmax = tmax, lat = -29.0479) %>%
    mutate(d = prcp - pet) %>%
    aggregate(var = d, scale = 12, index = ym, id = id) %>%
    normalise(dist = loglogistic(), method = "lmoms", var = .agg) %>%
    augment(col = .agg)

res %>%
  ggplot(aes(x = ym, y = .index, id = id)) +
  geom_line() +
  geom_line(data = res2, color = "red")




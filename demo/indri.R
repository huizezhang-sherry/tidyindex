library(lubridate)
library(lmomco)
library(SPEI)

# work
(res <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp:tavg) %>%
  aggregate(var = prcp, scale = 12) %>%
  # need to load package lubridate and lmomco
  normalise(dist = gamma(), method = "lmoms", var = .agg))

# work
(res <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp:tavg) %>%
  aggregate(var = prcp, scale = c(6, 12)) %>%
  normalise(dist = list(gamma(), loglogistic()), method = "lmoms", var = .agg))

(res <- tenterfield %>%
    init(id = id, time = ym, indicators = prcp:tavg) %>%
    aggregate(var = prcp, scale = 12) %>%
    normalise(dist = gamma(), method = "lmoms", var = .agg) %>%
    augment(var = .agg))

# calculating SPEI using different methods on PET
# there is also the penman method, which requires monthly mean daily wind speed at 2m height
library(SPEI)
(stations <- ghcnd_stations())
tent_lat <- stations %>% filter(id == "ASN00056032") %>% pull(latitude) %>% unique()
res2 <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp) %>%
  calc_pet(method = "thornthwaite", Tave = tavg, lat = -29.0479) %>%
  dim_red(expr = prcp - .pet, new_name = "d") %>%
  aggregate(var = d, scale = 12) %>%
  normalise(dist = loglogistic(), method = "lmoms", var = .agg) %>%
  augment(var = .agg)

res3 <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp) %>%
  calc_pet(method = "hargreaves",Tmin = tmin, Tmax = tmax, lat = -29.0479) %>%
  dim_red(expr = prcp - pet, new_name = "d") %>%
  aggregate(var = d, scale = 12, index = ym, id = id) %>%
  normalise(dist = loglogistic(), method = "lmoms", var = .agg) %>%
  augment(var = .agg)

res %>%
  ggplot(aes(x = ym, y = .index, id = id)) +
  geom_line() +
  geom_line(data = res3, color = "red") +
  theme_benchmark()

#######################################################################################
# Reconnaissance Drought Index (RDI)
res3 <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp) %>%
  calc_pet(method = "thornthwaite", id = id, Tave = tavg, lat = -29.0479) %>%
  dim_red(expr = prcp/ pet, new_name = "r") %>%
  aggregate(var = r, scale = 12) %>%
  mutate(y = log(.agg, base = 10),
         .index = (y - mean(y))/sd(y))

# Effective Drought Index (EDI) - for daily data
w <- map_dbl(1: 12, ~digamma(.x + 1) - digamma(1)) %>% rev()
out <- tenterfield %>%
  mutate(ep = slider::slide_dbl(prcp, ~sum(.x * w))) %>%
  mutate(ep_norm = (ep - mean(ep))/ sd(ep))


out %>%
  ggplot(aes(x = ym, y = ep_norm)) +
  geom_line()


#######################################################################################



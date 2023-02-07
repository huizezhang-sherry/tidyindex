library(lmomco)
library(lubridate)
library(SPEI)
library(tsibble)
library(indri)
# single station
res <- tenterfield %>%
  init(id = id, time = ym) %>%
  compute_indexes(
    spi = idx_spi(.scale = 1:36),
    spei = idx_spei(.scale = 1:36,.pet_method = "thornthwaite" ,.tavg = tavg, .lat = lat),
    edi = idx_edi()
  )

res %>%
  ggplot(aes(x = ym, y = .index, color = .scale, group = .scale)) +
  geom_point(size = 0.3) +
  facet_wrap(vars(.idx), ncol = 1) +
  theme_benchmark()


res <- aus_climate %>%
  init(id = id, time = ym) %>%
  compute_indexes(
    spei = idx_spei(.pet_method = "thornthwaite", .tavg = tavg, .lat = lat),
    spi = idx_spi()
  )

# bad!
res %>%
  ggplot(aes(x = ym, y = .index, group = id)) +
  geom_line() +
  facet_wrap(vars(.idx), ncol = 1)



res <- tenterfield %>%
  init(id = id, time = ym) %>%
  compute_indexes(
    spi = idx_spi(.dist = loglogistic()),
    spei = idx_spei(.pet_method = "thornthwaite" ,.tavg = tavg, .lat = lat),
    edi = idx_edi()
  )

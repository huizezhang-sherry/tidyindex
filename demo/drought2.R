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
# TODO: maybe only one station and multiple .scale, index, .dist to compare?

# multiple stations

map_dt <- ozmaps::abs_ste %>%
  filter(NAME %in% c("New South Wales", "Victoria", "Queensland")) %>%
  rmapshaper::ms_simplify(keep = 0.01)

climate_dt <- aus_climate %>%
  sf::st_as_sf(coords = c("long", "lat"), crs = sf::st_crs(map_dt), remove = FALSE) %>%
  sf::st_filter(map_dt) %>%
  as_tibble() %>%
  # missing from 1993 - 2005
  filter(!id == "ASN00039104") %>%
  # wired Inf with SPEI
  filter(!id == "ASN00047016") %>%
  # they also ahve wired SPEI -Inf - some irresponsible science!
  filter(!id %in% c("ASN00049002", "ASN00040126", "ASN00047019", "ASN00076031", "ASN00076064", "ASN00044010", "ASN00035070")) %>%
  # they also ahve wired SPEI -Inf - some irresponsible science!
  filter(!id %in% c("ASN00037010", "ASN00029127", "ASN00031011"))

map_dt %>%
  ggplot() +
  geom_sf(fill = "transparent") +
  theme_void() +
  geom_point(data = climate_dt %>%
               filter(id %in% bushfire_id) %>% distinct(id, long, lat),
             aes(x = long, y = lat))

.scale <- c(6, 12, 18, 24, 30, 36)
idx_res <- climate_dt %>%
  init(id = id, time = ym) %>%
  compute_indexes(
    spei = idx_spei(.pet_method = "thornthwaite", .tavg = tavg, .lat = lat, .scale = .scale),
    spi = idx_spi(.scale = .scale)
  )

idx_diff <- idx_res %>%
  dplyr::select(.idx, id, ym, .scale, .index, long, lat) %>%
  tidyr::pivot_wider(names_from = ".idx", values_from = ".index") %>%
  mutate(diff = spei - spi)


library(ozmaps)
dt <- idx_res %>%
  mutate(year = year(ym), month = month(ym)) %>%
  filter(year == 2011 & month %in% 6:8 |
           year == 2019 & month %in% 11:12 |
           year == 2020 & month == 1) %>%
  filter(.scale == 18)

#== tsibble::make_yearmonth(1992, 7)
map_dt %>%
  ggplot() +
  geom_sf(fill = "transparent") +
  theme_void() +
  geom_point(data = dt,
             aes(x = long, y = lat, color = .index)) +
  scale_color_distiller(palette = "BrBG",direction = 1) +
  facet_grid(.idx ~ ym)

# 2003 la Nina year
# 2011 flood event makes SPI way higher than SPEI
# 2019 bush fire season
# 1993 Jun to Oct
idx_diff %>%
  ggplot(aes(x = ym, y = diff)) +
  geom_line(alpha = 0.5, aes(group = id)) +
  scale_x_yearmonth(breaks = "2 year", date_labels = "%Y") +
  theme_bw() +
  facet_wrap(vars(.scale), ncol = 2)

idx_diff %>%
  ggplot(aes(x = spi, y = spei)) +
  geom_abline(slope = 1, intercept = 0) +
  geom_point(size = 0.3, alpha = 0.5) +
  #scale_color_distiller(palette = "YlOrRd", direction = -1) +
  theme_bw() +
  theme(aspect.ratio = 1)

dist <- c(gev(), loglogistic())
# pearsonIII() gives many -Inf during bushfire season
remove <- c("ASN00033013", "ASN00088043", "ASN00080023", "ASN00080015", "ASN00080091", "ASN00088109",
            "ASN00035065", "ASN00061250", "ASN00072043", "ASN00043015", "ASN00089085", "ASN00076047",
            "ASN00061078", "ASN00089002", "ASN00063005", "ASN00036007", "ASN00040223",
            "ASN00066037", "ASN00064008", "ASN00056032")
bushfire_id <- c("ASN00056018", "ASN00048015", "ASN00039083", "ASN00041100", "ASN00040082", "ASN00043035")
#bushfire_id <- c("ASN00051049", "ASN00040093", "ASN00064009", "ASN00072150")
spei_dist <- climate_dt %>%
  filter(id %in% bushfire_id) %>%
  #filter(!id %in% remove) %>%
  init(id = id, time = ym) %>%
  idx_spei(.pet_method = "thornthwaite", .tavg = tavg, .lat = lat, .scale = 12, .dist = dist)

spei_dist$data %>%
  ggplot(aes(x = ym, y = .index, color = .dist, group = interaction(.dist, id))) +
  geom_line() +
  theme_benchmark() +
  scale_x_yearmonth(breaks = "2 year", date_labels = "%Y")


climate_dt %>%
  filter(id %in% bushfire_id) %>%
  init(id = id, time = ym) %>%
  var_trans(.method = "thornthwaite", .tavg = tavg, .lat = lat, .new_name = "pet") %>%
  dim_red(diff = prcp - pet) %>%
  aggregate(.var = diff, .scale = 18) %>%
  dist_fit(.dist = lognormal(), .method = "lmoms", .var = .agg) %>%
  augment(.var = .agg, .new_name = ".index")


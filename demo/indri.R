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
  init(id = id, time = ym, indicators = prcp:tavg) %>%
  var_trans(method = thornthwaite, Tave = tavg, lat = -29.0479, new_name = ".pet") %>%
  dim_red(expr = prcp - .pet, new_name = "d") %>%
  aggregate(var = d, scale = 12) %>%
  normalise(dist = loglogistic(), method = "lmoms", var = .agg) %>%
  augment(var = .agg)

res3 <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp) %>%
  var_trans(method = hargreaves, Tmin = tmin, Tmax = tmax, lat = -29.0479, new_name = ".pet") %>%
  dim_red(expr = prcp - .pet, new_name = "d") %>%
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
  init(id = id, time = ym, indicators = prcp:tavg) %>%
  var_trans(method = thornthwaite, Tave = tavg, lat = -29.0479, new_name = ".pet") %>%
  dim_red(expr = prcp/ .pet, new_name = "r") %>%
  aggregate(var = r, scale = 12) %>%
  var_trans(y = log10(.agg), .index = (y - mean(y))/sd(y))



# Effective Drought Index (EDI) - for daily data
w <- map_dbl(1: 12, ~digamma(.x + 1) - digamma(1)) %>% rev()
out <- tenterfield %>%
  mutate(ep = slider::slide_dbl(prcp, ~sum(.x * w))) %>%
  mutate(ep_norm = (ep - mean(ep))/ sd(ep))


out %>%
  ggplot(aes(x = ym, y = ep_norm)) +
  geom_line()


#######################################################################################
# Human Development Index
dt <- readxl::read_xlsx(file.choose(), skip = 4)
dt <- dt %>%
  janitor::clean_names() %>%
  dplyr::select(-paste0("x", seq(4, 14, 2))) %>%
  dplyr::rename(id = x1, countries = x2) %>%
  dplyr::mutate(across(c(id, human_development_index_hdi:hdi_rank), as.numeric)) %>%
  dplyr::filter(!is.na(id)) %>%
  dplyr::mutate(across(3:7, ~round(.x, digits = 3)))
colnames(dt) <- c("id", "country", "hdi", "life_exp", "exp_sch", "avg_sch", "gni_pc", "diff", "rank")

# the parameter used here is referenced in the table below at
# https://hdr.undp.org/sites/default/files/2021-22_HDR/hdr2021-22_technical_notes.pdf
######################################################
# Dimension             Indicator                             Minimum     Maximum
# Health                Life expectancy at birth (years)           20          85
# Education             Expected years of schooling (years)         0          18
#                       Mean years of schooling (years)             0          15
# Standard of living    GNI per capita (2017 PPP$)                100      75,000

# These parameters could be hand-coded, or derived from the data
# i.e. only a few countries has maximum GNI > 75,000 hence the cap.

# Other indices to compute in the notes (for example MPI - they currently use STATA,
# but is willing to adopt more R in the future as stated on the website)

dt %>%
  dplyr::mutate(
    s_exp_sch = exp_sch/18, # rescaling
    s_avg_sch = avg_sch/15, # rescaling
    sch = (s_exp_sch + s_avg_sch) / 2, # dimension reduction
    life = (life_exp - 20)/(85-20), # rescaling
    gni = (log10(gni_pc) - log10(100))/(log10(75000) - log10(100)), # rescaling
    calc = (life * sch * gni)^(1/3) # dimension reduction
    )

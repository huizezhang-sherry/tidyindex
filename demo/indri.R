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
  var_trans(method = thornthwaite, Tave = tavg, lat = -29.0479, new_name = "pet") %>%
  dim_red(expr = prcp/ pet, new_name = "r") %>%
  aggregate(var = r, scale = 12) %>%
  var_trans(y = log10(.agg),
            index = rsc_zscore(y)) # currently rescaling in also implemented under var_trans()

# two ways to write it - they are equivalent:
tenterfield %>%
  init(id = id, time = ym, indicators = prcp:tavg) %>%
  var_trans(.var = rsc_zscore(prcp))
  #var_trans(method = rsc_zscore, var = prcp)

# Effective Drought Index (EDI) - for daily data
w <- purrr::map_dbl(1: 12, ~digamma(.x + 1) - digamma(1)) %>% rev()
out <- tenterfield %>%
  init(id = id, time = ym, indicators = prcp:tavg) %>%
  var_trans(ep = slider::slide_dbl(prcp, ~sum(.x * w)), # this should be a temporal operation
            ep_norm = rsc_zscore(ep)) # this is rescaling

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
  dplyr::mutate(across(4:7, ~round(.x, digits = 3)))
colnames(dt) <- c("id", "country", "hdi", "life_exp", "exp_sch", "avg_sch", "gni_pc", "diff", "rank")
dt <- dt %>% init(id = country, indicators = life_exp:gni_pc)
# the parameter used here is referenced in the table below at
# https://hdr.undp.org/sites/default/files/2021-22_HDR/hdr2021-22_technical_notes.pdf
######################################################
# Dimension             Indicator                             Minimum     Maximum
# Health                Life expectancy at birth (years)           20          85
# Education             Expected years of schooling (years)         0          18
# Education             Mean years of schooling (years)             0          15
# Standard of living    GNI per capita (2017 PPP$)                100       75000

# These parameters could be hand-coded, or derived from the data
# i.e. only a few countries has maximum GNI > 75,000 hence the cap.

# Other indices to compute in the notes (for example MPI - they currently use STATA,
# but is willing to adopt more R in the future as stated on the website)


scaling_params <- tibble::tribble(
   ~Dimension, ~Indicator, ~Var,  ~Minimum, ~Maximum,
  "Health",              "Life expectancy at birth (years)",   "life_exp",    "20",          "85",
  "Education",           "Expected years of schooling (years)",  "exp_sch",    "0",          "18",
  "Education",           "Mean years of schooling (years)",   "avg_sch",      "0",          "15",
  "Standard of living",  "GNI per capita (2017 PPP$)",     "gni_pc",       "100",      "75000"
  ) %>%
  mutate(across(contains("mum"), as.numeric),
         across(contains("mum"), ~ifelse(Var == "gni_pc", log10(.x), .x)))

res <- dt %>%
  var_trans(gni_pc = log10(gni_pc)) %>% # var trans
  var_trans(life_exp= rsc_minmax(life_exp, min = 20, max = 85)) %>%
  # var_trans(method = rsc_minmax, vars = life_exp:gni_pc,
  #           min = scaling_params$Minimum, max = scaling_params$Maximum) %>%  # rescaling
  dim_red(expr = (exp_sch + avg_sch) / 2, new_name = "sch") %>%
  dim_red(expr = (life_exp * sch * gni_pc)^(1/3), new_name = ".index") %>%
  switch_exprs(.index, expr = (life_exp + sch + gni_pc)/3, raw = dt)
switch_values



res2 <- dt %>%
  dplyr::mutate(
    s_exp_sch = exp_sch/18, # rescaling
    s_avg_sch = avg_sch/15, # rescaling
    sch = (s_exp_sch + s_avg_sch) / 2, # dimension reduction
    life = (life_exp - 20)/(85-20), # rescaling
    gni = (log10(gni_pc) - log10(100))/(log10(75000) - log10(100)), # rescaling
    calc = (life * sch * gni)^(1/3) # dimension reduction
  )


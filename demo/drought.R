library(lubridate)
library(lmomco)
library(SPEI)

dt_init <- tenterfield |>
  mutate(month = lubridate::month(ym)) |>
  init(id = id, time = ym, group = month)

# work
(res <- dt_init |>
    temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12)) |>
  # need to load package lubridate and lmomco
    distribution_fit(.fit = dist_gamma(.agg, method = "lmoms")) |>
    normalise(index = norm_quantile(.fit))
)

# calculating SPEI using different methods on PET
# there is also the penman method, which requires monthly mean daily wind speed at 2m height
library(SPEI)
library(ggplot2)
library(tsibble)
res2 <- dt_init |>
  variable_trans(.pet = trans_thornthwaite(var = tavg, lat = lat)) |>
  dimension_reduction(.diff = aggregate_manual(~prcp - .pet)) |>
  temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12)) |>
  distribution_fit(.fit = dist_gamma(.agg, method = "lmoms")) |>
  normalise(index = norm_quantile(.fit))

res2$data |>
  ggplot(aes(x = ym, y = index)) +
  geom_line() +
  theme_benchmark()

# Reconnaissance Drought Index (RDI)
dt_init |> idx_rdi(.tavg = tavg, .lat = lat)

# Effective Drought Index (EDI) - for daily data
dt_init |> idx_edi(.tavg = tavg, .lat = lat)


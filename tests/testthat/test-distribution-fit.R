library(lmomco)
test_that("distribution_fit() works", {

  dt <- tenterfield |>
    mutate(month = lubridate::month(ym)) |>
    init(id = id, time = ym, group = month) |>
    temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12))

  expect_snapshot(dt |> distribution_fit(.fit = dist_gamma(.agg, method = "lmoms")))
  expect_snapshot(dt |> distribution_fit(.fit = dist_gev(.agg, method = "lmoms")))
  expect_snapshot(dt |> distribution_fit(.fit = dist_glo(.agg, method = "lmoms")))
  expect_snapshot(dt |> distribution_fit(.fit = dist_pe3(.agg, method = "lmoms")))


})


test_that("on errors", {

  # not an index table object
  expect_snapshot(
    tenterifeld |> distribution_fit(.fit = dist_gamma(.agg, method = "lmoms")),
    error = TRUE)

  # input is not a dimension reduction recipe
  expect_snapshot(
    hdi |> init() |> distribution_fit(index = rescale_zscore(life_exp)),
    error = TRUE)
})

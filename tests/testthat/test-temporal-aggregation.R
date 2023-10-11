test_that("temporal_agg() works", {

  expect_snapshot(
    tenterfield |>
      init() |>
      temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12))
  )

  expect_snapshot(
    tenterfield |>
      init() |>
      temporal_aggregate(temporal_rolling_window(prcp, scale = c(12, 24)))
  )

})
test_that("on errors", {

  # not an index table object
  expect_snapshot(
    tenterfield |>
      temporal_aggregate(temporal_rolling_window(prcp, scale = 12)),
    error = TRUE)

  # input is not a dimension reduction recipe
  expect_snapshot(
    tenterfield |> init() |> temporal_aggregate(index = rescale_zscore(prcp)),
    error = TRUE)


})

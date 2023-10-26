test_that("trans_thornthwaite() works", {

  expect_snapshot(
    tenterfield |>
      init() |>
      variable_trans(pet = trans_thornthwaite(tavg, lat = -29))
  )

  expect_snapshot(
    tenterfield |>
      init() |>
      variable_trans(pet = trans_thornthwaite(tavg, lat = lat))
  )


})


test_that("idx_spi() works", {
  res <- tenterfield |>
    mutate(month = lubridate::month(ym)) |>
    init(id = id, time = ym, group = month) |>
    idx_spi(.dist = dist_gamma())
  expect_snapshot(res)

  res <- tenterfield |>
    mutate(month = lubridate::month(ym)) |>
    init(id = id, time = ym, group = month) |>
    idx_spi(.dist = dist_gamma(), .scale = c(12, 24))
  expect_snapshot(res)

  # case where multiple scales and multiple distributions

})

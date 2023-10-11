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

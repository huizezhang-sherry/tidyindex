library(tidyverse)
#######################################################################################
# Human Development Index
# the parameter used here is referenced in the table below at
# https://hdr.undp.org/sites/default/files/2021-22_HDR/hdr2021-22_technical_notes.pdf

hdi_init <- hdi |>
  init(id = country) |>
  add_paras(hdi_scales, by = "var")

dt <- hdi_init |>
  rescaling(life_exp = rescale_minmax(life_exp, min = min, max = max)) |>
  rescaling(exp_sch = rescale_minmax(exp_sch, min = min, max = max)) |>
  rescaling(avg_sch = rescale_minmax(avg_sch, min = min, max = max)) |>
  rescaling(gni_pc = rescale_minmax(gni_pc, min = min, max = max))

hdi_init |>
  rescaling(rescale_minmax(c(life_exp, exp_sch, avg_sch, gni_pc), min = min, max = max))
hdi_init |> rescaling(rescale_minmax(life_exp, min = min, max = max))

# TODO: would be nice to implement tidyselect to make this work
dt <- hdi_init |>
  rescaling(life_exp = rescale_minmax(life_exp:gni_pc, min = min, max = max))
# TODO: would be nice to have this work
dt |> rescaling(rescale_minmax(c(life_exp, exp_sch), min = c(20, 0), max = c(85, 18)))


dt2 <- dt |>
  dimension_reduction(sch = aggregate_manual(~(exp_sch + avg_sch)/2)) |>
  dimension_reduction(index = aggregate_geometrical(~c(life_exp, sch, gni_pc)))

########################################################################
dt3 <- dt2 |>
  swap_values(.var = "index", .param = weight,
              .value = list(weight2, weight3, weight4))
augment(dt3)

dt4 <- dt2 |>
  swap_exprs(.var = index, .exprs = list(
    aggregate_geometrical(~c(life_exp, sch, gni_pc))))
augment(dt4)


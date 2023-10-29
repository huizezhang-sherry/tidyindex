## code to prepare `hdi` dataset goes here
dt <- readxl::read_xlsx(
  here::here("demo/HDR21-22_Statistical_Annex_HDI_Table.xlsx"), skip = 4)
hdi <- dt |>
  janitor::clean_names() |>
  dplyr::select(-paste0("x", seq(4, 14, 2))) |>
  dplyr::select(-gni_per_capita_rank_minus_hdi_rank) |>
  dplyr::rename(id = x1, countries = x2) |>
  dplyr::mutate(across(c(id, human_development_index_hdi:hdi_rank), as.numeric)) |>
  dplyr::filter(!is.na(id)) |>
  dplyr::mutate(across(4:7, ~round(.x, digits = 3)))

colnames(hdi) <- c("id", "country", "hdi", "life_exp", "exp_sch", "avg_sch", "gni_pc","rank")
hdi <- hdi |>
  dplyr::mutate(gni_pc = log10(gni_pc)) |>
  dplyr::select(id, country, hdi, rank, life_exp:gni_pc)
usethis::use_data(hdi, overwrite = TRUE)

hdi_scales <- tibble::tribble(
  ~dimension, ~name, ~var,  ~min, ~max,
  "Health",              "Life expectancy at birth (years)",   "life_exp",    "20",          "85",
  "Education",           "Expected years of schooling (years)",  "exp_sch",    "0",          "18",
  "Education",           "Mean years of schooling (years)",   "avg_sch",      "0",          "15",
  "Standard of living",  "GNI per capita (2017 PPP$)",     "gni_pc",       "100",      "75000"
) |>
  mutate(across(c(min, max), as.numeric),
         across(c(min, max), ~ifelse(var == "gni_pc", log10(.x), .x)))
usethis::use_data(hdi_scales, overwrite = TRUE)

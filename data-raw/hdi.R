## code to prepare `hdi` dataset goes here
dt <- readxl::read_xlsx(
  here::here("demo/HDR21-22_Statistical_Annex_HDI_Table.xlsx"), skip = 4)
hdi <- dt %>%
  janitor::clean_names() %>%
  dplyr::select(-paste0("x", seq(4, 14, 2))) %>%
  dplyr::rename(id = x1, countries = x2) %>%
  dplyr::mutate(across(c(id, human_development_index_hdi:hdi_rank), as.numeric)) %>%
  dplyr::filter(!is.na(id)) %>%
  dplyr::mutate(across(4:7, ~round(.x, digits = 3)))
colnames(hdi) <- c("id", "country", "hdi", "life_exp", "exp_sch", "avg_sch", "gni_pc", "diff", "rank")
usethis::use_data(hdi, overwrite = TRUE)

library(tidyverse)
#######################################################################################
# Human Development Index
dt <- readxl::read_xlsx(
  here::here("demo/HDR21-22_Statistical_Annex_HDI_Table.xlsx"), skip = 4)
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

#######################################################################################
# basic
res <- dt %>%
  var_trans(gni_pc = log10(gni_pc)) %>%
  var_trans(method = rsc_minmax, vars = life_exp:gni_pc,
            min = scaling_params$Minimum, max = scaling_params$Maximum) %>%
  dim_red(sch = (exp_sch + avg_sch) / 2) %>%
  dim_red(.index = (life_exp * sch * gni_pc)^(1/3))

#######################################################################################
# testing various experessionon the final dimension reduction
res <- res
  switch_exprs(
    .index,
    expr = list(
      index1 = (life_exp + sch + gni_pc)/3,
      index2 = 0.4 * life_exp + 0.2 * sch + 0.4 * gni_pc,
      index3 = 0.8 * life_exp + 0.1 * sch + 0.1 * gni_pc,
      index4 = 0.1 * life_exp + 0.8 * sch + 0.1 * gni_pc,
      index5 = 0.1 * life_exp + 0.1 * sch + 0.8 * gni_pc,
      index6 = 0.569 * life_exp + 0.576 * sch + 0.586 * gni_pc),
    raw = dt)

library(ggplot2)
res$data %>%
  ggplot(aes(x = .index1, y = .index6)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "blue") +
  theme(aspect.ratio = 1)

library(GGally)
ggpairs(res$data, columns = c(4, 10, 7))
ggpairs(res$data, columns = 11:17) +
  #geom_abline(slope = 1, intercept = 0, color = "blue") +
  theme(aspect.ratio = 1)

#######################################################################################
# what about we change the upper limit of the gni_pc for rescaling
res <- res %>%
  switch_values(
    module = var_trans, step = rsc_minmax, res = gni_pc,
    var = min, values = log10(c(1, 700)),
    raw_data = dt)

new_rank <- res$data %>%
  mutate(rank0 = rank(-.index0), rank1 = rank(-.index1), rank2 = rank(-.index2)) %>%
  arrange(rank0)

new_rank %>%
  ggplot(aes(x = rank0, y = rank1)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "blue") +
  geom_point(
    data = new_rank %>% mutate(d = abs(rank0 - rank1)) %>% filter(d >= 5),
    color = "red") +
  ggrepel::geom_label_repel(
    data = new_rank %>% mutate(d = abs(rank0 - rank1)) %>% filter(d >= 10),
    aes(label = country), min.segment.length = 0
  ) +
  theme(aspect.ratio = 1) +
  scale_x_continuous(breaks = seq(0, 200, 10)) +
  scale_y_continuous(breaks = seq(0, 200, 10)) +
  theme(panel.grid.minor = element_blank())

# need more analysis here to see how using different min value to scale changes the ranking





ggpairs(res$data, columns =paste0(".index", 1:6)) +
  #geom_abline(slope = 1, intercept = 0, color = "blue") +
  theme(aspect.ratio = 1)


#######################################################################################
res2 <- dt %>%
  dplyr::mutate(
    s_exp_sch = exp_sch/18, # rescaling
    s_avg_sch = avg_sch/15, # rescaling
    sch = (s_exp_sch + s_avg_sch) / 2, # dimension reduction
    life = (life_exp - 20)/(85-20), # rescaling
    gni = (log10(gni_pc) - log10(100))/(log10(75000) - log10(100)), # rescaling
    calc = (life * sch * gni)^(1/3) # dimension reduction
  )





raw <- res$data %>% dplyr::select(life_exp, sch, gni_pc) %>% as.matrix()
a <- prcomp(raw, center = TRUE, scale. = TRUE)
##TODO
## Other indexes
## parameter calculated form data
## pca in dim_red


# MPI
mpi_raw <-  readxl::read_xlsx(file.choose(), skip = 2)

mpi_raw %>%
  janitor::clean_names()




## parameter calculated from data
a <- dt %>%
  var_trans(gni_pc = log10(gni_pc))

a %>%
  var_trans(method = rsc_minmax, vars = gni_pc,
            min = log(100), max = quantile(gni_pc, 0.99))

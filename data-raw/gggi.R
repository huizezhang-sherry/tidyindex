## code to prepare `gggi` dataset goes here
library(tidyverse)
library(pdftools)
df <- pdftools::pdf_data("https://www3.weforum.org/docs/WEF_GGGR_2023.pdf")

####################################
# prep
get_gggi_variables <- function(dt){
  country <- dt %>% filter(y %in% c(103,104)) %>% filter(text != "score") %>% pull(text) %>% paste0(collapse = " ")
  var_value <- dt %>% filter(x == 266) %>% select(y, text)
  if (country == "Egypt") {
    a <- var_value$text
    res <- variable_ref %>% bind_cols(text = c(a[1:8], NA, a[9:17])) %>% mutate(country = "Egypt")
  } else{
    res <- variable_ref %>% left_join(var_value) %>% bind_cols(country = country)
  }

  return(res)
}

# a function to get the overall GGGI index
get_gggi_index <- function(dt){
  country <- dt %>% filter(y %in% c(103,104)) %>% filter(text != "score") %>% pull(text) %>% paste0(collapse = " ")
  index <- dt %>% filter(y == 41, x == 356) %>% pull(text)
  rank <- dt %>% filter(y == 41, x == 446) %>% pull(text)
  tibble(country = country, index=index, rank = rank)
}

# a reference data frame to match pdf position (y) with GGGI variables
variable_ref <- tibble(
  y = df[[83]] %>% filter(x == 266) %>% pull(y),
  variable = c("Economic Participation and Opportunity",
               "Labour force participation",
               "Wage equality for similar work",
               "Estimated earned income",
               "Legislators, senior officials and managers",
               "Professional and technical workers",
               "Educational attainment",
               "Literacy rate",
               "Enrolment in primary education",
               "Enrolment in secondary education",
               "Enrolment in tertiary education",
               "Health and survival",
               "Sex ratio at birth",
               "Healthy life expectancy",
               "Political empowerment",
               "Women in parliament",
               "Women in ministerial positions",
               "Years with female head of state"),
  category = c("subindex", rep("indicator", 5),
               "subindex", rep("indicator", 4),
               "subindex", rep("indicator", 2),
               "subindex", rep("indicator", 3)
  ),
)

all_names <- variable_ref$variable  %>% janitor::make_clean_names()
pos <- c(1, 7, 12, 15)
pillar_names <- all_names[pos]
variable_names <- setdiff(all_names, pillar_names)

####################################
# from page 83 to 371 is the country statistics, extract Afghanistan separately
raw <- map_dfr(seq(83, 371, 2), ~get_gggi_variables(df[[.x]]))
af <- variable_ref %>%
  mutate(text = c(0.1888, 0.303, NA, 0.203, 0.051, 0.137,
                  0.482, 0.434, NA, 0.571, 0.387,
                  0.952, 0.944, 0.971,
                  rep(0, 4)),
         country = "Afghanistan")

gggi_variables <- af %>%
  bind_rows(raw %>% mutate(text = as.numeric(text))) %>%
  mutate(country = ifelse(country == "KyrgyCstan", "Kyrgyzstan", country)) %>%
  select(-y, -category) %>%
  pivot_wider(names_from = variable, values_from = "text") %>%
  janitor::clean_names()

####################################
# extract the overall index score
index_raw <- map_dfr(seq(83, 371, 2), ~get_gggi_index(df[[.x]])) %>%
  mutate(rank = parse_number(rank), index = as.numeric(index))

# combine Afghanistan and fix Kyrgyzstan for the overall index score
gggi_index <- tibble(country = "Afghanistan", index = 0.405, rank = 146) %>%
  bind_rows(index_raw) %>%
  mutate(country = ifelse(country == "KyrgyCstan", "Kyrgyzstan", country))

gggi <- gggi_index %>%
  left_join(gggi_variables) %>%
  select(country, index, rank, all_of(pillar_names), all_of(variable_names))

################################################################################
# weight table
weight_tbl <- df[[65]] %>% filter(x < 550, y <= 510)
pillar_weights <- tibble(variable = pillar_names) %>% mutate(pillar_weight = 1/4)
variable_weights <- tibble(variable = variable_names) %>%
  bind_cols(std = weight_tbl %>% filter(x %in% c(417, 418, 419)) %>% pull(text) %>% as.numeric()) %>%
  bind_cols(std_per_1_point = weight_tbl %>% filter(x %in% c(498, 499, 502)) %>% pull(text)%>% as.numeric()) %>%
  bind_cols(weight = weight_tbl %>% filter(x %in% c(540, 541, 542, 545)) %>% pull(text)%>% as.numeric())
gggi_weights <- bind_rows(variable_weights, pillar_weights)

# local tour to perturb the weights
usethis::use_data(gggi, overwrite = TRUE)
usethis::use_data(gggi_weights, overwrite = TRUE)

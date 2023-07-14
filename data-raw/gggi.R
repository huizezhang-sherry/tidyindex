## code to prepare `gggi` dataset goes here
library(tidyverse)
library(pdftools)
df <- pdftools::pdf_data("https://www3.weforum.org/docs/WEF_GGGR_2023.pdf")

get_gggi_data <- function(dt){
  country <- dt %>% filter(y %in% c(103,104)) %>% filter(text != "score") %>% pull(text) %>% paste0(collapse = " ")
  var_value <- dt %>% filter(x == 266) %>% select(y, text)
  if (country == "Egypt") {
    a <- var_value$text
    res <- var_name %>% bind_cols(text = c(a[1:8], NA, a[9:17])) %>% select(y, text)
  } else{
    res <- var_name %>% left_join(var_value) %>% bind_cols(country = country)
  }

  return(res)
}

get_gggi_index <- function(dt){
  country <- dt %>% filter(y %in% c(103,104)) %>% filter(text != "score") %>% pull(text) %>% paste0(collapse = " ")
  index <- dt %>% filter(y == 41, x == 356) %>% pull(text)
  rank <- dt %>% filter(y == 41, x == 446) %>% pull(text)
  tibble(country = country, index=index, rank = rank)
}


var_name <- tibble(
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


af <- get_gggi_data(df[[83]]) %>%
  mutate(text = c(0.1888, 0.303, NA, 0.203, 0.051, 0.137,
                  0.482, 0.434, NA, 0.571, 0.387,
                  0.952, 0.944, 0.971,
                  rep(0, 4)),
         country = "Afghanistan")

index_raw <- map_dfr(seq(83, 371, 2), ~get_gggi_index(df[[.x]])) %>%
  mutate(rank = parse_number(rank), index = as.numeric(index))

gggi_index <- tibble(country = "Afghanistan", index = 0.405, rank = 146) %>%
  bind_rows(index_raw) %>%
  mutate(country = ifelse(country == "KyrgyCstan", "Kyrgyzstan", country))

# from page 83 to 371 is the country statistics
# Afghanistan doesn't get read in so processed manually
raw <- map_dfr(seq(83, 371, 2), ~get_gggi_data(df[[.x]]))

raw_all <- af %>%
  bind_rows(raw %>% mutate(text = as.numeric(text))) %>%
  mutate(country = ifelse(country == "KyrgyCstan", "Kyrgyzstan", country)) %>%
  select(-y)
gggi_indicators <- raw_all %>%
  filter(category == "indicator") %>%
  pivot_wider(names_from = variable, values_from = "text") %>%
  janitor::clean_names()

gggi_subindex <- raw_all %>%
  filter(category == "subindex") %>%
  pivot_wider(names_from = variable, values_from = "text") %>%
  janitor::clean_names() %>%
  left_join(gggi_index)

gggi <- gggi_indicators %>% left_join(gggi_subindex)

# weight table
weight_tbl <- df[[65]] %>% filter(x < 550, y <= 510)

gggi_weights <- var_name %>%
  filter(category == "indicator") %>%
  mutate(subindex = c(rep("Economic Participation and Opportunity", 5),
                      rep("Educational attainment", 4),
                      rep("Health and survival", 2),
                      rep("Political empowerment", 3))) %>%
  mutate(subindex = janitor::make_clean_names(subindex),
         variable = janitor::make_clean_names(variable)) %>%
  bind_cols(std = weight_tbl %>% filter(x %in% c(417, 418, 419)) %>% pull(text) %>% as.numeric()) %>%
  bind_cols(std_per_1_point = weight_tbl %>% filter(x %in% c(498, 499, 502)) %>% pull(text)%>% as.numeric()) %>%
  bind_cols(weight = weight_tbl %>% filter(x %in% c(540, 541, 542, 545)) %>% pull(text)%>% as.numeric()) %>%
  select(-y, -category)

# local tour to perturb the weights
usethis::use_data(gggi, overwrite = TRUE)
usethis::use_data(gggi_weights, overwrite = TRUE)

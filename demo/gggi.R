dt <- gggi |>
  na.omit() |>
  init(id = country) |>
  add_paras(gggi_weights |> mutate(weight = weight * 0.25), by = variable)

dt2 <- dt |>
  dimension_reduction(
    index1 = aggregate_linear(
      ~labour_force_participation:years_with_female_head_of_state, weight = weight)
    )

dt2$data |>
  ggplot(aes(x = index, y = index1)) +
  geom_point() +
  theme(aspect.ratio = 1)

###############################################################################
#how a small changes in weights will causes the index to change.
dt <- tidyindex::gggi %>%
  dplyr::select(country: political_empowerment) %>%
  filter(between(index, 0.72, 0.729)  | index < 0.6 | index >= 0.85) %>%
  arrange(index) %>%
  mutate(country = ifelse(country == "Iran (Islamic Republic of)", "Iran", country))
colnames(dt) <- c(colnames(dt)[1:4], "economy", "education", "health", "politics")

w_proj2idx <- function(w){w/sum(w)}
w_idx2proj <- function(w){w/(sqrt(sum(w^2))) %>% matrix(nrow = length(w))}
find_next <- function(matrix, angle = 0.4){
  start <- matrix(c(0.25, 0.25, 0.25, 0.25), ncol = 1)
  tourr:::step_angle(tourr:::geodesic_info(start, matrix), angle = angle)
}
b <- array(dim = c(4, 1, 3))
b[,,1] <- matrix(c(0.3, 0.3, 0.3, 0.1), ncol = 1) %>% find_next()
b[,,2] <- matrix(c(0.25, 0.25, 0.25, 0.25), ncol = 1) %>% w_idx2proj()
b[,,3] <- matrix(c(0.1, 0.1, 0.1, 0.7), ncol= 1) %>% find_next(angle = 0.6)

animate_idx(dt[,5:8], planned2_tour(b),
            half_range = 2,
            cex = 1, label_cex = 1, col = "black",
            panel_height_ratio = c(2,1),
            label_x_pos = 0.1,
            axis_bar_lwd = c(rep(1, 3), 2), label_col = "grey70",
            axis_bar_col = c(rep("#000000", 3), "red"),
            axis_bar_label_col = c(rep("#000000", 3), "red"),
            label = dt$country, abb_vars = FALSE)

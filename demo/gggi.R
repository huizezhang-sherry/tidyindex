dt <- gggi %>%
  select(category:years_with_female_head_of_state, -category) %>%
  init(id = country) %>%
  add_meta(gggi_weights %>% mutate(actual = weight * 0.25), var_col = variable)

dt2 <- dt %>%
  dimension_reduction(index2 = aggregate_linear(
    ~labour_force_participation:years_with_female_head_of_state, weight = actual
    ))

dt %>% dimension_reduction(index2 = pca(~., ))



# this now creates an aggregation specification for aggregation
a <- aggregate(~labour_force_participation:years_with_female_head_of_state, weight = weight, method = "arithmetic")
b <- manual_input(~(exp_sch + avg_sch)/2)


# switch_expr

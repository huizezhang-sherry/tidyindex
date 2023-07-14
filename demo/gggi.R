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
dt2 <- dt %>%
  rescaling(.method = rescale_minmax, .vars = life_exp:gni_pc,
            min = scaling_params$min, max = scaling_params$max) %>%
  dimension_reduction(sch = manual_input(~(exp_sch + avg_sch)/2)) %>%
  dimension_reduction(index = aggregate_geometrical(~c(life_exp, sch, gni_pc)))

dt2 %>%
  swap_exprs(
    .var = index,
    .exprs =
  )

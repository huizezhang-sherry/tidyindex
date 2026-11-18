# The dimension reduction module

The module combines multiple variables into a new variable. The new
variable can be a linear combination of the original variables,
`aggregate_linear()`, or a geometric mean of the original variables,
`aggregate_geometry()`, or created from an user formula input,
`aggregate_manual()`.

## Usage

``` r
dimension_reduction(data, ...)

aggregate_linear(formula, weight)

aggregate_geometrical(formula)

aggregate_manual(formula)
```

## Arguments

- data:

  used in `dimension_reduction()`, an `idx_tbl` object, see
  \[tidyindex::init()\]

- ...:

  used in `dimension_reduction()`, a dimension reduction object of
  `dim_red` class, currently one of `aggregate_linear()`,
  `aggregate_geometrical()`, or `aggregate_manual()`.

- formula:

  the formula to evaluate

- weight:

  used in `aggregate_linear()`, the column of the linear weights from
  the `roles` element in an index table object. See
  \[tidyindex::add_paras()\]

## Value

an index table object

## Examples

``` r
dt <- gggi |>
  dplyr::select(country, sex_ratio_at_birth:healthy_life_expectancy) |>
  init()

dt |>
  dimension_reduction(health = aggregate_manual(
    ~sex_ratio_at_birth * 0.693 + healthy_life_expectancy * 0.307))
#> Index pipeline: 
#> 
#> Steps: 
#> dimension_reduction: `aggregate_manual()` -> health
#> 
#> Data: 
#> # A tibble: 146 × 4
#>    country                      sex_ratio_at_birth healthy_life_expecta…¹ health
#>    <chr>                                     <dbl>                  <dbl>  <dbl>
#>  1 Afghanistan                               0.944                  0.971  0.952
#>  2 Chad                                      0.944                  1.03   0.970
#>  3 Algeria                                   0.944                  0.99   0.958
#>  4 Iran (Islamic Republic of)                0.944                  1.01   0.964
#>  5 Pakistan                                  0.944                  0.999  0.961
#>  6 Mali                                      0.944                  0.993  0.959
#>  7 Congo, Democratic Republic …              0.944                  1.05   0.977
#>  8 Oman                                      0.944                  1      0.961
#>  9 Benin                                     0.944                  1.04   0.973
#> 10 Guinea                                    0.944                  1.02   0.966
#> # ℹ 136 more rows
#> # ℹ abbreviated name: ¹​healthy_life_expectancy
dt |>
  add_paras(gggi_weights, by = variable) |>
  dimension_reduction(health = aggregate_linear(
    ~sex_ratio_at_birth:healthy_life_expectancy, weight = var_weight))
#> Index pipeline: 
#> 
#> Steps: 
#> dimension_reduction: `aggregate_linear()` -> health
#> 
#> Data: 
#> # A tibble: 146 × 4
#>    country                      sex_ratio_at_birth healthy_life_expecta…¹ health
#>    <chr>                                     <dbl>                  <dbl>  <dbl>
#>  1 Afghanistan                               0.944                  0.971  0.952
#>  2 Chad                                      0.944                  1.03   0.970
#>  3 Algeria                                   0.944                  0.99   0.958
#>  4 Iran (Islamic Republic of)                0.944                  1.01   0.964
#>  5 Pakistan                                  0.944                  0.999  0.961
#>  6 Mali                                      0.944                  0.993  0.959
#>  7 Congo, Democratic Republic …              0.944                  1.05   0.977
#>  8 Oman                                      0.944                  1      0.961
#>  9 Benin                                     0.944                  1.04   0.973
#> 10 Guinea                                    0.944                  1.02   0.966
#> # ℹ 136 more rows
#> # ℹ abbreviated name: ¹​healthy_life_expectancy
dt |>
  dimension_reduction(health = aggregate_geometrical(
    ~sex_ratio_at_birth:healthy_life_expectancy)
  )
#> Index pipeline: 
#> 
#> Steps: 
#> dimension_reduction: `aggregate_geometrical()` -> health
#> 
#> Data: 
#> # A tibble: 146 × 4
#>    country                      sex_ratio_at_birth healthy_life_expecta…¹ health
#>    <chr>                                     <dbl>                  <dbl>  <dbl>
#>  1 Afghanistan                               0.944                  0.971  0.957
#>  2 Chad                                      0.944                  1.03   0.986
#>  3 Algeria                                   0.944                  0.99   0.967
#>  4 Iran (Islamic Republic of)                0.944                  1.01   0.975
#>  5 Pakistan                                  0.944                  0.999  0.971
#>  6 Mali                                      0.944                  0.993  0.968
#>  7 Congo, Democratic Republic …              0.944                  1.05   0.996
#>  8 Oman                                      0.944                  1      0.972
#>  9 Benin                                     0.944                  1.04   0.990
#> 10 Guinea                                    0.944                  1.02   0.979
#> # ℹ 136 more rows
#> # ℹ abbreviated name: ¹​healthy_life_expectancy
```

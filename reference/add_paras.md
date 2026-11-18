# Add parameters to an index table object

The function joins the parameter table to the \`paras\` element of an
index table object.

## Usage

``` r
add_paras(data, para_tbl, by)
```

## Arguments

- data:

  a `idx_tbl` object

- para_tbl:

  a tibble or data frame object with parameter of variables

- by:

  a single column name (support tidyselect) in the \`para_tbl\` that
  maps to the variable name in the data

## Value

an index object

## Examples

``` r
init(gggi) |> add_paras(gggi_weights, by = "variable")
#> Index pipeline: 
#> Summary: NULL
#> 
#> Data: 
#> # A tibble: 146 × 22
#>    country      region index  rank economic_participati…¹ educational_attainment
#>    <chr>        <chr>  <dbl> <dbl>                  <dbl>                  <dbl>
#>  1 Afghanistan  South… 0.405   146                  0.189                  0.482
#>  2 Chad         Sub-S… 0.57    145                  0.538                  0.637
#>  3 Algeria      Middl… 0.573   144                  0.317                  0.951
#>  4 Iran (Islam… Middl… 0.575   143                  0.344                  0.96 
#>  5 Pakistan     South… 0.575   142                  0.362                  0.825
#>  6 Mali         Sub-S… 0.605   141                  0.489                  0.779
#>  7 Congo, Demo… Sub-S… 0.612   140                  0.676                  0.683
#>  8 Oman         Middl… 0.614   139                  0.488                  0.957
#>  9 Benin        Sub-S… 0.616   138                  0.53                   0.802
#> 10 Guinea       Sub-S… 0.617   137                  0.576                  0.71 
#> # ℹ 136 more rows
#> # ℹ abbreviated name: ¹​economic_participation_and_opportunity
#> # ℹ 16 more variables: health_and_survival <dbl>, political_empowerment <dbl>,
#> #   labour_force_participation <dbl>, wage_equality_for_similar_work <dbl>,
#> #   estimated_earned_income <dbl>,
#> #   legislators_senior_officials_and_managers <dbl>,
#> #   professional_and_technical_workers <dbl>, literacy_rate <dbl>, …
```

# Initialise the tidyindex pipeline

Initialise an index table object with a data frame or a tibble.

## Usage

``` r
init(data, ...)

# S3 method for class 'idx_tbl'
print(x, ...)
```

## Arguments

- data:

  a tibble or data frame to be converted into a index object

- ...:

  arguments to give variables roles, recorded in the `paras` element of
  the index table object, currently used for `id` and `time`

- x:

  an index object

## Value

an index table object

## Examples

``` r
init(hdi)
#> Index pipeline: 
#> Summary: NULL
#> 
#> Data: 
#> # A tibble: 191 × 8
#>       id country                  hdi  rank life_exp exp_sch avg_sch gni_pc
#>    <dbl> <chr>                  <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl>
#>  1     1 Switzerland            0.962     3     84.0    16.5    13.9   4.83
#>  2     2 Norway                 0.961     1     83.2    18.2    13.0   4.81
#>  3     3 Iceland                0.959     2     82.7    19.2    13.8   4.75
#>  4     4 Hong Kong, China (SAR) 0.952     4     85.5    17.3    12.2   4.80
#>  5     5 Australia              0.951     5     84.5    21.1    12.7   4.69
#>  6     6 Denmark                0.948     5     81.4    18.7    13.0   4.78
#>  7     7 Sweden                 0.947     9     83.0    19.4    12.6   4.74
#>  8     8 Ireland                0.945     8     82.0    18.9    11.6   4.88
#>  9     9 Germany                0.942     7     80.6    17.0    14.1   4.74
#> 10    10 Netherlands            0.941    10     81.7    18.7    12.6   4.75
#> # ℹ 181 more rows
init(gggi)
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

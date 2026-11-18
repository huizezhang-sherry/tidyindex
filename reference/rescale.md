# The rescaling module

The rescale module changes the scale of the variable(s) using one of the
available rescaling functions: `rescale_zscore()`, `rescale_minmax()`,
and `rescale_center`.

## Usage

``` r
rescaling(data, ...)

rescale_zscore(var, na.rm = TRUE)

rescale_minmax(var, min = NULL, max = NULL, na.rm = TRUE, censor = TRUE)

rescale_center(var, na.rm = TRUE)
```

## Arguments

- data:

  an index table object, see \[tidyindex::init()\]

- ...:

  used in `rescaling`, a rescaling object of class `rescale`, currently
  one of the `rescale_zscore()`, `rescale_minmax()`, and
  `rescale_center()`,

- var:

  the variable(s) to rescale, accept tidyselect syntax

- na.rm:

  used in `rescale_*()`, logical, whether to remove NAs

- min, max:

  used in `rescale_minmax()`, the minimum and maximum value

- censor:

  used in `rescale_minmax()`, logical; whether to censor points outside
  min and max, if provided

## Value

an index table object

## Examples

``` r
dt <- hdi |> init()
dt |> rescaling(life_exp = rescale_zscore(life_exp))
#> Index pipeline: 
#> 
#> Steps: 
#> rescaling: `rescale_zscore()` -> life_exp
#> 
#> Data: 
#> # A tibble: 191 × 8
#>       id country                  hdi  rank life_exp exp_sch avg_sch gni_pc
#>    <dbl> <chr>                  <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl>
#>  1     1 Switzerland            0.962     3     1.66    16.5    13.9   4.83
#>  2     2 Norway                 0.961     1     1.56    18.2    13.0   4.81
#>  3     3 Iceland                0.959     2     1.49    19.2    13.8   4.75
#>  4     4 Hong Kong, China (SAR) 0.952     4     1.85    17.3    12.2   4.80
#>  5     5 Australia              0.951     5     1.73    21.1    12.7   4.69
#>  6     6 Denmark                0.948     5     1.32    18.7    13.0   4.78
#>  7     7 Sweden                 0.947     9     1.53    19.4    12.6   4.74
#>  8     8 Ireland                0.945     8     1.40    18.9    11.6   4.88
#>  9     9 Germany                0.942     7     1.22    17.0    14.1   4.74
#> 10    10 Netherlands            0.941    10     1.36    18.7    12.6   4.75
#> # ℹ 181 more rows
dt |> rescaling(life_exp2 = rescale_minmax(life_exp, min = 20, max = 85))
#> Index pipeline: 
#> 
#> Steps: 
#> rescaling: `rescale_minmax()` -> life_exp2
#> 
#> Data: 
#> # A tibble: 191 × 9
#>       id country             hdi  rank life_exp exp_sch avg_sch gni_pc life_exp2
#>    <dbl> <chr>             <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl>     <dbl>
#>  1     1 Switzerland       0.962     3     84.0    16.5    13.9   4.83     0.984
#>  2     2 Norway            0.961     1     83.2    18.2    13.0   4.81     0.973
#>  3     3 Iceland           0.959     2     82.7    19.2    13.8   4.75     0.964
#>  4     4 Hong Kong, China… 0.952     4     85.5    17.3    12.2   4.80     1    
#>  5     5 Australia         0.951     5     84.5    21.1    12.7   4.69     0.993
#>  6     6 Denmark           0.948     5     81.4    18.7    13.0   4.78     0.944
#>  7     7 Sweden            0.947     9     83.0    19.4    12.6   4.74     0.969
#>  8     8 Ireland           0.945     8     82.0    18.9    11.6   4.88     0.954
#>  9     9 Germany           0.942     7     80.6    17.0    14.1   4.74     0.933
#> 10    10 Netherlands       0.941    10     81.7    18.7    12.6   4.75     0.949
#> # ℹ 181 more rows
hdi_init <- hdi |>
  init(id = country) |>
  add_paras(hdi_scales, by = "var")
hdi_init |>
  rescaling(rescale_minmax(c(life_exp, exp_sch, avg_sch, gni_pc),
  min = min, max = max))
#> Index pipeline: 
#> 
#> Steps: 
#> rescaling: `rescale_minmax()` -> life_exp
#> rescaling: `rescale_minmax()` -> exp_sch
#> rescaling: `rescale_minmax()` -> avg_sch
#> rescaling: `rescale_minmax()` -> gni_pc
#> 
#> Data: 
#> # A tibble: 191 × 8
#>       id country                  hdi  rank life_exp exp_sch avg_sch gni_pc
#>    <dbl> <chr>                  <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl>
#>  1     1 Switzerland            0.962     3    0.984   0.917   0.924  0.983
#>  2     2 Norway                 0.961     1    0.973   1       0.867  0.978
#>  3     3 Iceland                0.959     2    0.964   1       0.918  0.955
#>  4     4 Hong Kong, China (SAR) 0.952     4    1       0.960   0.815  0.973
#>  5     5 Australia              0.951     5    0.993   1       0.848  0.936
#>  6     6 Denmark                0.948     5    0.944   1       0.864  0.967
#>  7     7 Sweden                 0.947     9    0.969   1       0.841  0.952
#>  8     8 Ireland                0.945     8    0.954   1       0.772  1    
#>  9     9 Germany                0.942     7    0.933   0.945   0.939  0.952
#> 10    10 Netherlands            0.941    10    0.949   1       0.839  0.956
#> # ℹ 181 more rows
```

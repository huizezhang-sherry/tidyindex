# The variable transformation module

The variable transformation module is used to transform a single
variable in the index table object. The transformation is specified by a
variable transformation object of class `var_trans`, created by
`trans_*` functions. Currently, the following transformation functions
are supported: `trans_log10`, `trans_quadratic`, `trans_square_root`,
and `trans_cubic_root`.

## Usage

``` r
variable_trans(data, ...)

trans_log10(var)

trans_quadratic(var)

trans_square_root(var)

trans_cubic_root(var)

trans_affine(var, a = NULL, b = NULL)
```

## Arguments

- data:

  an index table object

- ...:

  an variable transformation recipe of class `var_trans`, created by
  `trans_*` function, the transformation recipe to be evaluated

- var:

  used in `trans_*` functions, the variable to be transformed

- a:

  used in `trans_affine()`, the multiplicative coefficient of affine
  transformation

- b:

  used in `trans_affine()`, the addtive constant of affine
  transformation

## Value

an index table object

## Examples

``` r
hdi |> init() |> variable_trans(gni_pc = trans_log10(gni_pc))
#> Index pipeline: 
#> 
#> Steps: 
#> variable_transformation: `trans_log()` -> gni_pc
#> 
#> Data: 
#> # A tibble: 191 × 8
#>       id country                  hdi  rank life_exp exp_sch avg_sch gni_pc
#>    <dbl> <chr>                  <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl>
#>  1     1 Switzerland            0.962     3     84.0    16.5    13.9  0.684
#>  2     2 Norway                 0.961     1     83.2    18.2    13.0  0.682
#>  3     3 Iceland                0.959     2     82.7    19.2    13.8  0.676
#>  4     4 Hong Kong, China (SAR) 0.952     4     85.5    17.3    12.2  0.681
#>  5     5 Australia              0.951     5     84.5    21.1    12.7  0.671
#>  6     6 Denmark                0.948     5     81.4    18.7    13.0  0.679
#>  7     7 Sweden                 0.947     9     83.0    19.4    12.6  0.675
#>  8     8 Ireland                0.945     8     82.0    18.9    11.6  0.689
#>  9     9 Germany                0.942     7     80.6    17.0    14.1  0.675
#> 10    10 Netherlands            0.941    10     81.7    18.7    12.6  0.677
#> # ℹ 181 more rows
```

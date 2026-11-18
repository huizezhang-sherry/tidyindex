# Testing alternatives

The two functions allows you to substitute a value/expression in the
pipeline with other options. These functions will evaluate the modified
pipeline step, as well as its prior and subsequent steps to create
different versions of the index.

## Usage

``` r
swap_values(data, .var, .param, .values)

swap_exprs(data, .var, .exprs)
```

## Arguments

- data:

  an `idx_tbl` object

- .var:

  the name of the variable, which the step is tested for alternatives

- .param:

  the name of the parameter to swap

- .values, .exprs:

  a list of values or expressions

## Value

an index table

## Examples

``` r
library(generics)
hdi_paras <- hdi_scales |>
dplyr::add_row(dimension = "Education", name = "Education",
               var = "sch", min = 0, max = 0) |>
  dplyr::mutate(weight = c(1/3, 0, 0, 1/3, 1/3),
                weight2 = c(0.1, 0, 0, 0.8, 0.1),
                weight3 = c(0.8, 0, 0, 0.1, 0.1),
                weight4 = c(0.1, 0, 0, 0.1, 0.8))

dt <- hdi |>
  init(id = country) |>
  add_paras(hdi_paras, by = var) |>
  rescaling(life_exp = rescale_minmax(life_exp, min = min, max = max)) |>
  rescaling(exp_sch = rescale_minmax(exp_sch, min = min, max = max)) |>
  rescaling(avg_sch = rescale_minmax(avg_sch, min = min, max = max)) |>
  rescaling(gni_pc = rescale_minmax(gni_pc, min = min, max = max)) |>
  dimension_reduction(sch = aggregate_manual(~(exp_sch + avg_sch)/2)) |>
  dimension_reduction(index = aggregate_linear(~c(life_exp, sch, gni_pc),
                      weight = weight))


dt2 <- dt |>
  swap_values(.var = "index", .param = weight,
              .values = list(weight2, weight3, weight4))
#> Joining with `by = join_by(variables)`
augment(dt2)
#> # A tibble: 764 × 11
#>    .id       id country    hdi  rank life_exp exp_sch avg_sch gni_pc   sch index
#>    <chr>  <dbl> <chr>    <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl>
#>  1 weight     1 Switzer… 0.962     3    0.984   0.917   0.924  0.983 0.920 0.963
#>  2 weight     2 Norway   0.961     1    0.973   1       0.867  0.978 0.933 0.961
#>  3 weight     3 Iceland  0.959     2    0.964   1       0.918  0.955 0.959 0.959
#>  4 weight     4 Hong Ko… 0.952     4    1       0.960   0.815  0.973 0.887 0.953
#>  5 weight     5 Austral… 0.951     5    0.993   1       0.848  0.936 0.924 0.951
#>  6 weight     6 Denmark  0.948     5    0.944   1       0.864  0.967 0.932 0.948
#>  7 weight     7 Sweden   0.947     9    0.969   1       0.841  0.952 0.920 0.947
#>  8 weight     8 Ireland  0.945     8    0.954   1       0.772  1     0.886 0.947
#>  9 weight     9 Germany  0.942     7    0.933   0.945   0.939  0.952 0.942 0.942
#> 10 weight    10 Netherl… 0.941    10    0.949   1       0.839  0.956 0.919 0.941
#> # ℹ 754 more rows

dt3 <- dt |>
  swap_exprs(.var = index, .exprs = list(
             aggregate_geometrical(~c(life_exp, sch, gni_pc))))
#> Joining with `by = join_by(variables)`
augment(dt3)
#> # A tibble: 382 × 11
#>    .id      id country     hdi  rank life_exp exp_sch avg_sch gni_pc   sch index
#>    <chr> <dbl> <chr>     <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl>
#>  1 1         1 Switzerl… 0.962     3    0.984   0.917   0.924  0.983 0.920 0.963
#>  2 1         2 Norway    0.961     1    0.973   1       0.867  0.978 0.933 0.961
#>  3 1         3 Iceland   0.959     2    0.964   1       0.918  0.955 0.959 0.959
#>  4 1         4 Hong Kon… 0.952     4    1       0.960   0.815  0.973 0.887 0.953
#>  5 1         5 Australia 0.951     5    0.993   1       0.848  0.936 0.924 0.951
#>  6 1         6 Denmark   0.948     5    0.944   1       0.864  0.967 0.932 0.948
#>  7 1         7 Sweden    0.947     9    0.969   1       0.841  0.952 0.920 0.947
#>  8 1         8 Ireland   0.945     8    0.954   1       0.772  1     0.886 0.947
#>  9 1         9 Germany   0.942     7    0.933   0.945   0.939  0.952 0.942 0.942
#> 10 1        10 Netherla… 0.941    10    0.949   1       0.839  0.956 0.919 0.941
#> # ℹ 372 more rows
```

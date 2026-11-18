# The temporal processing module

The temporal processing module is used to aggregate data along the
temporal dimension. Current available aggregation recipe includes
`temporal_rolling_window`.

## Usage

``` r
temporal_aggregate(data, ...)

temporal_rolling_window(
  var,
  scale,
  .before = 0L,
  .step = 1L,
  .complete = TRUE,
  rm.na = TRUE,
  ...
)
```

## Arguments

- data:

  an index table object, see \[tidyindex::init()\]

- ...:

  an temporal processing object of class `temporal_agg`

- var:

  the variable to aggregate

- scale:

  numeric, the scale (window) of the aggregation

- .before, .step, .complete:

  see [`slide_dbl`](https://slider.r-lib.org/reference/slide.html)

- rm.na:

  logical, whether to remove the first few rows with NAs

## Value

an index table object

## Examples

``` r
tenterfield |>
  init(time = ym) |>
  temporal_aggregate(.agg = temporal_rolling_window(prcp, scale = 12))
#> Index pipeline: 
#> 
#> Steps: 
#> temporal: `rolling_window()` -> .agg
#> 
#> Data: 
#> # A tibble: 358 × 10
#>    id                ym  prcp  tmax   tmin  tavg  long   lat name           .agg
#>    <chr>          <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr>         <dbl>
#>  1 ASN00056032 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tenterfield …  8382
#>  2 ASN00056032 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tenterfield …  8608
#>  3 ASN00056032 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tenterfield …  7976
#>  4 ASN00056032 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tenterfield …  7926
#>  5 ASN00056032 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tenterfield …  6376
#>  6 ASN00056032 1991 May   630  21.3  7.52  14.4   152. -29.0 tenterfield …  5786
#>  7 ASN00056032 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tenterfield …  5634
#>  8 ASN00056032 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tenterfield …  5596
#>  9 ASN00056032 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tenterfield …  5276
#> 10 ASN00056032 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tenterfield …  5088
#> # ℹ 348 more rows

# multiple ids (groups), and multiple scales
queensland |>
  dplyr::filter(id %in% c("ASN00029038", "ASN00029127")) |>
  init(id = id, time = ym) |>
  temporal_aggregate(temporal_rolling_window(prcp, scale = c(12, 24)))
#> Index pipeline: 
#> 
#> Steps: 
#> temporal: `rolling_window()` -> rolling_window_12
#> temporal: `rolling_window()` -> rolling_window_24
#> 
#> Data: 
#> # A tibble: 754 × 11
#>    id             ym  prcp  tmax  tmin  tavg  long   lat name  rolling_window_12
#>    <chr>       <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>             <dbl>
#>  1 ASN0002… 1990 Dec  1869  34.4  24.5  29.4  142. -15.5 KOWA…              7384
#>  2 ASN0002… 1991 Jan  5088  31.2  24.4  27.8  142. -15.5 KOWA…             10790
#>  3 ASN0002… 1991 Feb  8484  30.5  24.1  27.3  142. -15.5 KOWA…             18858
#>  4 ASN0002… 1991 Mar  1270  33.1  23.4  28.2  142. -15.5 KOWA…             18102
#>  5 ASN0002… 1991 Apr   174  32.4  21.9  27.2  142. -15.5 KOWA…             17679
#>  6 ASN0002… 1991 May     0  31.7  17.1  24.4  142. -15.5 KOWA…             17435
#>  7 ASN0002… 1991 Jun     0  31.3  15.1  23.2  142. -15.5 KOWA…             17265
#>  8 ASN0002… 1991 Jul     0  30.4  14.7  22.5  142. -15.5 KOWA…             17163
#>  9 ASN0002… 1991 Aug     2  32.0  14.8  23.4  142. -15.5 KOWA…             17165
#> 10 ASN0002… 1991 Sep     0  34.2  16.5  25.3  142. -15.5 KOWA…             17165
#> # ℹ 744 more rows
#> # ℹ 1 more variable: rolling_window_24 <dbl>
```

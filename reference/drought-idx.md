# Drought-related index functions

The functions are used for quick computing of some common drought
indexes built from wrappers of the underlying modules. For more
customised needs, users may build their own indexes from the modules.

## Usage

``` r
trans_thornthwaite(var, lat, na.rm = FALSE, verbose = TRUE)

idx_spi(data, .prcp, .dist = dist_gamma(), .scale = 12)

idx_spei(
  data,
  .tavg,
  .lat,
  .prcp,
  .pet_method = trans_thornthwaite(),
  .scale = 12,
  .dist = dist_glo()
)

idx_rdi(
  data,
  .tavg,
  .lat,
  .prcp,
  .pet_method = trans_thornthwaite(),
  .scale = 12
)

idx_edi(data, .tavg, .lat, .prcp, .scale = 12)
```

## Arguments

- var:

  the variable to be transformed, see \[tidyindex::variable_trans()\]
  and \[SPEI::thornthwaite()\]

- lat, na.rm, verbose:

  see \[SPEI::thornthwaite\]

- data:

  an `id_tbl` object

- .dist:

  the distribution used for distribution fit, see
  \[tidyindex::distribution_fit()\]

- .scale:

  the temporal aggregation scale, see
  \[tidyindex::temporal_aggregation()\]

- .tavg, .lat, .prcp:

  variables to be used in the index calculation, see Details

- .pet_method:

  the method used for calculating potential evapotranspitation,
  currently only `trans_thornthwaite()`

## Value

an index table object

## Details

Below explains the steps wrapped in each index and the intermediate
variables created.

The `idx_spi()` function performs

1.  a temporal aggregation on the input precipitation series, `.prcp`,
    as `.agg`,

2.  a distribution fit step on the aggregated precipitation , `.agg`, as
    `.fit`, and

3.  a normalising step on the fitted values, `.fit`, as `.index`

The `idx_spei()` function performs

1.  a variable transformation step on the input average temperature,
    `.tavg`, to obtain the potential evapotranspiration, `.pet`,

2.  a dimension reduction step to calculate difference series, `.diff`,
    between the input precipitation series, `.prcp`, and `.pet`,

3.  a temporal aggregation step on the difference series, `.diff`, as
    `.agg`,

4.  a distribution fit step on the aggregated series, `.agg`, as `.fit`,
    and

5.  a normalising step on the fitted value, `.fit`, to obtain `.index`.

The `idx_rdi()` function performs

1.  a variable transformation step on the input average temperature,
    `.tavg`, to obtain potential evapotranspiration `.pet`,

2.  a dimension reduction step to calculate the ratio of input
    precipitation, `.prcp`, to `.pet` as `.ratio`,

3.  a temporal aggregation step on the ratio series, `.ratio`, as `.agg`

4.  a variable transformation step to take the log10 of the aggregated
    series, `.agg`, as `.y`, and

5.  a rescaling step to rescale `.y` by zscore to obtain `.index`.

The `idx_edi()` function performs

1.  a dimension reduction step to aggregate the input precipitation
    series, `prcp`, as `.mult`,

2.  a temporal aggregation step on the aggregated precipitation series
    (`.mult`) as `.ep`, and

3.  a rescaling step to rescale `.ep` by zscore to obtain `.index`.

## Examples

``` r
library(dplyr)
library(lmomco)
dt <- tenterfield |>
  mutate(month = lubridate::month(ym)) |>
  init(id = id, time = ym, group = month)

dt |> idx_spi()
#> # A tibble: 358 × 14
#>    .dist id      month       ym  prcp  tmax   tmin  tavg  long   lat name   .agg
#>    <chr> <chr>   <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl>
#>  1 gamma ASN000…    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent…  8382
#>  2 gamma ASN000…     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent…  8608
#>  3 gamma ASN000…     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent…  7976
#>  4 gamma ASN000…     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent…  7926
#>  5 gamma ASN000…     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent…  6376
#>  6 gamma ASN000…     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent…  5786
#>  7 gamma ASN000…     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent…  5634
#>  8 gamma ASN000…     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent…  5596
#>  9 gamma ASN000…     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent…  5276
#> 10 gamma ASN000…     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent…  5088
#> # ℹ 348 more rows
#> # ℹ 2 more variables: .fit <dbl>, .index <dbl>
dt |> idx_spi(.scale = c(12, 24))
#> # A tibble: 704 × 15
#>    .dist id     month       ym  prcp  tmax   tmin  tavg  long   lat name  .scale
#>    <chr> <chr>  <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <chr> 
#>  1 gamma ASN00…    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent… 12    
#>  2 gamma ASN00…     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent… 12    
#>  3 gamma ASN00…     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent… 12    
#>  4 gamma ASN00…     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent… 12    
#>  5 gamma ASN00…     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent… 12    
#>  6 gamma ASN00…     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent… 12    
#>  7 gamma ASN00…     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent… 12    
#>  8 gamma ASN00…     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent… 12    
#>  9 gamma ASN00…     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent… 12    
#> 10 gamma ASN00…     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent… 12    
#> # ℹ 694 more rows
#> # ℹ 3 more variables: .agg <dbl>, .fit <dbl>, .index <dbl>
dt |> idx_spei(.lat = lat, .tavg = tavg)
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is vector. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> # A tibble: 358 × 16
#>    .dist id      month       ym  prcp  tmax   tmin  tavg  long   lat name   .pet
#>    <chr> <chr>   <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl>
#>  1 glo   ASN000…    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent… 127. 
#>  2 glo   ASN000…     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent… 118. 
#>  3 glo   ASN000…     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent… 102. 
#>  4 glo   ASN000…     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent…  86.7
#>  5 glo   ASN000…     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent…  56.6
#>  6 glo   ASN000…     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent…  49.5
#>  7 glo   ASN000…     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent…  33.5
#>  8 glo   ASN000…     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent…  19.8
#>  9 glo   ASN000…     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent…  28.8
#> 10 glo   ASN000…     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent…  41.4
#> # ℹ 348 more rows
#> # ℹ 4 more variables: .diff <dbl>, .agg <dbl>, .fit <dbl>, .index <dbl>
dt |> idx_rdi(.lat = lat, .tavg = tavg)
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is vector. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> # A tibble: 358 × 15
#>    id           ym  prcp  tmax   tmin  tavg  long   lat name  month  .pet .ratio
#>    <chr>     <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl> <dbl>  <dbl>
#>  1 ASN00… 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent…    12 127.   5.05 
#>  2 ASN00… 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent…     1 118.   9.36 
#>  3 ASN00… 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent…     2 102.   6.15 
#>  4 ASN00… 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent…     3  86.7  2.35 
#>  5 ASN00… 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent…     4  56.6  0.777
#>  6 ASN00… 1991 May   630  21.3  7.52  14.4   152. -29.0 tent…     5  49.5 12.7  
#>  7 ASN00… 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent…     6  33.5  7.22 
#>  8 ASN00… 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent…     7  19.8 29.2  
#>  9 ASN00… 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent…     8  28.8  0.486
#> 10 ASN00… 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent…     9  41.4  1.89 
#> # ℹ 348 more rows
#> # ℹ 3 more variables: .agg <dbl>, .y <dbl>, .index <dbl>
dt |> idx_edi(.lat = lat, .tavg = tavg)
#> # A tibble: 358 × 13
#>    id          ym  prcp  tmax   tmin  tavg  long   lat name  month  .mult    .ep
#>    <chr>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl>  <dbl>  <dbl>
#>  1 ASN0… 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent…    12 4134.  54292.
#>  2 ASN0… 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent…     1 7154.  55722.
#>  3 ASN0… 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent…     2 4053.  51601.
#>  4 ASN0… 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent…     3 1316.  51270.
#>  5 ASN0… 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent…     4  284.  41223.
#>  6 ASN0… 1991 May   630  21.3  7.52  14.4   152. -29.0 tent…     5 4060.  37380.
#>  7 ASN0… 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent…     6 1559.  36387.
#>  8 ASN0… 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent…     7 3735.  36122.
#>  9 ASN0… 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent…     8   90.1 34051.
#> 10 ASN0… 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent…     9  502.  32832.
#> # ℹ 348 more rows
#> # ℹ 1 more variable: .index <dbl>
```

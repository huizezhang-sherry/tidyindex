library(lmomco)
library(lubridate)
library(SPEI)
library(tsibble)
library(indri)

res <- tenterfield %>% # tenterfield contains the columns id to tavg in `res`
  init(id = id, time = ym) %>%
  compute_indexes(
    spi = idx_spi(.scale = c(6, 12)),
    spei = idx_spei(.lat = -29.0479),
    edi = idx_edi(), .index_value = FALSE
  )

res
#> # A tibble: 1,438 × 19
#>    .idx  .period id              ym  prcp  tmax  tmin  tavg .scale  .agg .method
#>    <chr>   <dbl> <chr>        <mth> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <chr>
#>  1 spi         6 ASN00056… 1990 Jun   394  14.6  3.19  8.88      6  5604 lmoms
#>  2 spi         7 ASN00056… 1990 Jul   618  15.5  1.95  8.75      6  5340 lmoms
#>  3 spi         8 ASN00056… 1990 Aug   334  14.3  2.49  8.41      6  4414 lmoms
#>  4 spi         9 ASN00056… 1990 Sep   266  18.7  5.4  12.1       6  4426 lmoms
#>  5 spi        10 ASN00056… 1990 Oct   362  23.3  7.6  15.4       6  3194 lmoms
#>  6 spi        11 ASN00056… 1990 Nov   558  27.4 10.9  19.1       6  2532 lmoms
#>  7 spi        12 ASN00056… 1990 Dec   640  30.4 14.7  22.6       6  2778 lmoms
#>  8 spi        12 ASN00056… 1990 Dec   640  30.4 14.7  22.6      12  8382 lmoms
#>  9 spi         1 ASN00056… 1991 Jan  1108  27.5 15.9  21.7       6  3268 lmoms
#> 10 spi         1 ASN00056… 1991 Jan  1108  27.5 15.9  21.7      12  8608 lmoms
#> # … with 1,428 more rows, and 8 more variables: .fitted <dbl>, .dist <chr>,
#> #   .index <dbl>, pet <dbl>, diff <dbl>, w <dbl>, mult <dbl>, ep <dbl>


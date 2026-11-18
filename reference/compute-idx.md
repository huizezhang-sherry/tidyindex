# Calculate multiple indexes at once

Calculate multiple indexes at once

## Usage

``` r
compute_indexes(.data, ...)

# S3 method for class 'idx_res'
augment(x, .id = ".id", ...)
```

## Arguments

- .data:

  an `idx_tbl` object

- ...:

  Unused, included for generic consistency only

- x:

  an `idx_res` object, calculated from `compute_indexes`

- .id:

  a character string, the name of the first column

## Value

an `idx_res` object

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
library(lmomco)
library(generics)
#> 
#> Attaching package: ‘generics’
#> The following object is masked from ‘package:dplyr’:
#> 
#>     explain
#> The following objects are masked from ‘package:base’:
#> 
#>     as.difftime, as.factor, as.ordered, intersect, is.element, setdiff,
#>     setequal, union
res <- tenterfield |>
  mutate(month = lubridate::month(ym)) |>
  init(id = id, time = ym, group = month) |>
  compute_indexes(
    spi = idx_spi(),
    spei = idx_spei(.lat = lat, .tavg = tavg),
    edi = idx_edi()
 )
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is vector. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
```

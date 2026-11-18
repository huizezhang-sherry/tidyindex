# Weather data for in-situ stations in Queensland from 1990 to 2020

Weather data for in-situ stations in Queensland from 1990 to 2020

## Usage

``` r
tenterfield

aus_climate

queensland
```

## Format

A tibble with 9 columns:

- id:

  station ID, ASN000xxxxx

- ym:

  date in \`tsibble::yearmonth\` format

- prcp:

  aggregated monthly precipitation from daily data

- tmax, tmin, tavg:

  maximum/minimum/ average temperature

- long, lat:

  longitude and latitude of the station

- name:

  station name

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
52373 rows and 9 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
11252 rows and 9 columns.

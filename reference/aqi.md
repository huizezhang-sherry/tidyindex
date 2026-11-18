# Air Quality Index (AQI)

Data for constructing Air Quality Index (AQI), extracted from the
Technical Assistance Document for the Reporting of Daily Air Quality.

## Usage

``` r
aqi_ref_tbl

pollutant_ref_tbl

aqi
```

## Format

The aqi data contains daily PM2.5 values in Travis county, Austin,
Texas, USA in 2024, measured in three monitor sites. The data is a
tibble with 272 rows and 9 variables:

- pollutant:

  name of pollutant (PM2.5)

- code:

  a five-digit code assigned to each pollutant

- date:

  date of measurement

- value:

  the measured value of PM2.5

- aqi:

  the calculated API value

- long:

  longitude of the monitor site

- lat:

  latitude of the monitor site

- site_code:

  site code

- site_name:

  site name

The aqi_ref_tbl and pollutant_ref_tbl data contain the breakpoints for
the AQI and for each of the six pollutants (Ozone, PM2.5, PM10, CO, SO2,
NO2). The aqi_ref_tbl data is a tibble with 5 rows and 3 variables:

- group:

  corresponding group category, from "Good" to "Very Unhealthy"

- low:

  the low breakpoint of a certain pollutant group

- high:

  the high breakpoint of a certain pollutant group

The pollutant_ref_tbl data is a tibble with 30 rows and 5 variables.

## References

https://document.airnow.gov/technical-assistance-document-for-the-reporting-of-daily-air-quailty.pdf

# A ggplot2 theme for benchmarking the index series

A ggplot2 theme for benchmarking the index series

## Usage

``` r
theme_benchmark(yintercept = -2, linetype = "dashed")
```

## Arguments

- yintercept:

  intercept

- linetype:

  linetype

## Value

a ggplot2 object

## Examples

``` r
if (require("ggplot2", quietly = TRUE) ){
dplyr::tibble(x = 1:100, y = rnorm(100, sd = 2)) |>
  ggplot(aes(x = x, y =y )) +
  geom_line() +
  theme_benchmark()
}
```

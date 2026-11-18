# Package index

## Pipeline infrastructure

- [`init()`](init.md) [`print(`*`<idx_tbl>`*`)`](init.md) : Initialise
  the tidyindex pipeline
- [`add_paras()`](add_paras.md) : Add parameters to an index table
  object
- [`variable_trans()`](variable-transformation.md)
  [`trans_log10()`](variable-transformation.md)
  [`trans_quadratic()`](variable-transformation.md)
  [`trans_square_root()`](variable-transformation.md)
  [`trans_cubic_root()`](variable-transformation.md)
  [`trans_affine()`](variable-transformation.md) : The variable
  transformation module
- [`rescaling()`](rescale.md) [`rescale_zscore()`](rescale.md)
  [`rescale_minmax()`](rescale.md) [`rescale_center()`](rescale.md) :
  The rescaling module
- [`dimension_reduction()`](dimension-reduction.md)
  [`aggregate_linear()`](dimension-reduction.md)
  [`aggregate_geometrical()`](dimension-reduction.md)
  [`aggregate_manual()`](dimension-reduction.md) : The dimension
  reduction module
- [`temporal_aggregate()`](temporal-aggregate.md)
  [`temporal_rolling_window()`](temporal-aggregate.md) : The temporal
  processing module
- [`distribution_fit()`](dist-fit.md) [`dist_gamma()`](dist-fit.md)
  [`dist_glo()`](dist-fit.md) [`dist_gev()`](dist-fit.md)
  [`dist_pe3()`](dist-fit.md) : The distribution fit module
- [`normalise()`](normalise.md) [`norm_quantile()`](normalise.md) : The
  normalise module

## Indexes calculation and anaysis

- [`swap_values()`](swap.md) [`swap_exprs()`](swap.md) : Testing
  alternatives
- [`compute_indexes()`](compute-idx.md)
  [`augment(`*`<idx_res>`*`)`](compute-idx.md) : Calculate multiple
  indexes at once
- [`trans_thornthwaite()`](drought-idx.md) [`idx_spi()`](drought-idx.md)
  [`idx_spei()`](drought-idx.md) [`idx_rdi()`](drought-idx.md)
  [`idx_edi()`](drought-idx.md) : Drought-related index functions

## Built-in data

- [`tenterfield`](weather.md) [`aus_climate`](weather.md)
  [`queensland`](weather.md) : Weather data for in-situ stations in
  Queensland from 1990 to 2020
- [`hdi`](hdi.md) [`hdi_scales`](hdi.md) : Human Development Index
  (2022)
- [`gggi`](gggi.md) [`gggi_weights`](gggi.md) : Global Gender Gap Index
  (2023)
- [`aqi_ref_tbl`](aqi.md) [`pollutant_ref_tbl`](aqi.md) [`aqi`](aqi.md)
  : Air Quality Index (AQI)

## Misc

- [`theme_benchmark()`](theme_benchmark.md) : A ggplot2 theme for
  benchmarking the index series

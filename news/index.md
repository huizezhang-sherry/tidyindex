# Changelog

## tidyindex 0.2.0

- [`rescaling()`](../reference/rescale.md) can now rescale multiple
  variables in one call, with parameters (e.g. `min`, `max`) taken from
  the parameter table added by
  [`add_paras()`](../reference/add_paras.md).
- New variable transformation
  [`trans_affine()`](../reference/variable-transformation.md).
- New datasets `aqi`, `aqi_ref_tbl`, and `pollutant_ref_tbl`, and a new
  vignette showing how to compute the Air Quality Index (AQI)
  (contributed by Walter Wang).
- [`idx_spi()`](../reference/drought-idx.md),
  [`idx_spei()`](../reference/drought-idx.md),
  [`idx_rdi()`](../reference/drought-idx.md), and
  [`idx_edi()`](../reference/drought-idx.md) now return the index in the
  `.index` column, and
  [`compute_indexes()`](../reference/compute-idx.md) keeps intermediate
  columns.
- The package now depends on R \>= 4.1.0, as it uses the native pipe
  `|>`.
- Maintainer email updated to <huizezhangsh@gmail.com>.

## tidyindex 0.1.0

CRAN release: 2023-11-16

- Initial CRAN submission.

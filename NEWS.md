# tidyindex 0.2.0

* `rescaling()` can now rescale multiple variables in one call, with
  parameters (e.g. `min`, `max`) taken from the parameter table added by
  `add_paras()`.
* New variable transformation `trans_affine()`.
* New datasets `aqi`, `aqi_ref_tbl`, and `pollutant_ref_tbl`, and a new
  vignette showing how to compute the Air Quality Index (AQI) (contributed by
  Walter Wang).
* `idx_spi()`, `idx_spei()`, `idx_rdi()`, and `idx_edi()` now return the index
  in the `.index` column, and `compute_indexes()` keeps intermediate columns.
* The package now depends on R >= 4.1.0, as it uses the native pipe `|>`.
* Maintainer email updated to huizezhangsh@gmail.com.

# tidyindex 0.1.0

* Initial CRAN submission.

.onLoad <- function(...){
  vctrs::s3_register("base::print", "idx_tbl")
  vctrs::s3_register("broom::tidy", "idx_tbl")
}

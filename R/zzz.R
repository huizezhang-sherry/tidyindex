.onLoad <- function(...){
  vctrs::s3_register("base::print", "indri")
  vctrs::s3_register("broom::tidy", "indri")
}

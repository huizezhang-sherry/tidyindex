.onLoad <- function(...){
  vctrs::s3_register("base::print", "indri")
}

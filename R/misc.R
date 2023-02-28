#' Title
#'
#' @param Tave tavg
#' @param lat lat
#' @param ... other arguement
#' @return a data frame
#' @export
#' @importFrom SPEI thornthwaite
#'
#' @examples
#' # tobefilled
thornthwaite <- function(Tave, lat, ...){
  SPEI::thornthwaite(Tave = Tave, lat = lat, ...) %>% unclass() %>% as.vector()
}

to_long <- function(data, cols, names_to, values_to, ...){
  data %>%
    pivot_longer(cols = cols, names_to = names_to, values_to = values_to, ...)
}


not_idx_tbl <- function(){
  cli::cli_abort("The {.code .data} supplied is not an {.code idx_tbl} object.")
}

#' Title
#'
#' @param yintercept intercpt
#' @param linetype linetype
#'
#' @return a ggplot2 object
#' @export
#' @examples
#' if (require("ggplot2", quietly = TRUE) ){
#' dplyr::tibble(x = 1:100, y = rnorm(100, sd = 2)) %>%
#'   ggplot(aes(x = x, y =y )) +
#'   geom_line() +
#'   theme_benchmark()
#' }
theme_benchmark <- function(yintercept = -2, linetype = "dashed"){

  list(
    geom_hline(yintercept = yintercept, linetype = linetype),
    theme_bw(),
    theme(panel.grid = element_blank(),
          legend.position = "bottom")
  )
}

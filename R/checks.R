check_tibble_or_df <- function(data){
  if (!(inherits(data, "tbl_df") || inherits(data, "data.frame")))
    cli::cli_abort("Currently only support a tibble or a data frame as
                    the input of tidyindex workflow.")
}

check_idx_tbl <- function(data){
  if (!inherits(data, "idx_tbl")){
    cli::cli_abort("A index table object is required as input.
                   Created it using {.fn init}. ")
  }
}

check_rescale_obj <- function(obj){
  if (!inherits(obj, "rescale")){
    cli::cli_abort("A rescale object is required as input.
                   Created it using {.fn rescale_*}.")
    }
}


check_dim_red_obj <- function(obj){
  if (!inherits(obj, "dim_red")){
    cli::cli_abort("A dimension reduction object is required as input.
                   Create it using {.fn aggregate_*}")
  }
}


check_var_trans_obj <- function(obj){
  if (!inherits(obj, "var_trans")){
    cli::cli_abort("A variable transofmration object is required as input.
                   Create is using {.fn trans_*}")
  }
}

check_temp_agg_obj <- function(obj){
  if (!inherits(obj, "temporal_agg")){
    cli::cli_abort("A temporal aggregation object is required as input.
                   Create it using {.fn temporal_*}")
  }
}

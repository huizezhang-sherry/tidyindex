# multiplication works

    Code
      dt2
    Output
      # A tibble: 3 x 2
        .param  values   
        <chr>   <list>   
      1 weight2 <idx_tbl>
      2 weight3 <idx_tbl>
      3 weight4 <idx_tbl>

---

    Code
      augment(dt2)
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(idx_name)
      
        # Now:
        data %>% select(all_of(idx_name))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(idx_name)
      
        # Now:
        data %>% select(all_of(idx_name))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(idx_name)
      
        # Now:
        data %>% select(all_of(idx_name))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Output
      # A tibble: 573 x 12
         .id       id country   hdi  rank life_exp exp_sch avg_sch gni_pc   sch .index
         <chr>  <dbl> <chr>   <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl> <dbl> <chr> 
       1 weigh~     1 Switze~ 0.962     3    0.984   0.917   0.924  0.983 0.920 index 
       2 weigh~     2 Norway  0.961     1    0.973   1       0.867  0.978 0.933 index 
       3 weigh~     3 Iceland 0.959     2    0.964   1       0.918  0.955 0.959 index 
       4 weigh~     4 Hong K~ 0.952     4    1       0.960   0.815  0.973 0.887 index 
       5 weigh~     5 Austra~ 0.951     5    0.993   1       0.848  0.936 0.924 index 
       6 weigh~     6 Denmark 0.948     5    0.944   1       0.864  0.967 0.932 index 
       7 weigh~     7 Sweden  0.947     9    0.969   1       0.841  0.952 0.920 index 
       8 weigh~     8 Ireland 0.945     8    0.954   1       0.772  1     0.886 index 
       9 weigh~     9 Germany 0.942     7    0.933   0.945   0.939  0.952 0.942 index 
      10 weigh~    10 Nether~ 0.941    10    0.949   1       0.839  0.956 0.919 index 
      # i 563 more rows
      # i 1 more variable: .value <dbl>


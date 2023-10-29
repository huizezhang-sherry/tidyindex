# compute_indexes() works

    Code
      res
    Output
      # A tibble: 3 x 2
        .idx  values      
        <chr> <named list>
      1 spi   <idx_tbl>   
      2 spei  <idx_tbl>   
      3 edi   <idx_tbl>   

---

    Code
      augment(res)
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
      # A tibble: 1,107 x 13
         .id   id            ym  prcp  tmax  tmin  tavg  long   lat name  month .index
         <chr> <chr>      <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr> <dbl> <chr> 
       1 spi   ASN000~ 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tent~     1 .index
       2 spi   ASN000~ 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tent~     2 .index
       3 spi   ASN000~ 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tent~     3 .index
       4 spi   ASN000~ 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tent~     4 .index
       5 spi   ASN000~ 1990 May  1220  19.1  6.66 12.9   152. -29.0 tent~     5 .index
       6 spi   ASN000~ 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tent~     6 .index
       7 spi   ASN000~ 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tent~     7 .index
       8 spi   ASN000~ 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tent~     8 .index
       9 spi   ASN000~ 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tent~     9 .index
      10 spi   ASN000~ 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tent~    10 .index
      # i 1,097 more rows
      # i 1 more variable: .value <dbl>

---

    Code
      augment(res2)
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
      # A tibble: 1,476 x 13
         .id   id            ym  prcp  tmax  tmin  tavg  long   lat name  month .index
         <chr> <chr>      <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr> <dbl> <chr> 
       1 spi   ASN000~ 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tent~     1 .index
       2 spi   ASN000~ 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tent~     2 .index
       3 spi   ASN000~ 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tent~     3 .index
       4 spi   ASN000~ 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tent~     4 .index
       5 spi   ASN000~ 1990 May  1220  19.1  6.66 12.9   152. -29.0 tent~     5 .index
       6 spi   ASN000~ 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tent~     6 .index
       7 spi   ASN000~ 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tent~     7 .index
       8 spi   ASN000~ 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tent~     8 .index
       9 spi   ASN000~ 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tent~     9 .index
      10 spi   ASN000~ 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tent~    10 .index
      # i 1,466 more rows
      # i 1 more variable: .value <dbl>


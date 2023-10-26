# distribution_fit() works

    Code
      normalise(dt, index = norm_quantile(.fit))
    Output
      Index pipeline: 
      
      Steps: 
    Message
      temporal: `rolling_window()` -> .agg
      distribution_fit: `distfit_gamma()` -> .fit
      normalise: `norm_quantile()` -> index
    Output
      
      Data: 
      # A tibble: 369 x 14
         id           ym  prcp  tmax  tmin  tavg  long   lat name  month  .agg    .fit
         <chr>     <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr> <dbl> <dbl>   <dbl>
       1 ASN00~ 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tent~     1   882 7.25e-8
       2 ASN00~ 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tent~     2  2142 7.38e-1
       3 ASN00~ 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tent~     3  2396 3.15e-1
       4 ASN00~ 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tent~     4  3990 8.12e-1
       5 ASN00~ 1990 May  1220  19.1  6.66 12.9   152. -29.0 tent~     5  5210 2.40e-1
       6 ASN00~ 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tent~     6  5604 4.04e-1
       7 ASN00~ 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tent~     7  6222 8.36e-1
       8 ASN00~ 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tent~     8  6556 8.25e-1
       9 ASN00~ 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tent~     9  6822 7.36e-1
      10 ASN00~ 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tent~    10  7184 7.58e-1
      # i 359 more rows
      # i 2 more variables: .fit_obj <list>, index <dbl>

# on errors

    Code
      distribution_fit(tenterifeld, .fit = dist_gamma(.agg, method = "lmoms"))
    Condition
      Error:
      ! object 'tenterifeld' not found

---

    Code
      distribution_fit(init(hdi), index = rescale_zscore(life_exp))
    Condition
      Error in `check_dist_fit_obj()`:
      ! A distribution fit object is required as input. Create it using `dist_*()`


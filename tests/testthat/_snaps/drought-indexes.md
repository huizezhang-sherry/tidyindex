# trans_thornthwaite() works

    Code
      variable_trans(init(tenterfield), pet = trans_thornthwaite(tavg, lat = -29))
    Output
      [1] "Checking for missing values (`NA`): all the data must be complete. Input type is vector. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
      Index pipeline: 
      
      Steps: 
    Message
      variable_transformation: `trans_thornthwaite()` -> pet
    Output
      
      Data: 
      # A tibble: 369 x 10
         id                ym  prcp  tmax  tmin  tavg  long   lat name             pet
         <chr>          <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>          <dbl>
       1 ASN00056032 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tenterfield (~ 113. 
       2 ASN00056032 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tenterfield (~  97.0
       3 ASN00056032 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tenterfield (~  83.9
       4 ASN00056032 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tenterfield (~  62.8
       5 ASN00056032 1990 May  1220  19.1  6.66 12.9   152. -29.0 tenterfield (~  42.1
       6 ASN00056032 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tenterfield (~  22.5
       7 ASN00056032 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tenterfield (~  23.1
       8 ASN00056032 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tenterfield (~  23.1
       9 ASN00056032 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tenterfield (~  41.3
      10 ASN00056032 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tenterfield (~  66.1
      # i 359 more rows

---

    Code
      variable_trans(init(tenterfield), pet = trans_thornthwaite(tavg, lat = lat))
    Output
      [1] "Checking for missing values (`NA`): all the data must be complete. Input type is vector. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
      Index pipeline: 
      
      Steps: 
    Message
      variable_transformation: `trans_thornthwaite()` -> pet
    Output
      
      Data: 
      # A tibble: 369 x 10
         id                ym  prcp  tmax  tmin  tavg  long   lat name             pet
         <chr>          <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>          <dbl>
       1 ASN00056032 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tenterfield (~ 113. 
       2 ASN00056032 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tenterfield (~  97.0
       3 ASN00056032 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tenterfield (~  83.9
       4 ASN00056032 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tenterfield (~  62.8
       5 ASN00056032 1990 May  1220  19.1  6.66 12.9   152. -29.0 tenterfield (~  42.1
       6 ASN00056032 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tenterfield (~  22.5
       7 ASN00056032 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tenterfield (~  23.1
       8 ASN00056032 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tenterfield (~  23.1
       9 ASN00056032 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tenterfield (~  41.2
      10 ASN00056032 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tenterfield (~  66.1
      # i 359 more rows

# idx_spi() works

    Code
      res
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

---

    Code
      res
    Output
      Index pipeline: 
      
      Steps: 
    Message
      temporal: `rolling_window()` -> .agg_12
      temporal: `rolling_window()` -> .agg_24
      distribution_fit: `distfit_gamma()` -> .fit_12
      distribution_fit: `distfit_gamma()` -> .fit_24
      normalise: `norm_quantile()` -> index_12
      normalise: `norm_quantile()` -> index_24
    Output
      
      Data: 
      # A tibble: 369 x 18
         id                ym  prcp  tmax  tmin  tavg  long   lat name   month .agg_12
         <chr>          <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>   <dbl>
       1 ASN00056032 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tente~     1     882
       2 ASN00056032 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tente~     2    2142
       3 ASN00056032 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tente~     3    2396
       4 ASN00056032 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tente~     4    3990
       5 ASN00056032 1990 May  1220  19.1  6.66 12.9   152. -29.0 tente~     5    5210
       6 ASN00056032 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tente~     6    5604
       7 ASN00056032 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tente~     7    6222
       8 ASN00056032 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tente~     8    6556
       9 ASN00056032 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tente~     9    6822
      10 ASN00056032 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tente~    10    7184
      # i 359 more rows
      # i 7 more variables: .agg_24 <dbl>, .fit_12 <dbl>, .fit_12_obj <list>,
      #   .fit_24 <dbl>, .fit_24_obj <list>, index_12 <dbl>, index_24 <dbl>


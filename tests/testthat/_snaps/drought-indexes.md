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
      # A tibble: 358 x 14
         .dist id      month       ym  prcp  tmax   tmin  tavg  long   lat name   .agg
         <chr> <chr>   <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl>
       1 gamma ASN000~    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~  8382
       2 gamma ASN000~     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~  8608
       3 gamma ASN000~     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~  7976
       4 gamma ASN000~     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~  7926
       5 gamma ASN000~     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~  6376
       6 gamma ASN000~     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~  5786
       7 gamma ASN000~     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~  5634
       8 gamma ASN000~     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~  5596
       9 gamma ASN000~     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~  5276
      10 gamma ASN000~     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~  5088
      # i 348 more rows
      # i 2 more variables: .fit <dbl>, .index <dbl>

---

    Code
      res
    Output
      # A tibble: 704 x 15
         .dist id     month       ym  prcp  tmax   tmin  tavg  long   lat name  .scale
         <chr> <chr>  <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <chr> 
       1 gamma ASN00~    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~ 12    
       2 gamma ASN00~     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~ 12    
       3 gamma ASN00~     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~ 12    
       4 gamma ASN00~     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~ 12    
       5 gamma ASN00~     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~ 12    
       6 gamma ASN00~     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~ 12    
       7 gamma ASN00~     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~ 12    
       8 gamma ASN00~     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~ 12    
       9 gamma ASN00~     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~ 12    
      10 gamma ASN00~     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~ 12    
      # i 694 more rows
      # i 3 more variables: .agg <dbl>, .fit <dbl>, .index <dbl>

# idx_spei() works

    Code
      res
    Output
      # A tibble: 704 x 17
         .dist id      month       ym  prcp  tmax   tmin  tavg  long   lat name   .pet
         <chr> <chr>   <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl>
       1 glo   ASN000~    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~ 127. 
       2 glo   ASN000~     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~ 118. 
       3 glo   ASN000~     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~ 102. 
       4 glo   ASN000~     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~  86.7
       5 glo   ASN000~     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~  56.6
       6 glo   ASN000~     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~  49.5
       7 glo   ASN000~     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~  33.5
       8 glo   ASN000~     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~  19.8
       9 glo   ASN000~     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~  28.8
      10 glo   ASN000~     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~  41.4
      # i 694 more rows
      # i 5 more variables: .diff <dbl>, .scale <chr>, .agg <dbl>, .fit <dbl>,
      #   .index <dbl>

# idx_rdi() works

    Code
      res
    Output
      # A tibble: 358 x 15
         id           ym  prcp  tmax   tmin  tavg  long   lat name  month  .pet .ratio
         <chr>     <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl> <dbl>  <dbl>
       1 ASN00~ 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~    12 127.   5.05 
       2 ASN00~ 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~     1 118.   9.36 
       3 ASN00~ 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~     2 102.   6.15 
       4 ASN00~ 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~     3  86.7  2.35 
       5 ASN00~ 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~     4  56.6  0.777
       6 ASN00~ 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~     5  49.5 12.7  
       7 ASN00~ 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~     6  33.5  7.22 
       8 ASN00~ 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~     7  19.8 29.2  
       9 ASN00~ 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~     8  28.8  0.486
      10 ASN00~ 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~     9  41.4  1.89 
      # i 348 more rows
      # i 3 more variables: .agg <dbl>, .y <dbl>, .index <dbl>

# idx_edi() works

    Code
      res
    Output
      # A tibble: 358 x 13
         id          ym  prcp  tmax   tmin  tavg  long   lat name  month  .mult    .ep
         <chr>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr> <dbl>  <dbl>  <dbl>
       1 ASN0~ 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~    12 4134.  54292.
       2 ASN0~ 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~     1 7154.  55722.
       3 ASN0~ 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~     2 4053.  51601.
       4 ASN0~ 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~     3 1316.  51270.
       5 ASN0~ 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~     4  284.  41223.
       6 ASN0~ 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~     5 4060.  37380.
       7 ASN0~ 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~     6 1559.  36387.
       8 ASN0~ 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~     7 3735.  36122.
       9 ASN0~ 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~     8   90.1 34051.
      10 ASN0~ 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~     9  502.  32832.
      # i 348 more rows
      # i 1 more variable: .index <dbl>


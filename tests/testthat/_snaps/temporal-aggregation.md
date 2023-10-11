# temporal_agg() works

    Code
      temporal_aggregate(init(tenterfield), .agg = temporal_rolling_window(prcp,
        scale = 12))
    Output
      Index pipeline: 
      
      Steps: 
    Message
      temporal: `rolling_window()` -> .agg
    Output
      
      Data: 
      # A tibble: 369 x 10
         id                ym  prcp  tmax  tmin  tavg  long   lat name            .agg
         <chr>          <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>          <dbl>
       1 ASN00056032 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tenterfield (~   882
       2 ASN00056032 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tenterfield (~  2142
       3 ASN00056032 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tenterfield (~  2396
       4 ASN00056032 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tenterfield (~  3990
       5 ASN00056032 1990 May  1220  19.1  6.66 12.9   152. -29.0 tenterfield (~  5210
       6 ASN00056032 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tenterfield (~  5604
       7 ASN00056032 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tenterfield (~  6222
       8 ASN00056032 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tenterfield (~  6556
       9 ASN00056032 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tenterfield (~  6822
      10 ASN00056032 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tenterfield (~  7184
      # i 359 more rows

---

    Code
      temporal_aggregate(init(tenterfield), temporal_rolling_window(prcp, scale = c(
        12, 24)))
    Output
      Index pipeline: 
      
      Steps: 
    Message
      temporal: `rolling_window()` -> rolling_window_12
      temporal: `rolling_window()` -> rolling_window_24
    Output
      
      Data: 
      # A tibble: 369 x 11
         id             ym  prcp  tmax  tmin  tavg  long   lat name  rolling_window_12
         <chr>       <mth> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>             <dbl>
       1 ASN0005~ 1990 Jan   882  27.0 15.2  21.1   152. -29.0 tent~               882
       2 ASN0005~ 1990 Feb  1260  26.1 16.0  21.0   152. -29.0 tent~              2142
       3 ASN0005~ 1990 Mar   254  23.8 13.4  18.6   152. -29.0 tent~              2396
       4 ASN0005~ 1990 Apr  1594  20.4 12.5  16.5   152. -29.0 tent~              3990
       5 ASN0005~ 1990 May  1220  19.1  6.66 12.9   152. -29.0 tent~              5210
       6 ASN0005~ 1990 Jun   394  14.6  3.19  8.88  152. -29.0 tent~              5604
       7 ASN0005~ 1990 Jul   618  15.5  1.95  8.75  152. -29.0 tent~              6222
       8 ASN0005~ 1990 Aug   334  14.3  2.49  8.41  152. -29.0 tent~              6556
       9 ASN0005~ 1990 Sep   266  18.7  5.4  12.1   152. -29.0 tent~              6822
      10 ASN0005~ 1990 Oct   362  23.3  7.6  15.4   152. -29.0 tent~              7184
      # i 359 more rows
      # i 1 more variable: rolling_window_24 <dbl>

# on errors

    Code
      temporal_aggregate(tenterfield, temporal_rolling_window(prcp, scale = 12))
    Condition
      Error in `check_idx_tbl()`:
      ! A index table object is required as input. Created it using `init()`.

---

    Code
      temporal_aggregate(init(tenterfield), index = rescale_zscore(prcp))
    Condition
      Error in `FUN()`:
      ! A temporal aggregation object is required as input. Create it using `temporal_*()`


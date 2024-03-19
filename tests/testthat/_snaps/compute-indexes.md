# compute_indexes() works

    Code
      res
    Output
      # A tibble: 1,074 x 19
         .idx  .dist id      month       ym  prcp  tmax   tmin  tavg  long   lat name 
         <chr> <chr> <chr>   <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr>
       1 spi   gamma ASN000~    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~
       2 spi   gamma ASN000~     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~
       3 spi   gamma ASN000~     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~
       4 spi   gamma ASN000~     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~
       5 spi   gamma ASN000~     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~
       6 spi   gamma ASN000~     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~
       7 spi   gamma ASN000~     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~
       8 spi   gamma ASN000~     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~
       9 spi   gamma ASN000~     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~
      10 spi   gamma ASN000~     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~
      # i 1,064 more rows
      # i 7 more variables: .agg <dbl>, .fit <dbl>, .index <dbl>, .pet <dbl>,
      #   .diff <dbl>, .mult <dbl>, .ep <dbl>

---

    Code
      res2
    Output
      # A tibble: 1,420 x 20
         .idx  .dist id      month       ym  prcp  tmax   tmin  tavg  long   lat name 
         <chr> <chr> <chr>   <dbl>    <mth> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr>
       1 spi   gamma ASN000~    12 1990 Dec   640  30.4 14.7   22.6   152. -29.0 tent~
       2 spi   gamma ASN000~     1 1991 Jan  1108  27.5 15.9   21.7   152. -29.0 tent~
       3 spi   gamma ASN000~     2 1991 Feb   628  28.0 15.5   21.8   152. -29.0 tent~
       4 spi   gamma ASN000~     3 1991 Mar   204  26.2 11.8   19.0   152. -29.0 tent~
       5 spi   gamma ASN000~     4 1991 Apr    44  24.2  6.57  15.4   152. -29.0 tent~
       6 spi   gamma ASN000~     5 1991 May   630  21.3  7.52  14.4   152. -29.0 tent~
       7 spi   gamma ASN000~     6 1991 Jun   242  19.6  3.65  11.6   152. -29.0 tent~
       8 spi   gamma ASN000~     7 1991 Jul   580  15.3  0.519  7.91  152. -29.0 tent~
       9 spi   gamma ASN000~     8 1991 Aug    14  17.8  1.67   9.76  152. -29.0 tent~
      10 spi   gamma ASN000~     9 1991 Sep    78  21.1  3.07  12.1   152. -29.0 tent~
      # i 1,410 more rows
      # i 8 more variables: .agg <dbl>, .fit <dbl>, .index <dbl>, .pet <dbl>,
      #   .diff <dbl>, .scale <chr>, .mult <dbl>, .ep <dbl>


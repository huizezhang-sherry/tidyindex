# multiplication works

    Code
      dt2
    Output
      # A tibble: 4 x 2
        .params values   
        <chr>   <list>   
      1 weight  <idx_tbl>
      2 weight2 <idx_tbl>
      3 weight3 <idx_tbl>
      4 weight4 <idx_tbl>

---

    Code
      augment(dt2)
    Output
      # A tibble: 764 x 11
         .id       id country    hdi  rank life_exp exp_sch avg_sch gni_pc   sch index
         <chr>  <dbl> <chr>    <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl>
       1 weight     1 Switzer~ 0.962     3    0.984   0.917   0.924  0.983 0.920 0.963
       2 weight     2 Norway   0.961     1    0.973   1       0.867  0.978 0.933 0.961
       3 weight     3 Iceland  0.959     2    0.964   1       0.918  0.955 0.959 0.959
       4 weight     4 Hong Ko~ 0.952     4    1       0.960   0.815  0.973 0.887 0.953
       5 weight     5 Austral~ 0.951     5    0.993   1       0.848  0.936 0.924 0.951
       6 weight     6 Denmark  0.948     5    0.944   1       0.864  0.967 0.932 0.948
       7 weight     7 Sweden   0.947     9    0.969   1       0.841  0.952 0.920 0.947
       8 weight     8 Ireland  0.945     8    0.954   1       0.772  1     0.886 0.947
       9 weight     9 Germany  0.942     7    0.933   0.945   0.939  0.952 0.942 0.942
      10 weight    10 Netherl~ 0.941    10    0.949   1       0.839  0.956 0.919 0.941
      # i 754 more rows

---

    Code
      dt22
    Output
      # A tibble: 2 x 2
        .params values   
        <chr>   <list>   
      1 weight  <idx_tbl>
      2 weight2 <idx_tbl>

---

    Code
      augment(dt22)
    Output
      # A tibble: 382 x 11
         .id       id country    hdi  rank life_exp exp_sch avg_sch gni_pc   sch index
         <chr>  <dbl> <chr>    <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl>
       1 weight     1 Switzer~ 0.962     3    0.984   0.917   0.924  0.983 0.920 0.963
       2 weight     2 Norway   0.961     1    0.973   1       0.867  0.978 0.933 0.961
       3 weight     3 Iceland  0.959     2    0.964   1       0.918  0.955 0.959 0.959
       4 weight     4 Hong Ko~ 0.952     4    1       0.960   0.815  0.973 0.887 0.953
       5 weight     5 Austral~ 0.951     5    0.993   1       0.848  0.936 0.924 0.951
       6 weight     6 Denmark  0.948     5    0.944   1       0.864  0.967 0.932 0.948
       7 weight     7 Sweden   0.947     9    0.969   1       0.841  0.952 0.920 0.947
       8 weight     8 Ireland  0.945     8    0.954   1       0.772  1     0.886 0.947
       9 weight     9 Germany  0.942     7    0.933   0.945   0.939  0.952 0.942 0.942
      10 weight    10 Netherl~ 0.941    10    0.949   1       0.839  0.956 0.919 0.941
      # i 372 more rows

---

    Code
      dt3
    Output
      # A tibble: 2 x 2
        .exprs values   
         <int> <list>   
      1      1 <idx_tbl>
      2      2 <idx_tbl>

---

    Code
      augment(dt3)
    Output
      # A tibble: 382 x 11
         .id      id country     hdi  rank life_exp exp_sch avg_sch gni_pc   sch index
         <chr> <dbl> <chr>     <dbl> <dbl>    <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl>
       1 1         1 Switzerl~ 0.962     3    0.984   0.917   0.924  0.983 0.920 0.963
       2 1         2 Norway    0.961     1    0.973   1       0.867  0.978 0.933 0.961
       3 1         3 Iceland   0.959     2    0.964   1       0.918  0.955 0.959 0.959
       4 1         4 Hong Kon~ 0.952     4    1       0.960   0.815  0.973 0.887 0.953
       5 1         5 Australia 0.951     5    0.993   1       0.848  0.936 0.924 0.951
       6 1         6 Denmark   0.948     5    0.944   1       0.864  0.967 0.932 0.948
       7 1         7 Sweden    0.947     9    0.969   1       0.841  0.952 0.920 0.947
       8 1         8 Ireland   0.945     8    0.954   1       0.772  1     0.886 0.947
       9 1         9 Germany   0.942     7    0.933   0.945   0.939  0.952 0.942 0.942
      10 1        10 Netherla~ 0.941    10    0.949   1       0.839  0.956 0.919 0.941
      # i 372 more rows


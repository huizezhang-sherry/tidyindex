# Global Gender Gap Index (2023)

The Global Gender Gap Index combines 14 variables from four dimensions
to measure the gender parity across 146 countries in the world.

## Usage

``` r
gggi

gggi_weights
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 146
rows and 22 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 14
rows and 7 columns.

## Details

The dataset includes country, region, GGGI score and rank, the combined
four dimensions (Economic Participation and Opportunity, Educational
Attainment, Health and Survival, and Political Empowerment), and
variables under each dimensions. The variable composition of each
dimension is as follows:

\* Economic Participation and Opportunity: Labour force participation,
Wage equality for similar work, Estimated earned income, Legislators,
senior officials and managers, and Professional and technical workers

\* Educational attainment: Literacy rate, Enrolment in primary
education, Enrolment in secondary education, Enrolment in tertiary
education

\* Health and survival: Sex ratio at birth and Healthy life expectancy

\* Political empowerment: Women in parliament, Women in ministerial
positions, and Years with female head of state

Variable names are cleaned with \[janitor::clean_names()\].

The weight data is extracted from page 65 of the Global Gender Gap
Report (see reference), see page 61 for the region classification.

## References

https://www3.weforum.org/docs/WEF_GGGR_2023.pdf

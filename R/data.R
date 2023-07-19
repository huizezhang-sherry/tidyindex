#' Precipitation in the Tenterfield station from 1990 to 2020
#'
#' @format A tibble with three columns:
#' \describe{
#' \item{id}{station ID, corresponds to tenterfied station}
#' \item{ym}{date in yearmonth}
#' \item{prcp}{summed monthly precipitation from daily data}
#' \item{tmax}{max temp}
#' \item{tmin}{min temp}
#' \item{tavg}{average temp}
#' \item{long}{longitude}
#' \item{lat}{latitude}
#' \item{name}{name}
#' }

"tenterfield"


#' Precipitation in the Tenterfield station from 1990 to 2020
#'
#' @format A tibble with three columns:
#' \describe{
#' \item{id}{station ID, corresponds to tenterfied station}
#' \item{ym}{date in yearmonth}
#' \item{prcp}{summed monthly precipitation from daily data}
#' \item{tmax}{max temp}
#' \item{tmin}{min temp}
#' \item{tavg}{average temp}
#' \item{long}{longitude}
#' \item{lat}{latitude}
#' \item{name}{name}

#' }

"aus_climate"


#' Precipitation in the Queensland stations from 1990 to 2020
#'
#' @format A tibble with three columns:
#' \describe{
#' \item{id}{station ID, corresponds to tenterfied station}
#' \item{ym}{date in yearmonth}
#' \item{prcp}{summed monthly precipitation from daily data}
#' \item{tmax}{max temp}
#' \item{tmin}{min temp}
#' \item{tavg}{average temp}
#' \item{long}{longitude}
#' \item{lat}{latitude}
#' \item{name}{name}

#' }

"queensland"



#' Precipitation in the Queensland stations from 1990 to 2020
#'
#' @format A tibble with three columns:
#' \describe{
#' \item{id}{station ID, corresponds to tenterfied station}
#' \item{ym}{date in yearmonth}
#' \item{prcp}{summed monthly precipitation from daily data}
#' \item{tmax}{max temp}
#' \item{tmin}{min temp}
#' \item{tavg}{average temp}
#' \item{long}{longitude}
#' \item{lat}{latitude}
#' \item{name}{name}

#' }

"hdi"


#' Global Gender Gap Index (2023)
#'
#' The Global Gender Gap Index combines 14 variables from four dimensions to
#' measure the gender parity across 146 countries in the world.
#'
#' @details
#' The dataset includes country, region, GGGI score and rank, the combined four
#' dimensions (Economic Participation and Opportunity, Educational Attainment,
#' Health and Survival, and Political Empowerment), and variables under each
#' dimensions. The variable composition of each dimension is as follows:
#'
#' * Economic Participation and Opportunity: Labour force
#' participation, Wage equality for similar work, Estimated earned income,
#' Legislators, senior officials and managers, and Professional and technical
#' workers
#'
#' * Educational attainment: Literacy rate, Enrolment in primary education,
#' Enrolment in secondary education, Enrolment in tertiary education
#'
#' * Health and survival: Sex ratio at birth and Healthy life expectancy
#'
#' * Political empowerment:  Women in parliament, Women in ministerial
#' positions, and Years with female head of state
#'
#' Variable names are cleaned with [janitor::clean_names()].
#'
#' The weight data is extracted from page 65 of the Global Gender Gap Report
#' (see reference), see page 61 for the region classification.
#' @rdname gggi
#' @references https://www3.weforum.org/docs/WEF_GGGR_2023.pdf
"gggi"

#' @rdname gggi
"gggi_weights"


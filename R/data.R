#' Weather data for in-situ stations in Queensland from 1990 to 2020
#'
#' @format A tibble with 9 columns:
#' \describe{
#' \item{id}{station ID, ASN000xxxxx}
#' \item{ym}{date in `tsibble::yearmonth` format}
#' \item{prcp}{aggregated monthly precipitation from daily data}
#' \item{tmax, tmin, tavg}{maximum/minimum/ average temperature}
#' \item{long, lat}{longitude and latitude of the station}
#' \item{name}{station name}
#' }
#' @rdname weather
"tenterfield"

#' @rdname weather
"aus_climate"

#' @rdname weather
"queensland"

#' Human Development Index (2022)
#'
#' @format A tibble with three columns:
#' \describe{
#' \item{id}{the row number}
#' \item{country}{191 countries with computed HDI}
#' \item{hdi}{the HDI index value}
#' \item{life_exp}{life expectancy}
#' \item{exp_sch}{expected schooling}
#' \item{avg_sch}{average schooling}
#' \item{gni_pc}{GNI per capital, logged}
#' }
#' @references https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
#' @rdname hdi
"hdi"

#' @rdname hdi
"hdi_scales"


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


#' Air Quality Index (AQI)
#' @description
#' Data for constructing Air Quality Index (AQI), extracted from the Technical
#' Assistance Document for the Reporting of Daily Air Quality.
#'
#' @format
#' The aqi data contains daily PM2.5 values in Travis county, Austin, Texas,
#' USA in 2024, measured in three monitor sites. The data is a
#' tibble with 272 rows and 9 variables:
#'
#' \describe{
#' \item{pollutant}{name of pollutant (PM2.5)}
#' \item{code}{a five-digit code assigned to each pollutant}
#' \item{date}{date of measurement}
#' \item{value}{the measured value of PM2.5}
#' \item{aqi}{the calculated API value}
#' \item{long}{longitude of the monitor site}
#' \item{lat}{latitude of the monitor site}
#' \item{site_code}{site code}
#' \item{site_name}{site name}
#' }
#'
#' @references https://document.airnow.gov/technical-assistance-document-for-the-reporting-of-daily-air-quailty.pdf
#' @rdname aqi
"aqi_ref_tbl"

#' @format
#' The aqi_ref_tbl and pollutant_ref_tbl data contain the breakpoints for
#' the AQI and for each of the six pollutants (Ozone, PM2.5, PM10, CO, SO2, NO2).
#' The aqi_ref_tbl data is a tibble with 5 rows and 3 variables:
#' \describe{
#' \item{group}{corresponding group category, from "Good" to "Very Unhealthy"}
#' \item{low}{the low breakpoint of a certain pollutant group}
#' \item{high}{the high breakpoint of a certain pollutant group}
#' }
#' @rdname aqi
"pollutant_ref_tbl"

#' @format
#' The pollutant_ref_tbl data is a tibble with 30 rows and 5 variables.
#' @rdname aqi
"aqi"


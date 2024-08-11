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


#' AQI table
#' @description
#' A table contains AQI breakpoints as well as corresponding groups, extracted
#' from the Technical Assistance Document for the Reporting of Daily Air Quality.
#' @format A tibble with 3 columns:
#' \describe{
#' \item{AQI_low_breakpoint}{the low breakpoint of AQI group}
#' \item{AQI_high_breakpoint}{the high breakpoint of AQI group}
#' \item{group}{corresponding group category, from "Good" to "Very Unhealthy"}
#' }
#' @references https://document.airnow.gov/technical-assistance-document-for-the-reporting-of-daily-air-quailty.pdf
#' @name aqi_table
"aqi_table"

#' Pollutant table
#' @description
#' A table contains breakpoints for six major pollutants: Ozone (O3), PM2.5,
#' PM10, Carbon Monoxide (CO), Sulfur Dioxide (SO2), Nitrogen Dioxide (NO2).
#' @format A tibble with 5 columns:
#' \describe{
#' \item{pollutant}{name of pollutant}
#' \item{pollutant_code}{a five-digit code assigned to each pollutant}
#' \item{low_breakpoint}{the low breakpoint of a certain pollutant group}
#' \item{high_breakpoint}{the high breakpoint of a certain pollutant group}
#' \item{group}{corresponding group category, from "Good" to "Very Unhealthy"}
#' }
#' @references https://document.airnow.gov/technical-assistance-document-for-the-reporting-of-daily-air-quailty.pdf
#' @name pollutant_table
"pollutant_table"

#' AQI travis
#' @description
#' A table contains the PM2.5 values in Travis county, Austin, Texas, USA from
#' 2024/01/01 to 2024/03/31, measured from three monitor sites. Data is collected
#' via EPA Air Quality System (AQS) API and aqsr package.
#' @references https://github.com/kpkeller/aqsr
#' @name aqi_travis
"aqi_travis"

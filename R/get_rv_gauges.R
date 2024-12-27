#' Get RV gauge metadata (simplified), locations and latest measurements
#'
#' @return Sf object.
#' @export
#'
#' @examples
#' \dontrun{
#' get_rv_gauges()
#' }
get_rv_gauges <- function() {

  # debugging ------------------------------------------------------------------

  # check arguments ------------------------------------------------------------

  # ----------------------------------------------------------------------------

  base_url <- "https://www.talsperrenleitzentrale-ruhr.de/online-daten/gewaesserpegel/"

  # query definition
  query <- list("tx_onlinedata_gauges%5baction%5d" = "json",
                "tx_onlinedata_gauges%5bcontroller%5d" = "Gauges",
                "type" = "863")

  # send request
  r_raw <- httr::GET(base_url, query = query)

  # parse response: raw to json
  r_json <- httr::content(r_raw, "text", encoding = "UTF-8")

  gauges <- jsonlite::fromJSON(r_json) |>
    tibble::as_tibble()

  # fix columns
  gauges[["datetime"]] <- gauges[["datetime"]] |> as.POSIXct(tz = "etc/GMT-1")

  gauges[["value"]] <- gauges[["value"]] |> as.numeric()

  gauges
}

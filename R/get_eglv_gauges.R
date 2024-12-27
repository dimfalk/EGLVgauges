#' Get gauge metadata (simplified), locations and latest measurements
#'
#' @return Sf object.
#' @export
#'
#' @examples
#' \dontrun{
#' get_eglv_gauges()
#' }
get_eglv_gauges <- function() {

  # debugging ------------------------------------------------------------------

  # check arguments ------------------------------------------------------------

  # ----------------------------------------------------------------------------

  base_url <- "https://pegel.eglv.de/gauges/"

  # send request
  r_raw <- httr::GET(base_url)

  # parse response: raw to json
  r_json <- httr::content(r_raw, "text", encoding = "UTF-8")

  gauges <- jsonlite::fromJSON(r_json) |>
    tibble::as_tibble() |>
    sf::st_as_sf(coords = c("Rechtswert", "Hochwert"),
                 crs = "epsg:25832")



  # unnest water level
  gauges[["latest_waterlevel_datetime"]] <- gauges[["latest_waterlevel"]][["Datum"]] |>
    strptime(format = "%d.%m.%Y %H:%M", tz = "etc/GMT-1") |>
    as.POSIXct()

  gauges[["latest_waterlevel_value"]] <- gauges[["latest_waterlevel"]][["Wert"]] |>
    as.numeric()

  gauges[["latest_waterlevel_current_alertlevel"]] <- gauges[["latest_waterlevel"]][["Aktuelle Warnstufe"]]



  # unnest discharge
  gauges[["latest_discharge_datetime"]] <- gauges[["latest_discharge"]][["Datum"]] |>
    strptime(format = "%d.%m.%Y %H:%M", tz = "etc/GMT-1") |>
    as.POSIXct()

  gauges[["latest_discharge_value"]] <- gauges[["latest_discharge"]][["Wert"]] |>
    as.numeric() |>
    suppressWarnings()

  gauges[["latest_discharge_current_alertlevel"]] <- gauges[["latest_discharge"]][["Aktuelle Warnstufe"]]



  # drop columns
  gauges <- gauges |> dplyr::select(-latest_waterlevel, -latest_discharge)

  # rename columns, change order
  gauges <- gauges |> dplyr::rename("name" = "Name",
                                    "id" = "Pegel-Nummer",
                                    "waterbody" = "Fluss",
                                    "current_trend" = "Aktueller Trend") |>
    dplyr::select("id", "name", "waterbody", "current_trend",
                  "has_current_waterlevel",
                  "latest_waterlevel_datetime",
                  "latest_waterlevel_value",
                  "latest_waterlevel_current_alertlevel",
                  "has_current_discharge",
                  "latest_discharge_datetime",
                  "latest_discharge_value",
                  "latest_discharge_current_alertlevel")

  gauges
}

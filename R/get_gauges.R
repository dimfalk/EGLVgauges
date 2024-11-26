#' Get gauge locations
#'
#' @return Sf object.
#' @export
#'
#' @examples
#' get_gauges()
get_gauges <- function() {

  base_url <- "https://pegel.eglv.de/gauges/"

  x <- jsonlite::fromJSON(base_url)

  gauges <- sf::st_as_sf(x,
                         coords = c("Rechtswert", "Hochwert"),
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


  gauges <- gauges |> dplyr::select(-latest_waterlevel, -latest_discharge)

  gauges
}

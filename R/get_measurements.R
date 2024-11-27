#' Get water level or discharge measurements
#'
#' @param x Tibble as provided by `get_gauges()`.
#' @param discharge logical. Retrieve water level or discharge data?
#'
#' @return List of xts objects.
#' @export
#'
#' @examples
#' station <- get_gauges() |> dplyr::filter(id == "10103")
#'
#' get_measurements(station)
#' get_measurements(station, discharge = TRUE)
#'
#' stations <- get_gauges() |> dplyr::filter(waterbody == "Hüller Bach")
#'
#' get_measurements(stations)
get_measurements <- function(x = NULL,
                             discharge = FALSE) {

  # ----------------------------------------------------------------------------

  base_url <- "https://pegel.eglv.de/measurements/"

  # set relevant unit
  if (discharge == FALSE) {

    unit <- "Wasserstand"

  } else {

    unit <- "Durchfluss"
  }

  # iterate over individual stations
  ids <- x[["id"]]

  n <- length(ids)

  xtslist <- list()

  for (i in 1:n) {

    url <- paste0(base_url,
                  "?serial=",
                  ids[i],
                  "&unit_name=",
                  unit)

    raw <- jsonlite::fromJSON(url)[["gauge_measurements"]]

    meas <- xts::xts(as.numeric(raw[, 2]),
                     order.by = strptime(raw[, 1], format = "%Y-%m-%dT%H:%M:%SZ", tz = "etc/GMT-1"))

    xtslist[[i]] <- meas
  }

  xtslist
}

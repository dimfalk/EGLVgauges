#' Get measurements, i.e. water levels or discharge
#'
#' @param x character. Station ID.
#' @param discharge logical. Retrieve water level or discharge data?
#'
#' @return xts object.
#' @export
#'
#' @examples
#' get_measurements("10104")
#'
#' get_measurements("10103", discharge = TRUE)
get_measurements <- function(x = NULL,
                             discharge = FALSE) {

  # ----------------------------------------------------------------------------

  base_url <- "https://pegel.eglv.de/measurements/"

  if (discharge == FALSE) {

    url <- paste0(base_url,
                  "?serial=",
                  x,
                  "&unit_name=Wasserstand")

    raw <- jsonlite::fromJSON(url)[["gauge_measurements"]]

    meas <- xts::xts(as.numeric(raw[, 2]),
                     order.by = strptime(raw[, 1], format = "%Y-%m-%dT%H:%M:%SZ", tz = "etc/GMT-1"))

  } else {

    url <- paste0(base_url,
                  "?serial=",
                  x,
                  "&unit_name=Durchfluss")

    raw <- jsonlite::fromJSON(url)[["gauge_measurements"]]

    meas <- xts::xts(as.numeric(raw[, 2]),
                     order.by = strptime(raw[, 1], format = "%Y-%m-%dT%H:%M:%SZ", tz = "etc/GMT-1"))
  }

  meas
}

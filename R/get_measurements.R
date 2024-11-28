#' Get water level or discharge measurements
#'
#' @param x Tibble as provided by `get_gauges()`.
#' @param discharge logical. Retrieve water level or discharge data?
#'
#' @return List of xts objects.
#' @export
#'
#' @seealso [get_gauges()]
#'
#' @examples
#' gauge <- get_gauges() |> dplyr::filter(id == "10103")
#'
#' get_measurements(gauge)
#' get_measurements(gauge, discharge = TRUE)
#'
#' gauges <- get_gauges() |> dplyr::filter(waterbody == "Hüller Bach")
#'
#' get_measurements(gauges)
get_measurements <- function(x = NULL,
                             discharge = FALSE) {

  # debugging ------------------------------------------------------------------

  # x <- get_gauges() |> dplyr::filter(id == "10103")
  # discharge <- FALSE

  # check arguments ------------------------------------------------------------

  checkmate::assert_tibble(x)

  checkmate::assert_logical(discharge)

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

    names(meas) <- ifelse(discharge == FALSE, "waterlevel", "discharge")

    xtslist[[i]] <- meas

    Sys.sleep(0.5)
  }

  names(xtslist) <- ids

  xtslist
}

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
#' gauges <- get_gauges() |> dplyr::filter(waterbody == "Hammbach")
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

  # set relevant parameter
  if (discharge == TRUE) {

    par <- "Durchfluss"

  } else {

    par <- "Wasserstand"
  }

  # iterate over individual stations
  ids <- x[["id"]]

  n <- length(ids)

  xtslist <- list()

  for (i in 1:n) {

    # query definition
    query <- list(serial = ids[i],
                  unit_name = par)

    # send request
    r_raw <- httr::GET(base_url, query = query)

    # parse response: raw to json
    r_json <- httr::content(r_raw, "text", encoding = "UTF-8")

    r_mat <- jsonlite::fromJSON(r_json)[["gauge_measurements"]]

    meas <- xts::xts(as.numeric(r_mat[, 2]),
                     order.by = strptime(r_mat[, 1],
                                         format = "%Y-%m-%dT%H:%M:%SZ",
                                         tz = "etc/GMT-1"))

    # fix name
    names(meas) <- par

    # add meta data
    meta <- get_meta(x[i, ])

    attr(meas, "STAT_ID") <- meta |> dplyr::pull("id")
    attr(meas, "STAT_NAME") <- meta |> dplyr::pull("name")

    attr(meas, "X") <- meta |> dplyr::pull("X")
    attr(meas, "Y") <- meta |> dplyr::pull("Y")
    attr(meas, "Z") <- meta |> dplyr::pull("level_zero")
    attr(meas, "CRS_EPSG") <- "25832"
    attr(meas, "HRS_EPSG") <- "7873"
    attr(meas, "TZONE") <- "etc/GMT-1"

    attr(meas, "PARAMETER") <- par

    attr(meas, "TS_START") <- xts::first(meas) |> zoo::index()
    attr(meas, "TS_END") <- xts::last(meas) |> zoo::index()
    attr(meas, "TS_DEFLATE") <- FALSE
    attr(meas, "TS_TYPE") <- "measurement"

    attr(meas, "MEAS_INTERVALTYPE") <- TRUE
    attr(meas, "MEAS_BLOCKING") <- "right"
    attr(meas, "MEAS_RESOLUTION") <- 5
    attr(meas, "MEAS_UNIT") <- ifelse(discharge == FALSE, "cm", "m3/s")
    attr(meas, "MEAS_STATEMENT") <- "mean"

    xtslist[[i]] <- meas

    Sys.sleep(0.5)
  }

  names(xtslist) <- ids

  xtslist
}

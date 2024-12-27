#' Get (extended) metadata for selected EGLV gauges
#'
#' @param x Sf object containing gauges to be used for subsequent queries,
#'     as provided by `get_eglv_gauges()`.
#'
#' @return Tibble containing metadata.
#' @export
#'
#' @seealso [get_eglv_gauges()]
#'
#' @examples
#' \dontrun{
#' gauge <- get_eglv_gauges() |> dplyr::filter(id == "10103")
#' get_eglv_meta(gauge)
#'
#' gauges <- get_eglv_gauges() |> dplyr::filter(waterbody == "Hammbach")
#' get_eglv_meta(gauges)
#' }
get_eglv_meta <- function(x = NULL) {

  # debugging ------------------------------------------------------------------

  # x <- get_eglv_gauges() |> dplyr::filter(id == "10103")

  # check arguments ------------------------------------------------------------

  checkmate::assert_tibble(x)

  # ----------------------------------------------------------------------------

  base_url <- "https://pegel.eglv.de/Stammdaten/"

  meta <- data.frame("id" = NA,
                     "name" = NA,
                     "operator" = NA,
                     "waterbody" = NA,
                     "municipality" = NA,
                     "X" = NA,
                     "Y" = NA,
                     "river_km" = NA,
                     "catchment_area" = NA,
                     "level_zero" = NA)

  # iterate over individual stations
  ids <- x[["id"]]

  n <- length(ids)

  for (i in 1:n) {

    url <- paste0(base_url, ids[i], "/")

    # send request
    r_raw <- httr::GET(url)

    # parse response: html to text
    a <-  rvest::read_html(r_raw) |>
      rvest::html_elements("li") |>
      rvest::html_text()

    keys <- stringr::str_split_i(a, pattern = ": ", i = 1)

    vals <- stringr::str_split_i(a, pattern = ": ", i = 2)

    meta["id"] <- vals[2]
    meta["name"] <- vals[1]
    meta["operator"] <- ifelse(as.numeric(vals[2]) > 20000, "LV", "EG")
    meta["waterbody"] <- vals[3]
    meta["municipality"] <- vals[4]
    meta["X"] <- vals[5] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
    meta["Y"] <- vals[6]  |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
    meta["river_km"] <- vals[7] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
    meta["catchment_area"] <- vals[8] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
    meta["level_zero"] <- vals[9] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()

    # concatenate objects
    if (!exists("meta_all")) {

      meta_all <- tibble::as_tibble(meta)

    } else {

      meta_all <- rbind(meta_all, meta)
    }

    Sys.sleep(0.5)
  }

  meta_all
}

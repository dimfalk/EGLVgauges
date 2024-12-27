#' Get (extended) metadata for selected RV gauges
#'
#' @param x Sf object containing gauges to be used for subsequent queries,
#'     as provided by `get_rv_gauges()`.
#'
#' @return Tibble containing metadata.
#' @export
#'
#' @seealso [get_rv_gauges()]
#'
#' @examples
#' \dontrun{
#' gauge <- get_rv_gauges() |> dplyr::filter(station_nr == "2762715000100")
#' get_rv_meta(gauge)
#'
#' gauges <- get_rv_gauges() |> dplyr::filter(parameter_name == "Wasserstand")
#' get_rv_meta(gauges)
#' }
get_rv_meta <- function(x = NULL) {

  # debugging ------------------------------------------------------------------

  # x <- get_rv_gauges() |> dplyr::filter(station_nr == "2762715000100")

  # x <- get_rv_gauges() |> dplyr::filter(parameter_name == "Wasserstand")

  # check arguments ------------------------------------------------------------

  checkmate::assert_tibble(x)

  # ----------------------------------------------------------------------------

  # init object to be returned
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

  base_url <- "https://www.talsperrenleitzentrale-ruhr.de/online-daten/gewaesserpegel/"

  # iterate over individual stations, initialize progress bar
  ids <- x[["station_nr"]] |> unique()

  n <- length(ids)

  pb <- progress::progress_bar$new(format = "(:spin) [:bar] :percent || Iteration: :current/:total || Elapsed time: :elapsedfull",
                                   total = n,
                                   complete = "#",
                                   incomplete = "-",
                                   current = ">",
                                   clear = FALSE,
                                   width = 100)

  for (i in 1:n) {

    url <- paste0(base_url, ids[i], "/")

    # query definition
    query <- list("tx_onlinedata_gauges%5baction%5d" = "show",
                  "tx_onlinedata_gauges%5bcontroller%5d" = "Gauges")

    # send request
    r_raw <- httr::GET(url, query = query)

    # TODO: dimfalk/NRWgauges#28
    if(r_raw[["status_code"]] == 404) {

      paste0("Gauge ID ", ids[i], " did not return any results. Skipping.") |> warning()

      pb$tick()

      next()
    }

    # parse response: html to text
    a <- rvest::read_html(r_raw) |>
      rvest::html_elements("div") |>
      rvest::html_elements(".col-lg-5") |> # class
      rvest::html_text() |>
      stringr::str_remove_all("\\n") |>
      stringr::str_split(pattern = "\\t") |>
      unlist() |>
      stringi::stri_remove_empty() |>
      utils::tail(-1)

    # TODO: dimfalk/NRWgauges#29
    if(stringr::str_detect(a[1], pattern = "Zum Pegelbetreiber")) {

      paste0("Gauge ID ", ids[i], " seems to be operated by LANUV NRW. Skipping for now.") |> warning()

      pb$tick()

      next()
    }

    len <- length(a)

    keys <- a[seq(1, len, by = 2)]

    vals <- a[seq(2, len, by = 2)]

    coords <- vals[8] |>
      stringr::str_remove("Lat ") |>
      stringr::str_split("Long ") |>
      unlist() |>
      as.numeric()

    meta["id"] <- vals[1]
    meta["name"] <- vals[2]
    meta["operator"] <- vals[3]
    meta["waterbody"] <- vals[5]
    meta["municipality"] <- NA
    meta["X"] <- coords[2]
    meta["Y"] <- coords[1]
    meta["river_km"] <- NA
    meta["catchment_area"] <- vals[7] |>
      stringr::str_split_i(" ", i = 1) |>
      stringr::str_replace(pattern = ",", replacement = ".") |>
      as.numeric()
    meta["level_zero"] <- vals[6] |> as.numeric()

    # concatenate objects
    if (!exists("meta_all")) {

      meta_all <- tibble::as_tibble(meta)

    } else {

      meta_all <- rbind(meta_all, meta)
    }

    Sys.sleep(0.5)

    pb$tick()
  }

  meta_all
}

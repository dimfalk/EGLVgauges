#' Get gauge metadata
#'
#' @param x character. Station ID.
#'
#' @return Tibble.
#' @export
#'
#' @examples
#' get_meta("10101")
get_meta <- function(x = NULL) {

  # ----------------------------------------------------------------------------

  base_url <- "https://pegel.eglv.de/Stammdaten/"

  url <- paste0(base_url, x, "/")

  a <- rvest::read_html(url) |>
    rvest::html_elements("li") |>
    rvest::html_text()

  keys <- stringr::str_split_i(a, pattern = ": ", i = 1)

  vals <- stringr::str_split_i(a, pattern = ": ", i = 2)

  meta <- data.frame("id" = NA,
                     "name" = NA,
                     "river" = NA,
                     "municipality" = NA,
                     "X" = NA,
                     "Y" = NA,
                     "river_km" = NA,
                     "catchment_area" = NA,
                     "level_zero" = NA)

  meta["id"] <- vals[2]
  meta["name"] <- vals[1]
  meta["river"] <- vals[3]
  meta["municipality"] <- vals[4]
  meta["X"] <- vals[5] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
  meta["Y"] <- vals[6]  |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
  meta["river_km"] <- vals[7] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
  meta["catchment_area"] <- vals[8] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()
  meta["level_zero"] <- vals[9] |> stringr::str_replace(pattern = ",", replacement = ".") |> as.numeric()

  tibble::as_tibble(meta)
}

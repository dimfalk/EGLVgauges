.onAttach <- function(libname, pkgname) {

  pkg <- "NRWgauges"

  utils::packageVersion(pkg) |> packageStartupMessage()
}

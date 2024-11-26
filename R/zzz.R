.onAttach <- function(libname, pkgname) {

  pkg <- "EGLVgauges"

  utils::packageVersion(pkg) |> packageStartupMessage()
}

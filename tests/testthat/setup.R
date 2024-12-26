## run before tests, but not loaded via `load_all()` and not installed with package

library(httptest)

# `get_gauges()` ---------------------------------------------------------------
# capture_requests({
#
#   httr::GET("https://pegel.eglv.de/gauges/")
# })

# `get_meta()` -----------------------------------------------------------------
# capture_requests({
#
#   httr::GET("https://pegel.eglv.de/Stammdaten/10103/")
#
#   httr::GET("https://pegel.eglv.de/Stammdaten/20017/")
#
#   httr::GET("https://pegel.eglv.de/Stammdaten/20020/")
# })

# `get_measurements()` ---------------------------------------------------------
# capture_requests({
#
#   httr::GET("https://pegel.eglv.de/measurements/", query = list("serial" = "10103", "unit_name" = "Wasserstand"))
#
#   httr::GET("https://pegel.eglv.de/measurements/", query = list("serial" = "10103", "unit_name" = "Durchfluss"))
#
#   httr::GET("https://pegel.eglv.de/measurements/", query = list("serial" = "20017", "unit_name" = "Wasserstand"))
#
#   httr::GET("https://pegel.eglv.de/measurements/", query = list("serial" = "20020", "unit_name" = "Wasserstand"))
# })



# get_gauges() |> dplyr::select("id", "name", "waterbody") |> saveRDS("gauges_ref.rds")

gauges_ref <- readRDS(test_path("testdata", "gauges_ref.rds"))

# x <- gauges_ref |> dplyr::filter(id == "10103"); get_meta(x) |> saveRDS("meta_10103_ref.rds")

meta_10103_ref <- readRDS(test_path("testdata", "meta_10103_ref.rds"))

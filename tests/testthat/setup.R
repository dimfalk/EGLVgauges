## run before tests, but not loaded via `load_all()` and not installed with package

library(httptest)

# `get_eglv_gauges()` ---------------------------------------------------------------
# capture_requests({
#
#   httr::GET("https://pegel.eglv.de/gauges/")
# })

# `get_eglv_meta()` -----------------------------------------------------------------
# capture_requests({
#
#   httr::GET("https://pegel.eglv.de/Stammdaten/10103/")
#
#   httr::GET("https://pegel.eglv.de/Stammdaten/20017/")
#
#   httr::GET("https://pegel.eglv.de/Stammdaten/20020/")
# })

# `get_eglv_measurements()` ---------------------------------------------------------
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

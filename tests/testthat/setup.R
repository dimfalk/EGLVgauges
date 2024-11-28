## run before tests, but not loaded via `load_all()` and not installed with package

# get_gauges() |> dplyr::select("id", "name", "waterbody") |> saveRDS("gauges_ref.rds")

gauges_ref <- readRDS(test_path("testdata", "gauges_ref.rds"))

# x <- gauges_ref |> dplyr::filter(id == "10103"); get_meta(x) |> saveRDS("meta_10103_ref.rds")

meta_10103_ref <- readRDS(test_path("testdata", "meta_10103_ref.rds"))

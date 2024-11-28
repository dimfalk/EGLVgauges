test_that("Output class is as expected.", {

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meta <- get_meta(x)

  expect_s3_class(meta, c("tbl_df", "tbl", "data.frame"))
})

test_that("Dimensions are as expected.", {

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meta <- get_meta(x)

  expect_equal(dim(meta), c(1, 9))
})

test_that("Column names are as expected.", {

  cnames <- c("id", "name", "waterbody", "municipality", "X", "Y", "river_km",
              "catchment_area", "level_zero")

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meta <- get_meta(x)

  expect_equal(colnames(meta), cnames)
})

test_that("Types are as expected.", {

  dtype <- c("character", "character", "character", "character", "double",
             "double", "double", "double", "double")

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meta <- get_meta(x)

  meta_dtype <- lapply(meta, typeof) |> unlist() |> as.character()

  expect_equal(meta_dtype, dtype)
})

test_that("Function output and reference object are equal.", {

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meta <- get_meta(x)

  expect_equal(meta, meta_10103_ref)
})

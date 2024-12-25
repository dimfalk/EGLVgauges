with_mock_api({

  test_that("Output class is as expected.", {

    x <- get_gauges()

    expect_s3_class(x, c("sf", "tbl_df", "tbl", "data.frame"))
  })

  test_that("Dimensions are as expected.", {

    x <- get_gauges()

    expect_equal(dim(x), c(112, 13))
  })

  test_that("Column names are as expected.", {

    cnames <- c("id", "name", "waterbody", "current_trend",
                "has_current_waterlevel",
                "latest_waterlevel_datetime",
                "latest_waterlevel_value",
                "latest_waterlevel_current_alertlevel",
                "has_current_discharge",
                "latest_discharge_datetime",
                "latest_discharge_value",
                "latest_discharge_current_alertlevel",
                "geometry")

    x <- get_gauges()

    expect_equal(colnames(x), cnames)
  })

  test_that("Types are as expected.", {

    dtype <- c("character", "character", "character", "character", "logical",
               "double", "double", "integer", "logical", "double", "double",
               "logical", "list")

    x <- get_gauges()

    x_dtype <- lapply(x, typeof) |> unlist() |> as.character()

    expect_equal(x_dtype, dtype)
  })

  test_that("Function output and reference object are equal.", {

    x <- get_gauges() |> dplyr::select("id", "name", "waterbody")

    expect_equal(x, gauges_ref)
  })
})

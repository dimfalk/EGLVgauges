with_mock_api({

  test_that("Output class is as expected.", {

    x <- get_gauges() |> dplyr::filter(id == "10103")

    meas <- get_measurements(x)

    expect_equal(class(meas), "list")

    expect_s3_class(meas[[1]], c("xts", "zoo"))
  })

  test_that("Output class is as expected.", {

    x <- get_gauges() |> dplyr::filter(id == "10103")

    meas <- get_measurements(x, discharge = TRUE)

    expect_equal(class(meas), "list")

    expect_s3_class(meas[[1]], c("xts", "zoo"))
  })

  test_that("Output class is as expected.", {

    y <- get_gauges() |> dplyr::filter(waterbody == "Hammbach")

    meas <- get_measurements(y)

    expect_equal(class(meas), "list")

    expect_s3_class(meas[[1]], c("xts", "zoo"))

    expect_s3_class(meas[[2]], c("xts", "zoo"))
  })



  test_that("Attributes are as expected.", {

    x <- get_gauges() |> dplyr::filter(id == "10103")

    meas <- get_measurements(x)

    expect_equal(attr(meas[[1]], "STAT_ID"), "10103")

    expect_equal(attr(meas[[1]], "PARAMETER"), "Wasserstand")
  })

  test_that("Attributes are as expected.", {

    x <- get_gauges() |> dplyr::filter(id == "10103")

    meas <- get_measurements(x, discharge = TRUE)

    expect_equal(attr(meas[[1]], "STAT_ID"), "10103")

    expect_equal(attr(meas[[1]], "PARAMETER"), "Durchfluss")
  })

  test_that("Attributes are as expected.", {

    y <- get_gauges() |> dplyr::filter(waterbody == "Hammbach")

    meas <- get_measurements(y)

    expect_equal(attr(meas[[1]], "STAT_ID"), "20017")

    expect_equal(attr(meas[[1]], "PARAMETER"), "Wasserstand")

    expect_equal(attr(meas[[2]], "STAT_ID"), "20020")

    expect_equal(attr(meas[[2]], "PARAMETER"), "Wasserstand")
  })
})

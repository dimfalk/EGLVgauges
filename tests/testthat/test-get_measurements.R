test_that("Output class is as expected.", {

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meas_1 <- get_measurements(x)

  expect_equal(class(meas_1), "list")

  expect_s3_class(meas_1[[1]], c("xts", "zoo"))

  meas_2 <- get_measurements(x, discharge = TRUE)

  expect_equal(class(meas_2), "list")

  expect_s3_class(meas_2[[1]], c("xts", "zoo"))



  y <- gauges_ref |> dplyr::filter(waterbody == "Hammbach")

  meas_3 <- get_measurements(y)

  expect_equal(class(meas_3), "list")

  expect_s3_class(meas_3[[1]], c("xts", "zoo"))

  expect_s3_class(meas_3[[2]], c("xts", "zoo"))
})

test_that("Attributes are as expected.", {

  x <- gauges_ref |> dplyr::filter(id == "10103")

  meas_1 <- get_measurements(x)

  expect_equal(attr(meas_1[[1]], "STAT_ID"), "10103")

  expect_equal(attr(meas_1[[1]], "PARAMETER"), "Wasserstand")

  meas_2 <- get_measurements(x, discharge = TRUE)

  expect_equal(attr(meas_2[[1]], "STAT_ID"), "10103")

  expect_equal(attr(meas_2[[1]], "PARAMETER"), "Durchfluss")
})

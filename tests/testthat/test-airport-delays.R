test_that("visualize_airport_delays returns a ggplot object", {

  plot <- visualize_airport_delays()

  expect_s3_class(
    plot,
    "ggplot"
  )
})


test_that("airport delay plot contains the required data", {

  plot <- visualize_airport_delays()

  expect_true(
    all(
      c(
        "dest",
        "mean_delay",
        "number_of_flights",
        "lon",
        "lat"
      ) %in% names(plot$data)
    )
  )
})


test_that("airport coordinates contain no missing values", {

  plot <- visualize_airport_delays()

  expect_false(
    any(is.na(plot$data$lon))
  )

  expect_false(
    any(is.na(plot$data$lat))
  )
})


test_that("mean airport delays are numeric", {

  plot <- visualize_airport_delays()

  expect_true(
    is.numeric(plot$data$mean_delay)
  )

  expect_false(
    any(is.na(plot$data$mean_delay))
  )
})


test_that("number of flights is positive", {

  plot <- visualize_airport_delays()

  expect_true(
    all(plot$data$number_of_flights > 0)
  )
})


test_that("there is one row for each destination airport", {

  plot <- visualize_airport_delays()

  expect_equal(
    nrow(plot$data),
    length(unique(plot$data$dest))
  )
})


test_that("airport delay plot contains airport observations", {

  plot <- visualize_airport_delays()

  expect_gt(
    nrow(plot$data),
    0
  )
})

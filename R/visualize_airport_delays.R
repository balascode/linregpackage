#' Visualize Mean Airport Delays
#'
#' Creates a geographic scatter plot showing the mean arrival delay
#' for destination airports in the nycflights13 flights dataset.
#'
#' @return A ggplot object showing destination airports by longitude
#'   and latitude.
#'
#' @importFrom rlang .data
#' @export
visualize_airport_delays <- function() {

  airport_delays <- nycflights13::flights |>
    dplyr::filter(
      !is.na(.data$dest),
      !is.na(.data$arr_delay)
    ) |>
    dplyr::group_by(.data$dest) |>
    dplyr::summarise(
      mean_delay = mean(.data$arr_delay),
      number_of_flights = dplyr::n(),
      .groups = "drop"
    )

  airport_data <- airport_delays |>
    dplyr::left_join(
      nycflights13::airports,
      by = c("dest" = "faa")
    ) |>
    dplyr::filter(
      !is.na(.data$lon),
      !is.na(.data$lat)
    )

  ggplot2::ggplot(
    airport_data,
    ggplot2::aes(
      x = .data$lon,
      y = .data$lat,
      colour = .data$mean_delay,
      size = .data$number_of_flights
    )
  ) +
    ggplot2::geom_point(alpha = 0.7) +
    ggplot2::labs(
      title = "Mean Arrival Delay by Destination Airport",
      subtitle = "Flights departing from New York City airports",
      x = "Longitude",
      y = "Latitude",
      colour = "Mean delay\n(minutes)",
      size = "Number of\nflights"
    ) +
    ggplot2::theme_minimal()
}

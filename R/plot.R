#' Plot Diagnostic Plots for a linreg Model
#'
#' Creates diagnostic plots for a fitted \code{linreg} model.
#'
#' The method produces two diagnostic plots:
#' \itemize{
#'   \item Residuals vs Fitted
#'   \item Scale-Location
#' }
#'
#' @param x An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return Invisibly returns a list containing the two ggplot objects.
#'
#' @importFrom graphics plot
#' @export
plot.linreg <- function(x, ...) {

  Q <- qr.Q(qr(x$X))
  leverage <- rowSums(Q^2)

  standardized_residuals <- x$residuals /
    (x$sigma * sqrt(pmax(1 - leverage, .Machine$double.eps)))

  fitted_values <- x$fitted_values
  residual_values <- x$residuals

  scale_location_values <-
    sqrt(abs(standardized_residuals))

  observation_numbers <-
    seq_along(fitted_values)

  ordered_indices <- order(
    abs(standardized_residuals),
    decreasing = TRUE
  )

  number_of_labels <- min(
    3L,
    length(ordered_indices)
  )

  label_indices <-
    ordered_indices[seq_len(number_of_labels)]

  label_fitted <-
    fitted_values[label_indices]

  label_residuals <-
    residual_values[label_indices]

  label_scale_location <-
    scale_location_values[label_indices]

  label_observations <-
    observation_numbers[label_indices]


  p1 <- ggplot2::ggplot() +

    ggplot2::geom_point(
      ggplot2::aes(
        x = fitted_values,
        y = residual_values
      )
    ) +

    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed"
    ) +

    ggplot2::geom_smooth(
      ggplot2::aes(
        x = fitted_values,
        y = residual_values
      ),
      method = "loess",
      se = FALSE,
      formula = y ~ x
    ) +

    ggplot2::geom_text(
      ggplot2::aes(
        x = label_fitted,
        y = label_residuals,
        label = label_observations
      ),
      nudge_y = 0.08,
      check_overlap = TRUE
    ) +

    ggplot2::labs(
      title = "Residuals vs Fitted",
      x = "Fitted values",
      y = "Residuals"
    ) +

    ggplot2::theme_minimal()


  p2 <- ggplot2::ggplot() +

    ggplot2::geom_point(
      ggplot2::aes(
        x = fitted_values,
        y = scale_location_values
      )
    ) +

    ggplot2::geom_smooth(
      ggplot2::aes(
        x = fitted_values,
        y = scale_location_values
      ),
      method = "loess",
      se = FALSE,
      formula = y ~ x
    ) +

    ggplot2::geom_text(
      ggplot2::aes(
        x = label_fitted,
        y = label_scale_location,
        label = label_observations
      ),
      nudge_y = 0.05,
      check_overlap = TRUE
    ) +

    ggplot2::labs(
      title = "Scale-Location",
      x = "Fitted values",
      y = "Sqrt(|Standardized residuals|)"
    ) +

    ggplot2::theme_minimal()


  print(p1)
  print(p2)

  invisible(
    list(
      residuals_vs_fitted = p1,
      scale_location = p2
    )
  )
}

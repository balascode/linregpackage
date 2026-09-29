#' Plot Diagnostic Plots for a linreg Model
#'
#' Creates diagnostic plots for a fitted linreg model.
#'
#' The method produces two plots:
#' \itemize{
#'   \item Residuals vs Fitted
#'   \item Scale-Location
#' }
#'
#' @param x An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return A list containing two ggplot objects.
#'
#' @export
plot.linreg <- function(x, ...) {

  # Create data for the plots
  plot_data <- data.frame(
    fitted = x$fitted_values,
    residuals = x$residuals
  )

  # Standardized residuals
  plot_data$standardized_residuals <- x$residuals / x$sigma

  # Residuals vs Fitted
  p1 <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = fitted, y = residuals)
  ) +
    ggplot2::geom_point() +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed") +
    ggplot2::labs(
      title = "Residuals vs Fitted",
      x = "Fitted values",
      y = "Residuals"
    ) +
    ggplot2::theme_minimal()

  # Scale-Location
  p2 <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = fitted,
      y = sqrt(abs(standardized_residuals))
    )
  ) +
    ggplot2::geom_point() +
    ggplot2::labs(
      title = "Scale-Location",
      x = "Fitted values",
      y = "Sqrt(|Standardized residuals|)"
    ) +
    ggplot2::theme_minimal()

  print(p1)
  print(p2)

  invisible(list(
    residuals_vs_fitted = p1,
    scale_location = p2
  ))
}

#' Solve Ridge Regression Using QR Decomposition
#'
#' Internal helper used to calculate ridge regression coefficients
#' using QR decomposition.
#'
#' @param X Numeric model matrix.
#' @param y Numeric response vector.
#' @param lambda Non-negative ridge penalty.
#' @param has_intercept Logical indicating whether the first column
#'   of X is an intercept.
#'
#' @return A numeric vector of ridge regression coefficients.
#'
#' @keywords internal
ridge_qr <- function(X, y, lambda, has_intercept = TRUE) {

  p <- ncol(X)

  penalty_matrix <- diag(p)

  if (has_intercept) {
    penalty_matrix[1, 1] <- 0
  }

  augmented_X <- rbind(
    X,
    sqrt(lambda) * penalty_matrix
  )

  augmented_y <- c(
    y,
    rep(0, p)
  )

  coefficients <- qr.solve(
    augmented_X,
    augmented_y
  )

  as.numeric(coefficients)
}

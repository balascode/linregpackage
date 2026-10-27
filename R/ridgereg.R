#' Ridge Regression
#'
#' Fits a ridge regression model using a formula, a data frame,
#' and a non-negative regularization parameter lambda.
#'
#' @param formula A model formula.
#' @param data A data frame containing the variables in the model.
#' @param lambda A single non-negative numeric regularization parameter.
#'
#' @return An object of class \code{ridgereg}.
#'
#' @importFrom stats model.frame model.response terms model.matrix sd .getXlevels
#' @export
ridgereg <- function(formula, data, lambda) {

  # -----------------------------
  # Validate the inputs
  # -----------------------------

  if (!inherits(formula, "formula")) {
    stop("formula must be a formula.")
  }

  if (!is.data.frame(data)) {
    stop("data must be a data frame.")
  }

  if (
    !is.numeric(lambda) ||
    length(lambda) != 1 ||
    !is.finite(lambda) ||
    lambda < 0
  ) {
    stop("lambda must be a single non-negative finite number.")
  }

  # -----------------------------
  # Create model data
  # -----------------------------

  model_frame <- model.frame(
    formula = formula,
    data = data
  )

  y <- model.response(model_frame)

  if (!is.numeric(y)) {
    stop("The response variable must be numeric.")
  }

  terms_object <- terms(model_frame)

  X <- model.matrix(
    terms_object,
    data = model_frame
  )

  # -----------------------------
  # Separate the intercept
  # -----------------------------

  has_intercept <- attr(
    terms_object,
    "intercept"
  ) == 1

  if (has_intercept) {

    predictor_matrix <- X[, -1, drop = FALSE]

  } else {

    predictor_matrix <- X
  }

  # -----------------------------
  # Normalize predictors
  # -----------------------------

  predictor_means <- colMeans(
    predictor_matrix
  )

  predictor_scales <- apply(
    predictor_matrix,
    2,
    sd
  )

  if (any(predictor_scales == 0)) {
    stop(
      "Predictor variables must have non-zero variance."
    )
  }

  X_scaled <- scale(
    predictor_matrix,
    center = predictor_means,
    scale = predictor_scales
  )

  # -----------------------------
  # Add intercept after scaling
  # -----------------------------

  if (has_intercept) {

    X_ridge <- cbind(
      "(Intercept)" = 1,
      X_scaled
    )

  } else {

    X_ridge <- X_scaled
  }

  # -----------------------------
  # Ridge penalty matrix
  # -----------------------------

  penalty <- diag(
    ncol(X_ridge)
  )

  if (has_intercept) {
    penalty[1, 1] <- 0
  }

  # -----------------------------
  # Estimate ridge coefficients
  # -----------------------------

  beta_scaled <- solve(
    crossprod(X_ridge) +
      lambda * penalty,
    crossprod(X_ridge, y)
  )

  beta_scaled <- as.numeric(
    beta_scaled
  )

  names(beta_scaled) <- colnames(
    X_ridge
  )

  # -----------------------------
  # Convert coefficients back to
  # the original predictor scale
  # -----------------------------

  predictor_coefficients <-
    beta_scaled[
      if (has_intercept) {
        -1
      } else {
        seq_along(beta_scaled)
      }
    ] /
    predictor_scales

  if (has_intercept) {

    intercept <-
      beta_scaled[1] -
      sum(
        predictor_means *
          predictor_coefficients
      )

    coefficients <- c(
      intercept,
      predictor_coefficients
    )

    names(coefficients)[1] <- "(Intercept)"

  } else {

    coefficients <- predictor_coefficients
  }

  # -----------------------------
  # Calculate fitted values
  # -----------------------------

  fitted_values <- as.numeric(
    X_ridge %*% beta_scaled
  )

  residuals <- y - fitted_values

  # -----------------------------
  # Store everything required by
  # later methods such as predict()
  # -----------------------------

  result <- list(
    call = match.call(),
    formula = formula,
    terms = terms_object,
    coefficients = coefficients,
    coefficients_scaled = beta_scaled,
    fitted_values = fitted_values,
    residuals = residuals,
    lambda = lambda,
    predictor_means = predictor_means,
    predictor_scales = predictor_scales,
    has_intercept = has_intercept,
    xlevels = .getXlevels(
      terms_object,
      model_frame
    )
  )

  class(result) <- "ridgereg"

  result
}

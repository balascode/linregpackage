#' Ridge Regression
#'
#' Fits a ridge regression model using a formula, a data frame,
#' and a non-negative regularization parameter lambda.
#'
#' The predictor variables are standardized before fitting the model.
#' Ridge regression coefficients are estimated using QR decomposition.
#'
#' @param formula A model formula describing the relationship between
#'   the response variable and the predictor variables.
#' @param data A data frame containing the variables used in the model.
#' @param lambda A single non-negative numeric value controlling the
#'   strength of the ridge penalty.
#'
#' @return An object of class \code{ridgereg} containing the estimated
#'   coefficients, fitted values, residuals, model information, and the
#'   value of lambda used when fitting the model.
#'
#' @examples
#' fit <- ridgereg(
#'   mpg ~ wt + hp,
#'   data = mtcars,
#'   lambda = 1
#' )
#'
#' print(fit)
#' coef(fit)
#' predict(fit, newdata = mtcars[1:3, ])
#'
#' @importFrom stats model.frame model.response terms model.matrix sd .getXlevels
#' @export
ridgereg <- function(formula, data, lambda) {

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

  has_intercept <- attr(
    terms_object,
    "intercept"
  ) == 1

  if (has_intercept) {

    predictor_matrix <- X[, -1, drop = FALSE]

  } else {

    predictor_matrix <- X
  }

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

  if (has_intercept) {

    X_ridge <- cbind(
      "(Intercept)" = 1,
      X_scaled
    )

  } else {

    X_ridge <- X_scaled
  }

  penalty <- diag(
    ncol(X_ridge)
  )

  if (has_intercept) {
    penalty[1, 1] <- 0
  }

  beta_scaled <- ridge_qr(
    X = X_ridge,
    y = y,
    lambda = lambda,
    has_intercept = has_intercept
  )

  beta_scaled <- as.numeric(
    beta_scaled
  )

  names(beta_scaled) <- colnames(
    X_ridge
  )

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

  fitted_values <- as.numeric(
    X_ridge %*% beta_scaled
  )

  residuals <- y - fitted_values

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

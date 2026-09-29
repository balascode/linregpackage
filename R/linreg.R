#' Fit a Linear Regression Model
#'
#' Fits a multiple linear regression model using QR decomposition.
#'
#' The function creates a design matrix from the supplied formula and data,
#' extracts the response variable, and estimates the regression coefficients
#' using a QR decomposition of the design matrix.
#'
#' It also calculates fitted values, residuals, degrees of freedom,
#' residual variance, standard errors, t-values and p-values. The calculated
#' values are stored in an object of class \code{linreg}, which can later be
#' used together with methods such as \code{print()}, \code{coef()},
#' \code{resid()}, \code{pred()}, \code{summary()} and \code{plot()}.
#'
#' @param formula A formula describing the regression model. The variable on
#'   the left-hand side is the response variable and the variables on the
#'   right-hand side are the explanatory variables.
#' @param data A data frame containing the variables used in \code{formula}.
#'
#' @return An object of class \code{linreg}. The object contains:
#' \describe{
#'   \item{call}{The original function call.}
#'   \item{formula}{The model formula.}
#'   \item{coefficients}{The estimated regression coefficients.}
#'   \item{fitted_values}{The fitted values of the model.}
#'   \item{residuals}{The model residuals.}
#'   \item{df}{The residual degrees of freedom.}
#'   \item{residual_variance}{The estimated residual variance.}
#'   \item{sigma}{The estimated residual standard deviation.}
#'   \item{variance_coefficients}{The variance-covariance matrix of the
#'     regression coefficients.}
#'   \item{standard_errors}{The standard errors of the coefficients.}
#'   \item{t_values}{The t-statistics of the coefficients.}
#'   \item{p_values}{The two-sided p-values of the coefficients.}
#'   \item{X}{The design matrix.}
#'   \item{y}{The response vector.}
#'   \item{data}{The original data frame.}
#' }
#'
#' @examples
#' model <- linreg(
#'   Petal.Length ~ Sepal.Length + Sepal.Width,
#'   data = iris
#' )
#'
#' model$coefficients
#' model$residuals
#'
#' @export
linreg <- function(formula, data) {

  if (!inherits(formula, "formula")) {
    stop("formula must be a formula object")
  }

  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }

  X <- stats::model.matrix(formula, data)

  response_name <- all.vars(formula)[1]
  y <- data[[response_name]]

  if (!is.numeric(y)) {
    stop("response variable must be numeric")
  }

  qr_decomp <- qr(X)

  if (qr_decomp$rank < ncol(X)) {
    stop("design matrix is rank deficient")
  }

  Q <- qr.Q(qr_decomp)
  R <- qr.R(qr_decomp)

  beta_pivoted <- solve(R, crossprod(Q, y))

  beta <- numeric(ncol(X))
  beta[qr_decomp$pivot] <- as.vector(beta_pivoted)
  names(beta) <- colnames(X)

  fitted_values <- as.vector(X %*% beta)
  residuals <- as.vector(y - fitted_values)

  n <- nrow(X)
  p <- ncol(X)
  df <- n - p

  if (df <= 0) {
    stop("not enough observations to estimate the model")
  }

  residual_variance <- as.numeric(
    crossprod(residuals) / df
  )

  sigma <- sqrt(residual_variance)

  R_inverse <- solve(R)

  variance_pivoted <-
    residual_variance *
    (R_inverse %*% t(R_inverse))

  variance_coefficients <- matrix(
    0,
    nrow = p,
    ncol = p
  )

  variance_coefficients[
    qr_decomp$pivot,
    qr_decomp$pivot
  ] <- variance_pivoted

  rownames(variance_coefficients) <- colnames(X)
  colnames(variance_coefficients) <- colnames(X)

  standard_errors <- sqrt(
    diag(variance_coefficients)
  )

  names(standard_errors) <- names(beta)

  t_values <- beta / standard_errors

  p_values <- 2 * stats::pt(
    abs(t_values),
    df = df,
    lower.tail = FALSE
  )

  names(p_values) <- names(beta)

  result <- list(
    call = match.call(),
    formula = formula,
    coefficients = beta,
    fitted_values = fitted_values,
    residuals = residuals,
    df = df,
    residual_variance = residual_variance,
    sigma = sigma,
    variance_coefficients = variance_coefficients,
    standard_errors = standard_errors,
    t_values = t_values,
    p_values = p_values,
    X = X,
    y = y,
    data = data
  )

  class(result) <- "linreg"

  return(result)
}

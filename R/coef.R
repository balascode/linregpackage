#' Extract Regression Coefficients
#'
#' Extracts the estimated regression coefficients from a fitted
#' \code{linreg} model.
#'
#' @param object An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return A named numeric vector containing the estimated regression
#'   coefficients.
#'
#' @importFrom stats coef
#' @export
coef.linreg <- function(object, ...) {
  return(object$coefficients)
}

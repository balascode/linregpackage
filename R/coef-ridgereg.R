#' Extract Ridge Regression Coefficients
#'
#' Returns the estimated coefficients from a ridgereg object.
#'
#' @param object An object of class \code{ridgereg}.
#' @param ... Additional arguments, currently unused.
#'
#' @return A named numeric vector containing the ridge regression coefficients.
#'
#' @export
coef.ridgereg <- function(object, ...) {
  object$coefficients
}

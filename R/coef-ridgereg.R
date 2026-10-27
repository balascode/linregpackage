#' Extract Ridge Regression Coefficients
#'
#' Returns the estimated coefficients from a fitted
#' \code{ridgereg} model.
#'
#' @param object An object of class \code{ridgereg}.
#' @param ... Additional arguments, currently unused.
#'
#' @return A named numeric vector containing the ridge regression
#'   coefficients.
#'
#' @examples
#' fit <- ridgereg(
#'   mpg ~ wt + hp,
#'   data = mtcars,
#'   lambda = 1
#' )
#'
#' coef(fit)
#'
#' @export
coef.ridgereg <- function(object, ...) {
  object$coefficients
}

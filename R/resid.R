#' Extract Residuals from a linreg Model
#'
#' Returns the residuals from a fitted linreg model.
#'
#' @param object An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return A numeric vector containing the residuals.
#'
#' @importFrom stats resid
#' @export
resid.linreg <- function(object, ...) {
  return(object$residuals)
}

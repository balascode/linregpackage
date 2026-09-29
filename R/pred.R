#' Extract Predicted Values from a linreg Model
#'
#' Returns the predicted values from a fitted linreg model.
#'
#' @param object An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return A numeric vector containing the predicted values.
#'
#' @export
pred <- function(object, ...) {
  UseMethod("pred")
}


#' @rdname pred
#' @export
pred.linreg <- function(object, ...) {
  return(object$fitted_values)
}

#' Predict Values from a Ridge Regression Model
#'
#' Calculates predicted values from a fitted \code{ridgereg} model.
#' If \code{newdata} is not provided, the fitted values from the
#' original model are returned.
#'
#' @param object An object of class \code{ridgereg}.
#' @param newdata An optional data frame containing new observations.
#'   The predictor variables should match those used when fitting the model.
#' @param ... Additional arguments, currently not used.
#'
#' @return A numeric vector containing predicted values.
#'
#' @examples
#' fit <- ridgereg(
#'   mpg ~ wt + hp,
#'   data = mtcars,
#'   lambda = 1
#' )
#'
#' predict(fit)
#'
#' new_cars <- mtcars[1:3, ]
#' predict(fit, newdata = new_cars)
#'
#' @export
predict.ridgereg <- function(object, newdata = NULL, ...) {

  if (is.null(newdata)) {
    return(object$fitted_values)
  }

  if (!is.data.frame(newdata)) {
    stop("newdata must be a data frame.")
  }

  new_terms <- stats::delete.response(object$terms)

  new_model_frame <- stats::model.frame(
    new_terms,
    data = newdata,
    xlev = object$xlevels,
    na.action = stats::na.fail
  )

  X_new <- stats::model.matrix(
    new_terms,
    data = new_model_frame
  )

  coefficients <- object$coefficients

  if (!identical(colnames(X_new), names(coefficients))) {
    stop("newdata does not match the model predictors.")
  }

  predicted_values <- as.numeric(
    X_new %*% coefficients
  )

  return(predicted_values)
}

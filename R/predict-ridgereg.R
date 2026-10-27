
#' Predict Values from a Ridge Regression Model
#'
#' Calculates predicted values from a fitted ridgereg model.
#' If newdata is not provided, returns the fitted values.
#'
#' @param object An object of class \code{ridgereg}.
#' @param newdata An optional data frame containing new observations.
#' @param ... Additional arguments, currently not used.
#'
#' @return A numeric vector containing predicted values.
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

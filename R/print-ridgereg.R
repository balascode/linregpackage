#' Print a Ridge Regression Model
#'
#' Prints the model call and estimated regression coefficients
#' from a fitted \code{ridgereg} model.
#'
#' @param x An object of class \code{ridgereg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return The \code{ridgereg} object, returned invisibly.
#'
#' @examples
#' fit <- ridgereg(
#'   mpg ~ wt + hp,
#'   data = mtcars,
#'   lambda = 1
#' )
#'
#' print(fit)
#'
#' @export
print.ridgereg <- function(x, ...) {

  cat("Call:\n")
  print(x$call)

  cat("\nCoefficients:\n")
  print(x$coefficients)

  invisible(x)
}

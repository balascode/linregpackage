#' Print a linreg Model
#'
#' Prints the model call and estimated regression coefficients
#' from a fitted linreg model.
#'
#' @param x An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return The linreg object, returned invisibly.
#'
#' @export
print.linreg <- function(x, ...) {

  cat("Call:\n")
  print(x$call)

  cat("\nCoefficients:\n")
  print(x$coefficients)

  invisible(x)
}

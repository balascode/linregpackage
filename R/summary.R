#' Summarize a linreg Model
#'
#' Produces a summary of a fitted \code{linreg} model.
#'
#' The summary contains the estimated regression coefficients,
#' standard errors, t-values, p-values, significance codes,
#' residual standard error and residual degrees of freedom.
#'
#' @param object An object of class \code{linreg}.
#' @param ... Additional arguments, currently not used.
#'
#' @return The fitted \code{linreg} object, returned invisibly.
#'
#' @export
summary.linreg <- function(object, ...) {

  coefficient_table <- cbind(
    Estimate = object$coefficients,
    `Std. Error` = object$standard_errors,
    `t value` = object$t_values,
    `Pr(>|t|)` = object$p_values
  )

  cat("Call:\n")
  print(object$call)

  cat("\nCoefficients:\n")

  stats::printCoefmat(
    coefficient_table,
    P.values = TRUE,
    has.Pvalue = TRUE,
    signif.stars = TRUE
  )

  cat(
    "\nResidual standard error:",
    object$sigma,
    "on",
    object$df,
    "degrees of freedom\n"
  )

  invisible(object)
}

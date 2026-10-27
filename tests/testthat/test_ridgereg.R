
data("iris")

test_that("ridgereg rejects incorrect inputs", {

  expect_error(
    ridgereg(Petal.Length ~ Sepdsal.Width, data = iris, lambda = 1)
  )

  expect_error(
    ridgereg(Petal.Length ~ Sepal.Width, data = iris, lambda = -1)
  )

  expect_error(
    ridgereg(Petal.Length ~ Sepal.Width, data = iris, lambda = NA_real_)
  )

})

test_that("ridgereg returns the correct class", {

  ridge_model <- ridgereg(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris,
    lambda = 1
  )

  expect_s3_class(ridge_model, "ridgereg")

})

test_that("print.ridgereg displays the call and coefficients", {

  ridge_model <- ridgereg(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris,
    lambda = 1
  )

  expect_output(
    print(ridge_model),
    "Call:"
  )

  expect_output(
    print(ridge_model),
    "Coefficients:"
  )

  expect_output(
    print(ridge_model),
    "Sepal.Width"
  )

})

test_that("coef.ridgereg returns named coefficients", {

  ridge_model <- ridgereg(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris,
    lambda = 1
  )

  ridge_coefficients <- coef(ridge_model)

  expect_type(ridge_coefficients, "double")

  expect_named(
    ridge_coefficients,
    c("(Intercept)", "Sepal.Width", "Sepal.Length")
  )

  expect_equal(
    ridge_coefficients,
    ridge_model$coefficients
  )

})

test_that("predict.ridgereg returns fitted values", {

  ridge_model <- ridgereg(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris,
    lambda = 1
  )

  expect_equal(
    predict(ridge_model),
    ridge_model$fitted_values
  )

})

test_that("predict.ridgereg handles new observations", {

  ridge_model <- ridgereg(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris,
    lambda = 1
  )

  new_data <- iris[1:5, , drop = FALSE]

  predicted <- predict(
    ridge_model,
    newdata = new_data
  )

  expected <- as.numeric(
    stats::model.matrix(
      ~ Sepal.Width + Sepal.Length,
      data = new_data
    ) %*% coef(ridge_model)
  )

  expect_equal(predicted, expected)
  expect_length(predicted, 5)

})

test_that("ridgereg agrees with lm when lambda is zero", {

  ridge_model <- ridgereg(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris,
    lambda = 0
  )

  lm_model <- stats::lm(
    Petal.Length ~ Sepal.Width + Sepal.Length,
    data = iris
  )

  expect_equal(
    unname(coef(ridge_model)),
    unname(coef(lm_model)),
    tolerance = 1e-8
  )

})

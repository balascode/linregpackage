# linregpackage

<!-- badges: start -->
[![R-CMD-check](https://github.com/balascode/linregpackage/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/balascode/linregpackage/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`linregpackage` is an R package for fitting linear and ridge regression models.

The package was developed as part of the Advanced R Programming course (732A94) at Linköping University. It includes implementations of multiple linear regression and ridge regression, together with S3 methods, unit tests, vignettes, and a small data visualization example using flight data.

## Main functionality

The package currently provides:

- `linreg()` for multiple linear regression.
- `ridgereg()` for ridge regression.
- S3 methods for working with fitted regression models.
- `visualize_airport_delays()` for visualizing mean arrival delays by destination airport.
- Vignettes demonstrating the use of the regression functions and model evaluation.

Both the linear regression and ridge regression implementations use QR decomposition for solving the regression problem.

The ridge regression implementation also standardizes the predictor variables before fitting the model. The amount of regularization is controlled by the `lambda` argument.

## Installation

The package can be installed directly from GitHub using `devtools`.

```r
install.packages("devtools")

devtools::install_github(
  "balascode/linregpackage"
)
```

Then load the package with:

```r
library(linregpackage)
```

## Linear regression

The `linreg()` function fits a multiple linear regression model and returns an object of class `linreg`.

```r
model <- linreg(
  Petal.Length ~ Sepal.Width + Sepal.Length,
  data = iris
)

print(model)
coef(model)
head(resid(model))
head(pred(model))
summary(model)
plot(model)
```

A fitted `linreg` object supports the following methods:

- `print()`
- `coef()`
- `resid()`
- `pred()`
- `summary()`
- `plot()`

## Ridge regression

The `ridgereg()` function fits a ridge regression model using a formula, a data frame, and a non-negative value of `lambda`.

```r
ridge_model <- ridgereg(
  Petal.Length ~ Sepal.Width + Sepal.Length,
  data = iris,
  lambda = 1
)

print(ridge_model)
coef(ridge_model)
```

Predictions for new observations can be made using `predict()`:

```r
predict(
  ridge_model,
  newdata = iris[1:5, ]
)
```

A fitted `ridgereg` object supports:

- `print()`
- `coef()`
- `predict()`

The `lambda` parameter controls the strength of the ridge penalty. A larger value applies stronger regularization and shrinks the predictor coefficients more towards zero.

## Ridge regression analysis

The package includes a `ridgereg` vignette that uses the `BostonHousing` dataset from the `mlbench` package.

The analysis compares:

1. ordinary linear regression,
2. linear regression with forward variable selection,
3. ridge regression.

The data is divided into training and test sets. For ridge regression, different values of `lambda` are evaluated using 10-fold cross-validation. The final models are then compared using RMSE on the test data.

The vignette can be opened after installing the package with:

```r
browseVignettes("linregpackage")
```

## Airport delay visualization

The package also contains `visualize_airport_delays()`, which uses data from the `nycflights13` package.

The function calculates the mean arrival delay for each destination airport, joins the result with airport longitude and latitude information, and creates a plot using `ggplot2`.

```r
visualize_airport_delays()
```

The data preparation is performed mainly with `dplyr`.

## Testing

Unit tests are included using the `testthat` package.

The ridge regression implementation is also compared with `MASS::lm.ridge()` to check that the estimated coefficients are similar.

The tests can be run from the package project with:

```r
devtools::test()
```

A complete package check can be run with:

```r
devtools::check()
```

## References

The following packages and resources were used during the development and evaluation of the package:

- Venables, W. N. and Ripley, B. D. — [`MASS`](https://cran.r-project.org/package=MASS), including `lm.ridge()` for comparison with the ridge regression implementation.
- Kuhn, M. — [`caret`](https://cran.r-project.org/package=caret), used for data partitioning and cross-validation in the ridge regression analysis.
- Leisch, F. and Dimitriadou, E. — [`mlbench`](https://cran.r-project.org/package=mlbench), which provides the `BostonHousing` dataset used in the vignette.
- Wickham, H. — [`ggplot2`](https://cran.r-project.org/package=ggplot2), used for visualization.
- Wickham, H. et al. — [`dplyr`](https://cran.r-project.org/package=dplyr), used for data manipulation.
- Wickham, H. — [`nycflights13`](https://cran.r-project.org/package=nycflights13), which provides the flight and airport data used by `visualize_airport_delays()`.

## Authors

Venkata Balaji Anupoju  
Marwan Karim

# linregpackage

<!-- badges: start -->
[![R-CMD-check](https://github.com/balascode/linregpackage/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/balascode/linregpackage/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`linregpackage` is an R package implementing multiple linear regression
using QR decomposition and S3 methods.

The package was developed for Advanced R Programming (732A94) at
Linköping University.

## Approach

The package uses:

- QR decomposition for estimating the regression coefficients.
- S3 classes and methods for working with fitted regression models.

The main function is `linreg()`, which returns an object of class
`linreg`.

## Available methods

A fitted `linreg` object can be used with:

- `print()`
- `coef()`
- `resid()`
- `pred()`
- `summary()`
- `plot()`

## Example

```r
library(linregpackage)

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

## Installation

Install the package from GitHub using `devtools`:

```r
install.packages("devtools")
devtools::install_github("balascode/linregpackage")
```

Then load it and run an example:

```r
library(linregpackage)

model <- linreg(Petal.Length ~ Sepal.Width + Sepal.Length, data = iris)
summary(model)
```

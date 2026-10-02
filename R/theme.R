#' Linkoping University Colour Palette
#'
#' Returns colours based on the Linkoping University graphical profile.
#'
#' The three LiU base colours are placed first so that they dominate
#' the palette. Complementary colours are available for additional
#' categories when needed.
#'
#' @return A named character vector containing LiU colours.
#'
#' @export
liu_palette <- function() {

  c(
    blue = "#00B9E7",
    turquoise = "#17C7D2",
    green = "#00CFB5",
    orange = "#FF6442",
    purple = "#8981D3",
    yellow = "#FDEF5D",
    grey = "#6A7E91"
  )
}


#' Linkoping University ggplot2 Theme
#'
#' Creates a ggplot2 theme based on the graphical profile
#' of Linkoping University.
#'
#' @param base_size Base font size.
#' @param base_family Base font family.
#'
#' @return A ggplot2 theme object.
#'
#' @export
theme_liu <- function(base_size = 11, base_family = "") {

  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family
  ) +
    ggplot2::theme(

      # Light LiU turquoise background
      plot.background = ggplot2::element_rect(
        fill = "#D1F4F6",
        colour = NA
      ),

      # White plotting area
      panel.background = ggplot2::element_rect(
        fill = "white",
        colour = NA
      ),

      # Text should be black or white according to the manual
      text = ggplot2::element_text(
        colour = "black"
      ),

      plot.title = ggplot2::element_text(
        face = "bold",
        colour = "black",
        size = ggplot2::rel(1.5)
      ),

      plot.subtitle = ggplot2::element_text(
        colour = "black"
      ),

      axis.title = ggplot2::element_text(
        face = "bold",
        colour = "black"
      ),

      axis.text = ggplot2::element_text(
        colour = "black"
      ),

      # Clean LiU-style grid
      panel.grid.minor = ggplot2::element_blank(),

      panel.grid.major.x = ggplot2::element_blank(),

      panel.grid.major.y = ggplot2::element_line(
        colour = "grey85",
        linewidth = 0.4
      ),

      # LiU turquoise facet headers
      strip.background = ggplot2::element_rect(
        fill = "#17C7D2",
        colour = NA
      ),

      strip.text = ggplot2::element_text(
        face = "bold",
        colour = "black"
      ),

      legend.position = "bottom",

      legend.title = ggplot2::element_text(
        face = "bold",
        colour = "black"
      ),

      legend.text = ggplot2::element_text(
        colour = "black"
      ),

      plot.margin = ggplot2::margin(
        15, 20, 15, 20
      )
    )
}


#' Linkoping University Colour Scale
#'
#' Applies colours from the Linkoping University graphical profile
#' to discrete colour aesthetics.
#'
#' @param ... Additional arguments passed to
#'   \code{ggplot2::scale_colour_manual()}.
#'
#' @return A ggplot2 discrete colour scale.
#'
#' @export
scale_colour_liu <- function(...) {

  ggplot2::scale_colour_manual(
    values = unname(liu_palette()),
    ...
  )
}


#' Linkoping University Fill Scale
#'
#' Applies colours from the Linkoping University graphical profile
#' to discrete fill aesthetics.
#'
#' @param ... Additional arguments passed to
#'   \code{ggplot2::scale_fill_manual()}.
#'
#' @return A ggplot2 discrete fill scale.
#'
#' @export
scale_fill_liu <- function(...) {

  ggplot2::scale_fill_manual(
    values = unname(liu_palette()),
    ...
  )
}

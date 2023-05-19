#' Get nodes
#'
#' Define the corners of the nodes.
#'
#' @param node_layout Data frame of node layout returned by \code{get_layout()}
#' @param x_nudge Distance from centre of edge of node box in x direction.
#' Default 0.35.
#' @param y_nudge Distance from centre of edge of node box in y direction.
#' Default 0.25.
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#' @return A tibble.
#' @noRd

get_nodes <- function(node_layout,
                      x_nudge = 0.35,
                      y_nudge = 0.25) {
  # if x_nudge not specified use global values
  if (!("x_nudge" %in% colnames(node_layout))) {
    node_layout$x_nudge <- x_nudge
  }
  # if y_nudge not specified use global values
  if (!("y_nudge" %in% colnames(node_layout))) {
    node_layout$y_nudge <- y_nudge
  }
  # define corners
  plot_nodes <- node_layout %>%
    dplyr::mutate(xmin = .data$x - .data$x_nudge,
                  xmax = .data$x + .data$x_nudge,
                  ymin = .data$y - .data$y_nudge,
                  ymax = .data$y + .data$y_nudge)
  return(plot_nodes)
}

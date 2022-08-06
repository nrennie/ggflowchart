#' Get nodes
#'
#' Define the corners of the nodes.
#'
#' @param node_layout Data frame of node layout returned by \code{get_layout()}
#' @param x_nudge Distance from centre of edge of node box in x direction. Default 0.35.
#' @param y_nudge Distance from centre of edge of node box in y direction. Default 0.25.
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#' @return A tibble.

get_nodes <- function(node_layout,
                      x_nudge = 0.35,
                      y_nudge = 0.25) {
  plot_nodes <- node_layout %>%
    dplyr::mutate(xmin = .data$x - x_nudge,
                  xmax = .data$x + x_nudge,
                  ymin = .data$y - y_nudge,
                  ymax = .data$y + y_nudge)
  return(plot_nodes)
}

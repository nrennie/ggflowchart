#' Single arrow direction
#'
#' Define the direction of a single arrow
#'
#' @param plot_nodes Tibble of node coordinates output from \code{get_nodes()}.
#' @param from Character name of starting node.
#' @param to Character name of end node.
#' @importFrom rlang .data
#' @return A tibble.
#' @noRd

single_arrow_direction <- function(plot_nodes,
                                   from,
                                   to) {
  # calculate slope
  from_coords <- unlist(dplyr::filter(plot_nodes, .data$name == from)[, c("x", "y")])
  to_coords <- unlist(dplyr::filter(plot_nodes, .data$name == to)[, c("x", "y")])
  x_diff <- to_coords["x"] - from_coords["x"]
  y_diff <- (to_coords["y"] - from_coords["y"])
  # arrow type
  if (y_diff == 0 && x_diff > 0) {
    return("lr")
  } else if (y_diff == 0 && x_diff < 0) {
    return("rl")
  } else if (y_diff > 0) {
    return("bt")
  } else {
    return("tb")
  }
}

#' Arrow direction
#'
#' Define the direction of each arrow
#' @param data Data frame or tibble of edges. Must have two columns, first
#' column are "from" node names, second column is "to" node names.
#' Node names must be unique.
#' @param plot_nodes Tibble of node coordinates output from \code{get_nodes()}.
#' @param node_layout Data frame of node layout returned by \code{get_layout()}
#' @importFrom rlang .data
#' @return A tibble.
#' @noRd

arrow_direction <- function(data,
                            plot_nodes,
                            node_layout) {
  data %>%
    dplyr::mutate(
      arrow_direction = purrr::map2(
        .x = data$from,
        .y = data$to,
        .f = ~ single_arrow_direction(node_layout, .x, .y)
      ) %>%
        unlist()
    )
}

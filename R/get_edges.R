#' Get edges
#'
#' Define the end points of the arrows
#'
#' @param data Data frame or tibble of edges. Must have at least two columns, if not labelled "from"
#' and "to" it is assumed first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @param plot_nodes Tibble of node coordinates output from \code{get_nodes()}.
#' @param node_layout Data frame of node layout returned by \code{get_layout()}
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#' @return A tibble.
#' @noRd

get_edges <- function(data, plot_nodes, node_layout) {
  if (ncol(data) < 2) {
    stop("Incorrect number of columns in data: input data should contain at least two columns.")
  }
  if (!all(c("from", "to") %in% colnames(data))) {
    colnames(data)[1:2] <- c("from", "to")
  }
  # define edge types
  edge_type_data <- arrow_direction(
    data = data,
    plot_nodes = plot_nodes,
    node_layout = node_layout
    )
  # compute start and end points for each type of edge
  # Downwards (default)
  plot_edge_down <- edge_type_data %>%
    dplyr::filter(.data$arrow_direction == "down") %>%
    dplyr::select(c(.data$from, .data$to)) %>%
    dplyr::mutate(id = paste("down", dplyr::row_number())) %>%
    tidyr::pivot_longer(cols = c("from", "to"),
                        names_to = "s_e",
                        values_to = "name") %>%
    dplyr::left_join(dplyr::select(plot_nodes, -c(x_nudge, y_nudge)), by = "name") %>%
    dplyr::select(-c(.data$y,
                     .data$xmin,
                     .data$xmax)) %>%
    dplyr::mutate(y = ifelse(.data$s_e == "from",
                             .data$ymin,
                             .data$ymax)) %>%
    dplyr::select(-c(.data$ymin,
                     .data$ymax))
  # Upwards - to do
  plot_edge_up <- edge_type_data %>%
    dplyr::filter(.data$arrow_direction == "up") %>%
    dplyr::select(c(.data$from, .data$to)) %>%
    dplyr::mutate(id = paste("up", dplyr::row_number())) %>%
    tidyr::pivot_longer(cols = c("from", "to"),
                        names_to = "s_e",
                        values_to = "name") %>%
    dplyr::left_join(dplyr::select(plot_nodes, -c(x_nudge, y_nudge)), by = "name") %>%
    dplyr::select(-c(.data$y,
                     .data$xmin,
                     .data$xmax)) %>%
    dplyr::mutate(y = ifelse(.data$s_e == "from",
                             .data$ymin,
                             .data$ymax)) %>%
    dplyr::select(-c(.data$ymin,
                     .data$ymax))
  # Left to right
  plot_edge_lr <- edge_type_data %>%
    dplyr::filter(.data$arrow_direction == "lr") %>%
    dplyr::select(c(.data$from, .data$to)) %>%
    dplyr::mutate(id = paste("lr", dplyr::row_number())) %>%
    tidyr::pivot_longer(cols = c("from", "to"),
                        names_to = "s_e",
                        values_to = "name") %>%
    dplyr::left_join(
      dplyr::select(plot_nodes, -c(x_nudge, y_nudge)),
      by = "name"
    ) %>%
    dplyr::select(-c(.data$x,
                     .data$ymin,
                     .data$ymax)) %>%
    dplyr::mutate(x = ifelse(.data$s_e == "from",
                             .data$xmax,
                             .data$xmin)) %>%
    dplyr::select(-c(.data$xmin,
                     .data$xmax))
  # right to left - to do
  plot_edge_rl <- edge_type_data %>%
    dplyr::filter(.data$arrow_direction == "rl") %>%
    dplyr::select(c(.data$from, .data$to)) %>%
    dplyr::mutate(id = paste("rl", dplyr::row_number())) %>%
    tidyr::pivot_longer(cols = c("from", "to"),
                        names_to = "s_e",
                        values_to = "name") %>%
    dplyr::left_join(dplyr::select(plot_nodes, -c(x_nudge, y_nudge)), by = "name") %>%
    dplyr::select(-c(.data$y,
                     .data$xmin,
                     .data$xmax)) %>%
    dplyr::mutate(y = ifelse(.data$s_e == "from",
                             .data$ymin,
                             .data$ymax)) %>%
    dplyr::select(-c(.data$ymin,
                     .data$ymax))
  # join data set together
  plot_edges <- rbind(
    plot_edge_up, plot_edge_down, plot_edge_rl, plot_edge_lr
    )
  return(plot_edges)
}

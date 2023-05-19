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
  # compute start and end points
  plot_edges <- data %>%
    dplyr::select(c(.data$from, .data$to)) %>%
    dplyr::mutate(id = dplyr::row_number()) %>%
    tidyr::pivot_longer(cols = c("from", "to"),
                        names_to = "s_e",
                        values_to = "name") %>%
    dplyr::left_join(plot_nodes, by = "name") %>%
    dplyr::select(-c(.data$y,
                     .data$xmin,
                     .data$xmax)) %>%
    dplyr::mutate(y = ifelse(.data$s_e == "from",
                             .data$ymin,
                             .data$ymax)) %>%
    dplyr::select(-c(.data$ymin,
                     .data$ymax))
  return(plot_edges)
}

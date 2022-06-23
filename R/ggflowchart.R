#' Generate a flowchart in ggplot2
#'
#' Generates the flowchart
#'
#' @param data Data frame or tibble of edges. Must have two columns, first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @param node_data Data frame or tibble of node information. Must have at least one column
#' called "name" for node names to join by. Default NULL.
#' @importFrom rlang .data
#' @return A ggplot2 object.
#' @export

ggflowchart <- function(data, node_data = NULL) {
  # define position of nodes
  node_layout <- get_layout(data = data)
  # add edge attributes
  node_layout <- add_node_attr(node_layout, node_data)
  # define edges of node rectangles
  plot_nodes <- get_nodes(node_layout = node_layout)
  # define arrows
  plot_edges <- get_edges(data = data,
                          plot_nodes = plot_nodes)
  # create the flowchart
  p <- ggplot2::ggplot() +
    ggplot2::geom_rect(data = plot_nodes,
                       mapping = ggplot2::aes(xmin = .data$xmin,
                                              ymin = .data$ymin,
                                              xmax = .data$xmax,
                                              ymax = .data$ymax),
                       alpha = 0.5) +
    ggplot2::geom_text(data = plot_nodes,
                       mapping = ggplot2::aes(x = .data$x,
                                              y = .data$y,
                                              label = .data$name)) +
    ggplot2::geom_path(data = plot_edges,
                       mapping = ggplot2::aes(x = .data$x,
                                              y = .data$y,
                                              group = .data$id),
                       arrow = ggplot2::arrow(length = ggplot2::unit(0.3, "cm"),
                                              type = "closed")) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), unit = "cm"))
  return(p)
}

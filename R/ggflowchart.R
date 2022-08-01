#' Generate a flowchart in ggplot2
#'
#' Generates the flowchart
#'
#' @param data Data frame or tibble of edges. Must have two columns, first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @param node_data Data frame or tibble of node information. Must have at least one column
#' called "name" for node names to join by. Default NULL.
#' @param fill Fill colour of nodes. Must be a valid colour name or hex code. Default "white".
#' @param colour Outline colour of nodes. Must be a valid colour name or hex code. Default "black".
#' @param text_colour Colour of labels in nodes. Must be a valid colour name or hex code. Default "black".
#' @param arrow_colour Colour of arrows. Must be a valid colour name or hex code. Default "black".
#' @param family Font family for node labels. Default "sans"
#' @param x_nudge Distance from centre of edge of node box in x direction. Default 0.35.
#' @param y_nudge Distance from centre of edge of node box in y direction. Default 0.25.
#' @importFrom rlang .data
#' @return A ggplot2 object.
#' @export

ggflowchart <- function(data,
                        node_data = NULL,
                        fill = "white",
                        colour = "black",
                        text_colour = "black",
                        arrow_colour = "black",
                        family = "sans",
                        x_nudge = 0.35,
                        y_nudge = 0.25) {
  # define notin
  "%notin%" <- function(x, y) {
    !("%in%" (x, y))
  }
  # define position of nodes
  node_layout <- get_layout(data = data)
  # add edge attributes
  node_layout <- add_node_attr(node_layout, node_data)
  # define edges of node rectangles
  plot_nodes <- get_nodes(node_layout = node_layout,
                          x_nudge = x_nudge,
                          y_nudge = y_nudge)
  # check if labels exist as a column,
  # if not, add it as a duplicate of name
  if ("label" %notin% colnames(plot_nodes)) {
    plot_nodes <- dplyr::mutate(plot_nodes, label = .data$name)
  }
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
                       alpha = 0.5,
                       colour = colour,
                       fill = fill) +
    ggplot2::geom_text(data = plot_nodes,
                       mapping = ggplot2::aes(x = .data$x,
                                              y = .data$y,
                                              label = .data$label),
                       family = family,
                       colour = text_colour) +
    ggplot2::geom_path(data = plot_edges,
                       mapping = ggplot2::aes(x = .data$x,
                                              y = .data$y,
                                              group = .data$id),
                       arrow = ggplot2::arrow(length = ggplot2::unit(0.3, "cm"),
                                              type = "closed"),
                       colour = arrow_colour) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), unit = "cm"))
  return(p)
}

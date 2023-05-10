#' Generate a flowchart in ggplot2
#'
#' Generates the flowchart
#'
#' @param data Data frame or tibble of edges. Must have two columns, first
#' column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @param node_data Data frame or tibble of node information. Must have at
#' least one column
#' called "name" for node names to join by. Default NULL.
#' @param fill Fill colour of nodes. Must be a valid colour name or hex
#' code, or the name of a column in node_data (quoted or unquoted).
#' Column names take priority over names of colours. Default "white".
#' @param colour Outline colour of nodes. Must be a valid colour name or hex
#' code. Default "black".
#' @param text_colour Colour of labels in nodes. Must be a valid colour name
#' or hex code, or the name of a column in node_data (quoted or unquoted).
#' Column names take priority over names of colours. Default "black".
#' @param text_size Font size of labels in nodes. Default 3.88.
#' @param arrow_colour Colour of arrows. Must be a valid colour name or hex
#' code. Default "black".
#' @param arrow_size Size of arrow head. Default 0.3.
#' @param family Font family for node labels. Default "sans"
#' @param x_nudge Distance from centre of edge of node box in x direction.
#' Default 0.35.
#' @param y_nudge Distance from centre of edge of node box in y direction.
#' Default 0.25.
#' @param horizontal Boolean specifying if flowchart should go from left to
#' right. Default FALSE.
#' @param color Outline colour of nodes - overrides colour. Must be a valid colour name or hex
#' code. Default NULL.
#' @param text_color Colour of labels in nodes - overrides text_colour. Must be a valid colour name
#' or hex code. Default NULL.
#' @param arrow_color Colour of arrows - overrides arrow_colour. Must be a valid colour name or hex
#' code. Default NULL.
#' @importFrom rlang .data
#' @return A ggplot2 object.
#' @export
#' @examples
#' data <- tibble::tibble(from = c("A", "A", "A", "B", "C", "F"), to = c("B", "C", "D", "E", "F", "G"))
#' ggflowchart(data)
ggflowchart <- function(data,
                        node_data = NULL,
                        fill = "white",
                        colour = "black",
                        text_colour = "black",
                        text_size = 3.88,
                        arrow_colour = "black",
                        arrow_size = 0.3,
                        family = "sans",
                        x_nudge = 0.35,
                        y_nudge = 0.25,
                        horizontal = FALSE,
                        color = NULL,
                        text_color = NULL,
                        arrow_color = NULL) {
  # define notin
  "%notin%" <- function(x, y) {
    !("%in%"(x, y))
  }
  # convert arguments
  fill <- rlang::ensym(fill)
  text_colour <- rlang::ensym(text_colour)
  # set colours
  if (!is.null(color)) {
    colour <- color
  }
  if (!is.null(rlang::enexpr(text_color))) {
    text_colour <- rlang::ensym(text_color)
  }
  if (!is.null(arrow_color)) {
    arrow_colour <- arrow_color
  }
  # define position of nodes
  node_layout <- get_layout(data = data)
  # add edge attributes
  node_layout <- add_node_attr(node_layout, node_data)
  # define edges of node rectangles
  plot_nodes <- get_nodes(
    node_layout = node_layout,
    x_nudge = x_nudge,
    y_nudge = y_nudge
  )
  # check if labels exist as a column,
  # if not, add it as a duplicate of name
  if ("label" %notin% colnames(plot_nodes)) {
    plot_nodes <- dplyr::mutate(plot_nodes, label = .data$name)
  }
  # define arrows
  plot_edges <- get_edges(
    data = data,
    plot_nodes = plot_nodes
  )
  # create the flowchart
  p <- ggplot2::ggplot()
  # add nodes
  if (as.character(fill) %in% colnames(node_data)) {
    p <- p +
      ggplot2::geom_rect(
        data = plot_nodes,
        mapping = ggplot2::aes(
          xmin = .data$xmin,
          ymin = .data$ymin,
          xmax = .data$xmax,
          ymax = .data$ymax,
          fill = !!fill
        ),
        alpha = 0.5,
        colour = colour
      )
  } else {
    p <- p +
      ggplot2::geom_rect(
        data = plot_nodes,
        mapping = ggplot2::aes(
          xmin = .data$xmin,
          ymin = .data$ymin,
          xmax = .data$xmax,
          ymax = .data$ymax
        ),
        alpha = 0.5,
        colour = colour,
        fill = as.character(fill)
      )
  }
  # add text
  if (as.character(text_colour) %in% colnames(node_data)) {
    p <- p +
      ggplot2::geom_text(
        data = plot_nodes,
        mapping = ggplot2::aes(
          x = .data$x,
          y = .data$y,
          label = .data$label,
          colour = !!text_colour
        ),
        family = family,
        size = text_size
      )
  } else {
    p <- p +
      ggplot2::geom_text(
        data = plot_nodes,
        mapping = ggplot2::aes(
          x = .data$x,
          y = .data$y,
          label = .data$label
        ),
        family = family,
        size = text_size,
        colour = as.character(text_colour)
      )
  }
  # add arrows
  p <- p +
    ggplot2::geom_path(
      data = plot_edges,
      mapping = ggplot2::aes(
        x = .data$x,
        y = .data$y,
        group = .data$id
      ),
      arrow = ggplot2::arrow(
        length = ggplot2::unit(arrow_size, "cm"),
        type = "closed"
      ),
      colour = arrow_colour
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), unit = "cm")
      )
  # check if horizontal
  if (horizontal == TRUE) {
    p <- p +
      ggplot2::coord_flip() +
      ggplot2::scale_y_reverse()
  }
  return(p)
}

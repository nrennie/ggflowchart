#' Generate a flowchart in ggplot2
#'
#' Generates the flowchart
#'
#' @param data Data frame or tibble of edges. Must have two columns, first
#' column are `"from"` node names, second column is `"to"` node names. Node names must be unique.
#' @param node_data Data frame or tibble of node information. If not `NULL`,
#' must have at least one column called "name" for node names to join by.
#' Default `NULL`.
#' @param layout One of `c("tree", "custom")`. If `"tree"` uses the tree layout
#' from {igraph}. If `"custom"`, then `x` and `y` columns must be provided in
#' `node_data` specifying the coordinates of the centre of the boxes. Default
#' `"tree"`.
#' @param fill Fill colour of nodes. Must be a valid colour name or hex
#' code, or the name of a column in node_data (quoted or unquoted).
#' Column names take priority over names of colours. Default `"white"`.
#' @param colour Outline colour of nodes. Must be a valid colour name or hex
#' code. Default `"black"`.
#' @param linewidth Width of node outlines. Default 0.5.
#' @param alpha Transparency of fill colour in nodes. Default 1.
#' @param text_colour Colour of labels in nodes. Must be a valid colour name
#' or hex code, or the name of a column in node_data (quoted or unquoted).
#' Column names take priority over names of colours. Default `"black"`.
#' @param text_size Font size of labels in nodes. Default 3.88.
#' @param family Font family for node labels. Default `"sans"`.
#' @param parse If TRUE, the labels will be parsed into expressions
#' and displayed as described in ?plotmath. Default `FALSE`.
#' @param arrow_colour Colour of arrows. Must be a valid colour name or hex
#' code. Default `"black"`.
#' @param arrow_size Size of arrow head. Default 0.3.
#' @param arrow_linewidth Linewidth of arrow lines. Default 0.5.
#' @param arrow_linetype Linetype of arrow lines. Default `"solid"`.
#' @param arrow_label_fill Fill colour of arrow labels. Default `"white"`.
#' @param x_nudge Distance from centre of edge of node box in x direction.
#' Ignored if `x_nudge` is a column in `node_data`. Default 0.35.
#' @param y_nudge Distance from centre of edge of node box in y direction.
#'  Ignored if `y_nudge` is a column in `node_data`. Default 0.25.
#' @param horizontal Boolean specifying if flowchart should go from left to
#' right. Default `FALSE`.
#' @param color Outline colour of nodes - overrides colour. Must be a valid colour name or hex
#' code. Default `NULL`.
#' @param text_color Colour of labels in nodes - overrides text_colour. Must be a valid colour name
#' or hex code. Default `NULL`.
#' @param arrow_color Colour of arrows - overrides arrow_colour. Must be a valid colour name or hex
#' code. Default `NULL`.
#' @importFrom rlang .data
#' @return A ggplot2 object.
#' @export
#' @examples
#' data <- tibble::tibble(from = c("A", "A", "A", "B", "C", "F"), to = c("B", "C", "D", "E", "F", "G"))
#' ggflowchart(data)
ggflowchart <- function(data,
                        node_data = NULL,
                        layout = "tree",
                        fill = "white",
                        colour = "black",
                        linewidth = 0.5,
                        alpha = 1,
                        text_colour = "black",
                        text_size = 3.88,
                        family = "sans",
                        parse = FALSE,
                        arrow_colour = "black",
                        arrow_size = 0.3,
                        arrow_linewidth = 0.5,
                        arrow_linetype = "solid",
                        arrow_label_fill = "white",
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
  # check layout valid
  if (layout %notin% c("tree", "custom")) {
    stop('Layout must be one of c("tree", "custom").')
  }
  # check data has non-zero rows
  if (nrow(data) < 1) {
    stop('data must have at least one row.')
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
  node_layout <- get_layout(
    data = data,
    layout = layout,
    node_data = node_data
    )
  # add edge attributes
  if (layout == "custom") {
    node_layout <- add_node_attr(
      node_layout = node_layout,
      node_data = dplyr::select(node_data, -dplyr::any_of(c("x", "y")))
    )
  } else {
    node_layout <- add_node_attr(
      node_layout = node_layout,
      node_data = node_data
    )
  }
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
    plot_nodes = plot_nodes,
    node_layout = node_layout
  )
  # define edge labels
  edge_labels <- get_edge_labels(
    data = data,
    plot_edges = plot_edges
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
        alpha = alpha,
        colour = colour,
        linewidth = linewidth
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
        alpha = alpha,
        colour = colour,
        fill = as.character(fill),
        linewidth = linewidth
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
        size = text_size,
        parse = parse
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
        parse = parse,
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
      linewidth = arrow_linewidth,
      linetype = arrow_linetype,
      colour = arrow_colour
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), unit = "cm")
      )
  # add arrow edge labels
  if (!is.null(edge_labels)) {
    p <- p +
      ggplot2::geom_label(
        data = edge_labels,
        mapping = ggplot2::aes(
          x = .data$text_x,
          y = .data$text_y,
          label = .data$label
        ),
        fill = arrow_label_fill,
        family = family,
        size = text_size
      )
  }
  # check if horizontal
  if (horizontal == TRUE) {
    p <- p +
      ggplot2::coord_flip() +
      ggplot2::scale_y_reverse()
  }
  return(p)
}

#' Add node attributes
#'
#' Adds additional information to the node e.g. variable to colour by
#'
#' @param node_layout Data frame of node layout returned by \code{get_layout()}.
#' @param node_data Data frame or tibble of node information. Must have at least one column
#' called "name" for node names to join by. To change labels that appear on nodes, include
#' a column with the name "label".
#' @return A tibble.
#' @noRd

add_node_attr <- function(node_layout, node_data) {
  # define notin
  "%notin%" <- function(x, y) {
    !("%in%" (x, y))
  }
  # if no additional node info provided
  if (is.null(node_data)) {
    return(node_layout)
  } else {
    # check if names correct if any missing
    if ("name" %notin% colnames(node_data)) {
      stop("node_data must have a column called `name` to join to node layout")
    }
    # add node attributes
    node_layout <- dplyr::left_join(node_layout, node_data, by = "name")
    return(node_layout)
  }
}

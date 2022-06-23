#' Get layout
#'
#' Obtains the coordinates for the nodes of the flowchart from the input edges
#'
#' @param data Data frame or tibble of edges. Must have two columns, first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @importFrom dplyr %>%
#' @return A tibble.
#' @export

get_layout <- function(data) {
  if (ncol(data) != 2) {
    stop("Incorrect number of columns in data: input data should contain exactly two columns.")
  }
  if (!any(colnames(data) == c("from", "to"))) {
    colnames(data) <- c("from", "to")
  }
  g <- igraph::graph_from_data_frame(data, directed = TRUE)
  coords <- igraph::layout_as_tree(g)
  colnames(coords) <- c("x", "y")
  output <- tibble::as_tibble(coords) %>%
    dplyr::mutate(name = igraph::vertex_attr(g, "name"))
  return(output)
}

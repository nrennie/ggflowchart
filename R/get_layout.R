#' Get layout
#'
#' Obtains the coordinates for the nodes of the flowchart from the input edges
#'
#' @param data Data frame or tibble of edges. Must have at least two columns, if not labelled "from"
#' and "to" it is assumed first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @importFrom dplyr %>%
#' @return A tibble.
#' @noRd

get_layout <- function(data) {
  # check number of columns
  if (ncol(data) < 2) {
    stop("Incorrect number of columns in data: data should contain at least two columns.")
  }
  # define notin
  "%notin%" <- function(x, y) {
    !("%in%"(x, y))
  }
  # check column names
  if ("from" %in% colnames(data) && "to" %notin%  colnames(data)) {
    stop("data contains only 'from' column but not 'to'")
  }
  if ("to" %in% colnames(data) && "from" %notin%  colnames(data)) {
    stop("data contains only 'to' column but not 'from'")
  }
  if (!all(c("from", "to") %in% colnames(data))) {
    colnames(data)[1:2] <- c("from", "to")
    message("'from' and 'to' not found in column names, using first two columns instead.")
  }
  data <- dplyr::select(data, c(.data$from, .data$to))
  g <- igraph::graph_from_data_frame(data, directed = TRUE)
  coords <- igraph::layout_as_tree(g)
  colnames(coords) <- c("x", "y")
  output <- tibble::as_tibble(coords) %>%
    dplyr::mutate(name = igraph::vertex_attr(g, "name"))
  return(output)
}

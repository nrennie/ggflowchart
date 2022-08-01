#' Get edges
#'
#' Define the end points of the arrows
#'
#' @param data Data frame or tibble of edges. Must have at least two columns, if not labelled "from"
#' and "to" it is assumed first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @param plot_nodes Tibble of node coordinates output from \code{get_nodes()}.
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#' @return A tibble.
#' @export

get_edges <- function(data, plot_nodes) {
  if (ncol(data) < 2) {
    stop("Incorrect number of columns in data: input data should contain at least two columns.")
  }
  if (!any(colnames(data) == c("from", "to"))) {
    colnames(data)[1:2] <- c("from", "to")
  }
  plot_edges <- data %>%
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

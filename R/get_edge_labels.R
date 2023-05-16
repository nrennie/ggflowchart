#' Get edge labels
#'
#' Define the end points of the arrows
#'
#' @param data Data frame or tibble of edges. Must have at least two columns, if not labelled "from"
#' and "to" it is assumed first column are "from" node names,
#' second column is "to" node names. Node names must be unique.
#' @param plot_edges Tibble of edge coordinates output from \code{get_edges()}.
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#' @return A tibble.
#' @noRd

get_edge_labels <- function(
    data,
    plot_edges) {
  if (is.null(data[["label"]])) {
    return(NULL)
  } else {
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
    edge_labels <- plot_edges %>%
      dplyr::group_by(.data$id) %>%
      dplyr::mutate(
        text_x = mean(.data$x),
        text_y = mean(.data$y)
      ) %>%
      dplyr::ungroup() %>%
      dplyr::select(.data$s_e, .data$name, .data$text_x, .data$text_y) %>%
      tidyr::pivot_wider(
        names_from = .data$s_e,
        values_from = .data$name
      ) %>%
      dplyr::left_join(
        data,
        by = c("from", "to")
      ) %>%
      dplyr::select(.data$text_x, .data$text_y, .data$label)
    return(edge_labels)
  }
}

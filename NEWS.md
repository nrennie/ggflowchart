## ggflowchart 1.0.0.9001 2023_05_20

* Add vignette on how to style nodes
* Add initial unit testing

## ggflowchart 1.0.0.9000 2023_05_19

* Add ability to add arrow labels (issue #15)
* Add `arrow_linewidth` and `arrow_linewidth` as arguments (issue #14)
* Add lintr checks to GH Actions
* Add `alpha` as argument
* Add contributor guidelines
* Allow `x_nudge` and `y_nudge` to vary for each node. (issue #12)

## ggflowchart 1.0.0 2023_05_10

* Initial CRAN submission

## ggflowchart 0.0.2 2023_05_10

* Add `horizontal` argument to `ggflowchart()`
* Add `arrow_size` argument to `ggflowchart()`
* Add `text_size` argument to `ggflowchart()`
* Add option to set `fill` based on column in `node_data`
* Add option to set `text_colour` based on column in `node_data`
* Update vignette examples

## ggflowchart 0.0.1 2022_08_06

* Initialise package
* Adds non-exported `get_layout()` to obtain centre of node positions
* Adds non-exported `get_nodes()` to define perimeter of node boxes
* Adds non-exported `add_node_attr()` to include node attributes including labels
* Adds non-exported `get_edges()` to define arrow start and end positions
* Adds `ggflowchart()` to create flowchart

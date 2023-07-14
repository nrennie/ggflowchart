## ggflowchart 1.0.0.9000+ 2023_07_14

* Add vignette on how to style nodes
* Add initial unit testing
* Add utils function to determine arrow type
* Add lintr checks to GH Actions
* Add contributor guidelines
* Add option to parse text in nodes.
* Update README
* Add `alpha` as argument
* Same level arrows support (issue #5)
* Add option for custom layout (issue #11)
* Allow `x_nudge` and `y_nudge` to vary for each node. (issue #12)
* Add `arrow_linewidth` and `arrow_linewidth` as arguments (issue #14)
* Add `linewidth` as argument (issue #14)
* Add ability to add arrow labels (issue #15)
* More informative error handling (issue #29)
* Set minimum version of {ggplot2} (issue #31)

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

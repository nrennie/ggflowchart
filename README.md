<!-- badges: start -->
  [![R-CMD-check](https://github.com/nrennie/ggflowchart/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nrennie/ggflowchart/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->

# {ggflowchart} <img src="man/figures/logo.png" align="right" width="120" />

{ggflowchart} is an R package for producing flowcharts using {ggplot2}.

## Installation

Install the package using:

```
remotes::install_github("nrennie/ggflowchart")
```

Note: this package is currently a work-in-progress. See vignettes for usage.

Upcoming features:

* Changing `fill` and `colour` based on node attributes.
* Changing `linetype` and `colour` of arrows based on edge attributes.
* Support for `color` as well as `colour`.
* Horizontal flowcharts.
* Same-level arrows (currently an issue with crossing over).

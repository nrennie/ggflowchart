<!-- badges: start -->
  [![R-CMD-check](https://github.com/nrennie/ggflowchart/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nrennie/ggflowchart/actions/workflows/R-CMD-check.yaml)
  [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/ggflowchart)](https://cran.r-project.org/package=ggflowchart)
  <!-- badges: end -->

# {ggflowchart} <img src="man/figures/logo.png" align="right" width="120" />

{ggflowchart} is an R package for producing flowcharts using {ggplot2}.

## Installation

Install the package from CRAN using:

```r
install.packages("ggflowchart")
```
or install the development version from GitHub:

```r
remotes::install_github("nrennie/ggflowchart")
```

## Usage

The idea of {ggflowchart} is to create simple flowcharts with minimal effort. Currently, all flowcharts are constructed using the `ggflowchart()` function. For the most basic flowchart, it takes as input a data frame containing (at least) two columns for the start and end points of the edges in the flowchart.

```r
data <- tibble::tibble(from = c("A", "A", "A", "B", "C", "F"),
                       to = c("B", "C", "D", "E", "F", "G"))
```
The flowchart is then created using `ggflowchart()`.

```r
ggflowchart(data)
```

![](man/figures/README-minimal.png)

See [vignettes](https://nrennie.github.io/ggflowchart/articles/) for further examples of usage.

## Upcoming features

Note: this package is currently a work-in-progress. Upcoming features that are currently listed as issues being worked on include:

* Changing node outline `colour` based on node attributes.
* Changing `linetype` and `colour` of arrows based on edge attributes.
* Same-level arrows (currently an issue with crossing over).

If you have a suggestion of an additional feature, or find a bug, please file an issue on the [GitHub repository](https://github.com/nrennie/ggflowchart/issues).

## Contributor guidelines

If you'd like to contribute to {ggflowchart}, I'd welcome your help. If you're making a PR, please follow the guidelines below, to make the collaboration easier:

- [ ] You have updated the NEWS and version number in DESCRIPTION.
- [ ] You have checked that R CMD check passes with no ERRORs or WARNINGs. If there is a NOTE - please outline what it is in the PR.
- [ ] You have checked that `lintr::lint_package()` passes.
- [ ] You have checked the list of packages in Imports is still in alphabetical order to enable better tracking of dependencies as the package grows.
- [ ] You have not used the base R `|>` pipe (we're not quite ready to specify R 4.1 or higher as a dependency yet!).
- [ ] If this is a feature request PR (not a bug fix) please make sure it relates to an issue that has not been assigned to someone else (and tag the issue in the PR description).

If these checks fail, and there is no response from the PR author for 1 month, the PR will be automatically closed.




#' repana
#'
#' Reproducible Analysis in R.
#'
#' Set of utilities to make easy the reproduction of analysis in R.
#' It allow to make_structure, clean_structure, and run and log programs in a
#' predefined order to allow secondary files, analysis and reports be constructed in
#' and ordered form.
#'
#' @docType package
#' @name repana
NULL

utils::globalVariables(
  c(
    "table_name",
    "installed",
    "libraries",
    "."
  )
)

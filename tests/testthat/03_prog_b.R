#' ---
#' title: Program Test B
#' author: JJAV
#' date: 2023-10-01
#' sessioninfo: YES
#' signature: YES
#' ---

var_a <- "AAA"
stopifnot(!exists("var_b", inherits = TRUE))
cat("I'm in program B\n")

# The core of the package to run R scripts on its own environment
# 2018124 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#' Run a script
#'
#' Run a script in its own independent environment and logs
#' when it was runs, the time it takes and log the output
#' The file have no access to variables described outside, or
#' variables describe inside should not affect other programs
#' except the conection to a database that is pass as parameter
#'
#' @param p_script The script file
#' @param p_log the logs directory for the output
#' @importFrom rmarkdown render
#' @export
local_source <- function(p_script, p_log = "logs"){
  start_time = Sys.time()
  stopifnot(file.exists(p_script))
  happyend = FALSE
  localenv <- new.env(parent = baseenv())
  res <- try(render(p_script, output_dir = p_log, envir = localenv, quiet = TRUE))
}


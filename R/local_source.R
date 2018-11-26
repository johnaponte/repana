# The core of the package to run R scripts on its own environment
# 2018124 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#' Run a script
#'
#' Run a script in its own independent environment and logs
#' when it was runs, the time it takes and log the output
#' The file have no access to variables described outside, or
#' variables describe inside should not affect other programs
#'
#' @param p_script The script file
#' @param p_log the logs directory for the output
#' @importFrom rmarkdown render
#' @export
local_source <- function(p_script, p_log = "logs"){
  start_time = Sys.time()
  stopifnot(file.exists(p_script))
  cat(p_script, format(start_time))
  localenv <- new.env(parent = parent.frame())
  fil <- tempfile()
  # In case of a disaster you can recover the file in the temporary directory
  cat("",basename(fil))
  file.rename(p_script, fil)
  tmp <- file(p_script,"w")
  # Inject to prevent stop if an error occurs
  writeLines("#- error = TRUE", con = tmp)
  writeLines(readLines(fil), con = tmp)
  close(tmp)
  # Reset the error to something known
  try(stop(".HaPPyEnD") , silent = TRUE)
  # The rendering !
  try(render(p_script, output_dir = p_log, envir = localenv, runtime = "shiny", quiet = TRUE))

  file.rename(fil,p_script)
  if (geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n") {
    happyend <- ":-)"
  }
  else {
    happyend <- ":-O"
  }
  durtime <- difftime(Sys.time(), start_time, units = "min")
  cat("",durtime, happyend,"\n")
}


#' Run a script and logs in a database
#'
#' Run a script in its own independent environment and logs
#' when it was runs, the time it takes and log the output
#' The file have no access to variables described outside, or
#' variables describe inside should not affect other programs,
#' It log into the a database using a \code{\link[DBI]{DBIConnection-class}}
#' object. The connection is available wihtin the script.
#'
#' @param p_con a \code{\link[DBI]{DBIConnection-class}} object
#' @param p_script The script file
#' @param p_log the logs directory for the output
#' @importFrom rmarkdown render
#' @importFrom DBI dbWriteTable
#' @export
db_local_source <- function(p_con, p_script, p_log = "logs") {
  start_time = Sys.time()
  stopifnot(file.exists(p_script))
  cat(p_script, format(start_time))
  localenv <- new.env(parent = parent.frame())
  assign("p_con", p_con, envir = localenv)
  fil <- tempfile()
  # In case of a disaster you can recover the file in the temporary directory
  cat("", basename(fil))
  file.rename(p_script, fil)
  tmp <- file(p_script, "w")
  # Inject to prevent stop if an error occurs
  writeLines("#- error = TRUE", con = tmp)
  writeLines(readLines(fil), con = tmp)
  close(tmp)
  # Reset the error to something known
  try(stop(".HaPPyEnD") , silent = TRUE)
  # The rendering !
  try(render(p_script,
             output_dir = p_log,
             envir = localenv,
             quiet = TRUE))
  file.rename(fil, p_script)
  if (geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n") {
    happyend <- ":-)"
  }
  else {
    happyend <- ":-O"
  }
  durtime <- difftime(Sys.time(), start_time, units = "min")
  dbWriteTable(
    p_con,
    "log_script",
    data.frame(
      script = p_script,
      start_time = format(start_time),
      tmpfile = basename(fil),
      duration = durtime,
      happy_end = happyend,
      stringsAsFactors = FALSE
    ),
    append = TRUE
  )
  cat("", durtime, happyend, "\n")

}

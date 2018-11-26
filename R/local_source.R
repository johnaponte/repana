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
#' @param p_con a \code{\link[DBI]{DBIConnection-class}}
#' @param p_log the logs directory for the output
#' @importFrom rmarkdown render
#' @export
local_source <- function(p_script, p_con, p_log = "logs"){
  start_time = Sys.time()
  stopifnot(file.exists(p_script))
  happyend = FALSE
  localenv <- new.env(parent = baseenv())
  assign("p_con", p_con,envir =  localenv)
  on.exit({
    durtime <- difftime(Sys.time(), start_time, units = "min")
    if (happyend) {
      cat("### HAPPY END :-)\n")
    }
    else{
      cat("### CHECK FOR ERRORS, the script", p_script, "did not end well :-O\n")
    }
    log_script <- data.frame(program = p_script,
                            star_time = format(start_time),
                            duration = as.numeric(durtime),
                            happyend = ifelse(happyend, ":-)",":-O"),
                            stringsAsFactors = FALSE)
    dbWriteTable(p_con, "log_script", log_script, append = TRUE)
  })
  render(p_script, output_dir = p_log, envir = localenv, quiet = TRUE)
  happyend = TRUE
}


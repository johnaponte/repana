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
#' @param log if TRUE the log is kept
#' @param logdir the path to keep the log
#' @export
local_source <- function(p_script, p_con, log = TRUE, logdir = "logs" ){
  start_time = Sys.time()
  stopifnot(file.exists(p_script))
  logfile = file(file.path(logdir,paste0(p_script,".log")), open = "wt")
  happyend = FALSE
  localenv <- new.env(parent = baseenv())
  assign("p_con", p_con,envir =  localenv)
  cat(p_script, "\n", file = logfile, append = FALSE )
  cat(format(Sys.time()),"\n", file = logfile, append = TRUE)
  cat(rep("#",60),"\n",sep = "", file = logfile, append = TRUE)
  sink(logfile, append = TRUE, split = TRUE)
  sink(logfile, type = "message")
  on.exit({
    cat("\n",rep("#",60),"\n",sep = "")
    durtime <- difftime(Sys.time(), start_time, units = "min")
    cat(durtime,"min\n")
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
    sink()
    sink(type = "message")
    rm(localenv)
    gc()
  })
  source(p_script, local = localenv, echo = TRUE , keep.source = TRUE, max.deparse.length = 5000)
  happyend = TRUE
}


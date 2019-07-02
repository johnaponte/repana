# This master file runs all files
# 20190617 by JJAV
# # # # # # # # # # # # # # # # # # # # #

#' Runs the programs
#'
#' Run the programs specified by the pattern, in the order as the
#' pattern select the files. Keep a log of the results. By default
#' the pattern number_number_anytext.R is selected. They are run in order
#'
#' The program add (or create if not exists) the files run, time of execution
#' and exit status in the file master.log of the directory logs.

#' @param pattern Regular expression to select the files to run
#' @param start index of the program to start
#' @param logdir directory to keep the logs of the files. By default
#' @param rscript_path path to the \code{Rscript} file
#' the entry on the config.yml dirs:logs
#' @import processx
#' @import readr
#' @import config
#' @importFrom utils write.table
#' @export
#' @return a data.frame with the files run, running time and exit status
master <-
  function(pattern = "^[0-9][0-9].*\\.R$",
           start = 1,
           logdir = config::get("dirs")$logs,
           rscript_path = "/usr/local/bin/Rscript") {
    scriptlist = dir(".", pattern = pattern, full.names = T)
    reslogs <-
      lapply(scriptlist[start:length(scriptlist)], function(x) {
        cat(x, "\n")
        cat(rep("=", 80), "\n")
        start = Sys.time()
        res <-
          try(processx::run(rscript_path,
                            c(x, "--vainilla"),
                            echo = T,
                            error_on_status = FALSE))
        end <- Sys.time()
        elapsed = difftime(end, start)
        if (!inherits(res, "try-error")) {
          fname =  file.path("logs", paste0(x, ".log"))

          cat(x, "\n\n", file = fname)
          cat(format(start), "\n", file = fname, append = T)
          cat(rep("=", 80), "\n", file = fname, append = T)
          readr::write_lines(res$stdout, fname, append = T)
          cat(rep("=", 80), "\n", file = fname, append = T)
          if (res$stderr != "") {
            cat("Errors and Warnings messages:\n\n",
                file = fname,
                append = T)
            readr::write_lines(gsub("\033\\[[0-9]{1,2}m", "", res$stderr),
                               fname,
                               append = T)
            cat(rep("=", 80), "\n", file = fname, append = T)
          }
          cat(
            "Status: ",
            res$status,
            "  Timeout: ",
            res$timeout,
            "  Time: ",
            format(elapsed),
            file = fname,
            append = T
          )
          cat(rep("=", 80), "\n")
          cat(x, "  ", format(elapsed), "\n")
        }
        data.frame(
          timestart = format(start),
          script = x,
          elapsed = format(elapsed),
          comments = ifelse(inherits(res, "try-error") |
                              res$status != 0, "FAIL", ":-)")
        )
      })

    dfres <- do.call(rbind, reslogs)
    # Suppress a warning when append the column names
    suppressWarnings(
      write.table(
        dfres,
        "logs/master.log",
        row.names = F,
        append = T,
        col.names = !file.exists("logs/master.log"),
        sep = "\t"
      )
    )
    dfres
  }

# This master file runs all files as spin files
# 20200513 by JJAV
# # # # # # # # # # # # # # # # # # # # #

#' Render all programs as spin code
#'
#' Render the programs specified by the pattern as SPIN reports
#
#' @param pattern Regular expression to select the files to run
#' @param start index of the program to start
#' @param stop index of the program to stop
#' @param logdir directory to keep the logs of the files. By default
#' the entry on the \code{config.yml} \code{dirs:logs}
#' @param format Format to render the report. values accepted are "pdf", "html" and "word"
#' @import readr
#' @import config
#' @importFrom utils write.table
#' @export
#' @return a data.frame with the files run, running time and exit status
master_spin <-
  function(pattern = "^[0-9][0-9].*\\.R$",
           start = 1,
           stop = Inf,
           logdir = config::get("dirs")$logs,
           format = "html") {

    scriptlist = dir(".", pattern = pattern, full.names = T)
    tostop = min(length(scriptlist), stop)
    reslogs <-
      lapply(scriptlist[start:tostop], function(x) {
        cat(x, "\n")
        start = Sys.time()
        res <-
          try(render_report(x,format,logdir))
        res <- ifelse(is.null(res),0,res)
        end <- Sys.time()
        elapsed = difftime(end, start)
        print(format(start))
        print(x)
        print(format(elapsed))
        print(ifelse(inherits(res, "try-error") |
                       res != 0, "FAIL", ":-)"))
        data.frame(
          timestart = format(start),
          script = x,
          elapsed = format(elapsed),
          comments = ifelse(inherits(res, "try-error") |
                              res != 0, "FAIL", ":-)")
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

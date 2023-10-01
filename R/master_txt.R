# This master file runs all files
# 20190617 by JJAV
# # # # # # # # # # # # # # # # # # # # #

#' Runs the programs
#'
#' Run the programs specified by the pattern, in the order as the
#' pattern select the files. Keep a log of the results. By default
#' the pattern starting with two numbers and ending with .R is selected.
#' They are run in order
#'
#' The program add (or create if not exists) the files run, time of execution
#' and exit status in the file master.log of the directory logs.
#'
#' WARNING: This is a legacy program. Use master instead.
#'
#' @param pattern Regular expression to select the files to run
#' @param start index of the program to start
#' @param stop index of the program to stop
#' @param logdir directory to keep the logs of the files. By default
#' @param rscript_path path to the \code{Rscript} file
#' the entry on the \code{config.yml} \code{dirs:logs}
#' @import processx
#' @import readr
#' @import config
#' @importFrom utils write.table
#' @importFrom digest digest
#' @importFrom tools file_path_sans_ext
#' @export
#' @return a data.frame with the files run, running time and exit status
master_txt <-
  function(pattern = "^[0-9][0-9].*\\.R$",
           start = 1,
           stop = Inf,
           logdir = config::get("dirs")$logs,
           rscript_path) {

    # Identify the Rscript program to use
    if (missing(rscript_path)) {
      binpath <- file.path(R.home(), "bin")
      if (file.exists(file.path(binpath, "Rscript"))) {
        rscript_path = file.path(binpath, "Rscript")
      }
      else {
        if (file.exists(file.path(binpath, "Rscript.exe"))) {
          rscript_path = file.path(
            binpath,
            "Rscript.exe")
          }
        else {
          rscript_path = "Rscript"
        }

      }
    }
    # line80 to reports
    line80 <- paste0(rep("=",80), collapse = "")

    # List of files to process
    scriptlist = dir(".", pattern = pattern, full.names = T)
    tostop = min(length(scriptlist), stop)

    # Process the files
    reslogs <-
      lapply(scriptlist[start:tostop], function(x) {
        cat(x, "\n")
        # Define if a signature and session info should be included
        need_a_signature <- TRUE
        need_a_sessioninfo <- TRUE
        rlx <- readLines(x)
        headlin <- grep("\\#' ---", rlx)
        # No well format heading
        if (length(headlin) != 2) {
          need_a_signature = FALSE
          nedd_a_sessioninfo = FALSE
        }
        else {
          yamlx <- yaml.load(
            gsub("\\#' ", "", rlx[seq(headlin[1] + 1, headlin[2] - 1)]))
          if (exists("yamalx$signature")) {
            need_a_signature = identical(yamalx$signature, TRUE)
          }
          else {
            need_a_signature = FALSE
          }

          if (exists("yamalx$sessioninfo")) {
            need_a_sessioninfo = identical(yamalx$sessioninfo, TRUE)
          }
          else {
            need_a_sessioninfo = FALSE
          }
        }


        # Add a Session info is required
        if (need_a_sessioninfo) {
          rlx[length(rlx) + 1] <- paste0(
                                         "\n# Session Info ####\n",
                                         "cat('\\n# Session Info\\n')\n",
                                         "print(sessionInfo(), locale = F)\n")
        }


        # Add signature if required
        if (need_a_signature) {
          hash <- digest(x, algo = "sha1", file = T)
          start_var <- file_path_sans_ext(basename(tempfile("time")))
          rlx[headlin[2] + 1] <- paste0("#+ echo = F\n",
                                        start_var, "<- Sys.time()\n",
                                        rlx[headlin[2] + 1])
          rlx[length(rlx) + 1] <- paste0(
            "\n# Signature ####\n ",
            "cat('\\n# Signature\\n',\n",
            "'File Name: ",
            x,
            "\\n'," ,
            "\n",
            "'SHA1: ",
            hash,
            "\\n',",
            "\n",
            "'Execution start: ', format(",
            start_var,
            "), '\\n',",
            "\n",
            "'Execution time: ', round(difftime(Sys.time(),",
            start_var,
            ", units = 'min'),2), 'min')"
          )
        }

        fnx <- paste0(basename(tempfile()), ".R")
        bnx <- file_path_sans_ext(basename(x))
        writeLines(rlx, fnx)
        start = Sys.time()
        cat(line80,"\n")
        res <-
          try(processx::run(rscript_path,
                            c(fnx, "--vainilla --verbose"),
                            echo = T,
                            error_on_status = FALSE))
        end <- Sys.time()
        elapsed = difftime(end, start)
        #file.remove(fnx)
        if (!inherits(res, "try-error")) {
          fname =  file.path(logdir, paste0(bnx, ".log"))
          readr::write_lines(res$stdout, fname, append = T)
          if (res$stderr != "") {
            cat(line80,"\n", file = fname, append = T)
            cat("Errors and Warnings messages:\n\n",
                file = fname,
                append = T)
            # remove the very offensive ANSI color codes for tidyverse messages
            readr::write_lines(gsub("\033\\[[0-9]{1,2}m", "", res$stderr),
                               fname,
                               append = T)
          }
          cat(line80,"\n", file = fname, append = T)
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
        file.path(logdir, "master.log"),
        row.names = F,
        append = T,
        col.names = !file.exists(file.path(logdir, "master.log")),
        sep = "\t"
      )
    )
    dfres
  }

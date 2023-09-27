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
#' @importFrom tools file_path_sans_ext
#' @importFrom yaml yaml.load
#' @importFrom digest digest
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

        # Define if a signature and session infor should be included
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
          rlx[length(rlx) + 1] <- paste0("#' ## Session Info ",
                                         "\n",
                                         "#+ echo = F ",
                                         "\n",
                                         "print(sessionInfo(), locale = F)")
        }


        # Add signature if required
        if (need_a_signature) {
          hash <- digest(x, algo = "sha1", file = T)
          start_var <-
            file_path_sans_ext(basename(tempfile("time")))
          rlx[headlin[2] + 1] <- paste0("#+ echo = F\n",
                                        start_var, "<- Sys.time()\n",
                                        rlx[headlin[2] + 1])
          rlx[length(rlx) + 1] <- paste0(
            "#' ## Signature ",
            "\n",
            "#+ echo = F ",
            "\n",
            "cat(",
            "\n",
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
        res <-
          try(
            render_report(
              fnx,
              format,
              logdir,
              output_file = file.path(logdir, bnx)))
        file.remove(fnx)
        res <- ifelse(is.null(res), 0, res)
        end <- Sys.time()
        elapsed = difftime(end, start)

        print(format(start))
        print(x)
        print(format(elapsed))
        print(ifelse(inherits(res, "try-error") | res != 0, "FAIL", ":-)"))
        data.frame(
          timestart = format(start),
          script = x,
          elapsed = format(elapsed),
          comments = ifelse(inherits(res, "try-error") | res != 0, "FAIL", ":-)")
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

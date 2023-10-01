# This master file runs all files
# 20200513 by JJAV
# # # # # # # # # # # # # # # # # # # # #

#' Render programs
#'
#' By default, all programs with the pattern "nn_" will be executed in order.
#' The 'Start' and 'Stop' parameters can be used to modify the files to start or stop at
#' a different number.
#'
#' The files are treated as _snip_ files for rmarkdown and render in the log
#' directory, with the format specified in the _format_ parameter.
#'
#' The default the log directory is configured in the config.yml file.
#'
#' @param start program to start
#' @param stop  program to stop
#' @param format Format to render the programs values accepted are "pdf", "html" and "word"
#' @param logdir directory to keep the logs of the files. By default
#' the entry on the \code{config.yml} \code{dirs:logs}
#' @import readr
#' @import config
#' @importFrom utils write.table
#' @importFrom tools file_path_sans_ext
#' @importFrom yaml yaml.load
#' @importFrom digest digest
#' @export
#' @return a data.frame with the files run, running time and exit status
master <-
  function(
           start = 0,
           stop = Inf,
           format = "html",
           logdir = config::get("dirs")$logs) {

    # The patter is of files starting with two digits
    pattern = "^[0-9][0-9].*\\.R$"

    # list of files to run
    scriptlist = dir(".", pattern = pattern, full.names = T)

    if (! is.infinite(stop)) {
      numdef <- as.numeric(sub("^\\D+(\\d+).*", "\\1", scriptlist))
      stopidx <- which(numdef == stop)
      if (length(stopidx) == 0) {
        stop("Stop file ", stop, " Not found!")
      }
      if (length(stopidx) > 1) {
        stop("More than one file " , stop, "are defined" )
      }
      stop = stopidx
    }
    else(
      stop = length(scriptlist)
    )

    if (start > 0) {
      numdef <- as.numeric(sub("^\\D+(\\d+).*", "\\1", scriptlist))
      startidx <- which(numdef == start)
      if (length(startidx) == 0) {
        stop("Start file ", start, " Not found!")
      }
      if (length(startidx) > 1) {
        stop("More than one file " , start, "are defined" )
      }
      start = startidx
    }

    reslogs <-
      lapply(scriptlist[start:stop], function(x) {
        cat("\n",x, "\n")

        # Define if a signature and session infor should be included
        rlx <- readLines(x)
        headlin <- grep("\\#' ---", rlx)
        # No well format heading
        if (length(headlin) != 2) {
          need_a_signature = FALSE
          nedd_a_sessioninfo = FALSE
        }
        else {
          yamalx <- yaml.load(
            gsub("\\#' ", "", rlx[seq(headlin[1] + 1, headlin[2] - 1)]))
          need_a_signature = identical(yamalx[["signature"]],TRUE)
          need_a_sessioninfo = identical(yamalx[["sessioninfo"]],TRUE)
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
              quiet = TRUE,
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

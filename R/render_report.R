# Render a markdown report. by default a pdf and save it on the
# reports directory.
# 20200130 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


#' A wrap to render a markadown report
#'
#' Render the report and copy it to the `outputdir` directory.
#' More formats are available but only three are included here
#' `
#' @param report filename of the report
#' @param format output format. "pdf","htlm","word" are valid entries
#' @param outputdir directory to save the  report
#' @param ... other parameters for \code{\link[rmarkdown]{render}} function
#' @export
#' @importFrom rmarkdown render
#' @seealso \code{\link[rmarkdown]{render}}
#' @examples
#' \dontrun{
#' render_report("myreport","pdf")
#' }
#'
render_report <-
  function(report,
           format = "pdf",
           outputdir = get_dirs()$reports,
           ...) {
    stopifnot(format %in% c("pdf", "html", "word"))
    subfix = paste0(".", format)
    oformat = paste0(format, "_document")
    if (format == "word") subfix = ".docx"

    outputfile = paste0(gsub(".Rmd", "", report), subfix)
    logfile = paste0(gsub(".Rmd", "", report), ".log")
    rmarkdown::render(report, output_format = oformat ,...)
    stopifnot(file.exists(outputfile))
    file.copy(outputfile, outputdir, overwrite = T)
    file.remove(outputfile)
    if (file.exists(logfile))
      file.remove(logfile)
  }





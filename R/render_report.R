# Render a markdown report. by default a pdf and save it on the
# reports directory.
# 20200130 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


#' A wrap to render a markdown report
#'
#' Render the report and copy it to the `outputdir` directory.
#' More formats are available but only three are included here
#' `
#' @param report filename of the report
#' @param format output format. "pdf","html","word" are valid entries
#' @param outputdir directory to save the  report
#' @param ... other parameters for \code{\link[rmarkdown:render]{render}} function
#' @return No return value, called for side effects to render the reports
#' @export
#' @importFrom rmarkdown render
#' @importFrom tools file_ext
#' @importFrom tools file_path_as_absolute
#' @seealso \code{\link[rmarkdown]{render}}
#' @examples
#' \dontrun{
#' render_report(myreport.rmd,"pdf")
#' }
#'
render_report <-
  function(report,
           format = "pdf",
           outputdir = get_dirs()$reports,
           ...) {
    stopifnot(format %in% c("pdf", "html", "word"))
    subfix =  format
    oformat = paste0(format, "_document")
    if (format == "word") subfix = "docx"
    ext = file_ext(report)
    outputfile = gsub(ext, subfix, report)
    logfile = gsub(ext, "log", report)
    rmarkdown::render(report, output_format = oformat ,...)
    if(file.exists(outputfile)) {
      file.copy(outputfile, outputdir, overwrite = T)
      if (
        file_path_as_absolute(outputfile) !=
        file_path_as_absolute(file.path(outputdir,outputfile))
      ) {
        file.remove(outputfile)
      }
    }
    if (file.exists(logfile))
      file.remove(logfile)
    return()
  }




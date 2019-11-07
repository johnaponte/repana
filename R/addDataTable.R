# This is a wrap to write data.frames in an workbook
# using openxlsx library
# 20191107 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # # # # # #

#' A wrap to \code{\link[openxlsx]{writeDataTable}}
#'
#' Include a \code{data.frame} into a workbook applying a tableStyle and
#' an auto width to the column. For better results you could setup
#' \code{options("openxlsx.minWidth" = 6)}
#'
#' @param wb a workbook object
#' @param df a data.frame
#' @param sheet the sheet name. If missing the name of the data.frame
#' @param tableName a name for the table in the excel document. If missing the name of the data.frame
#' @param tableStyle a tableStyle name
#' @param withFilter if TRUE the filter is included
#' @param firstActiveCol First column active on the the freeze panel
#' @param ... other parameters for the \code{\link[openxlsx]{writeDataTable}}
#' @return silently the wb
#'
#' @examples
#' library(openxlxs)
#' options("openxlsx.minWidth" = 6)
#' wb <- createWorkbook(title = "Test addDataTable")
#' addDataTable(wb,iris)
#' saveWorkbook(wb, "test_addDataTable.xlsx")
#' @importFrom openxlsx addWorksheet
#' @importFrom openxlsx writeDataTable
#' @importFrom openxlsx setColWidths
#' @importFrom openxlsx pageSetup
#' @importFrom openxlsx freezePane
#' @export
addDataTable <- function(wb, df, sheet, tableName,  tableStyle =  "TableStyleMedium1", withFilter = TRUE, firstActiveCol = NULL, ...){
  dfname <- deparse(substitute(df))
  if (missing(sheet)) sheet = dfname
  if (missing(tableName)) tableName = dfname
  addWorksheet(wb, sheet)
  writeDataTable(wb, sheet, df, tableStyle = tableStyle, tableName = tableName, withFilter = withFilter, ...)
  setColWidths(wb, sheet, cols = seq(1,ncol(df)), widths = "auto")
  pageSetup(wb,sheet, printTitleRows = 1, fitToWidth = TRUE)
  freezePane(wb, sheet, firstRow = T, firstActiveCol = firstActiveCol)
  invisible(wb)
}


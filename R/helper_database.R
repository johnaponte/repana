# Utilities for the database
# 20181123 by JJAV
# # # # # # # # # # # # # # #

#' Write in the log table the inclusion of a table in the database
#'
#' Make a new entry in the log of the database updates.
#' If the log table does not exists it creates it
#' Make a new entry with the timestamp of the update.
#' In the log you will have a record of when the table was updated for the last
#' time. It intended to be used with \code{\link{update_table}}
#' @param con \code{\link[DBI]{DBIConnection-class}} object
#' @param table the name of the table
#' @author John J. Aponte
#' @importFrom  DBI dbReadTable
#' @importFrom DBI dbWriteTable
#' @importFrom lubridate now
#' @importFrom dplyr filter
#' @importFrom dplyr bind_rows
#' @importFrom magrittr "%>%"
write_log <- function(con, table){
  oldfact <- options("stringsAsFactors")[[1]]
  options(stringsAsFactors = FALSE)
  log <- data.frame(table_name = table, timestamp = as.character(lubridate::now()))
  if (dbExistsTable(con,"log")) {
    log <- dbReadTable(con,"log") %>%
      filter(table_name != table) %>%
      bind_rows(log)
  }
  dbWriteTable(con,"log",log, overwrite = TRUE)
  options(stringsAsFactors = oldfact)
  invisible(log)
}


#' Writes a \code{data.frame} in the database
#'
#' Write or replace a \code{data.frame} in the database
#' and update the log
#' @param con \code{\link[DBI]{DBIConnection-class}} object
#' @param table Name of the table
#' @importFrom DBI dbWriteTable
#' @importFrom DBI dbBegin
#' @importFrom DBI dbCommit
#' @export
update_table <- function(con,table) {
  dbBegin(con)
  res <- try({
    db <- base::get(table)
    dbWriteTable(con,table,db, overwrite = TRUE)
    write_log(con,table)
    dbCommit(con)
  }, silent = TRUE)
  on.exit({
    if (inherits(res, "try-error")) {
        dbRollback(con)
        stop(attributes(res)$condition$message)
      }

  })
  invisible(table)
}

#' Drop all tables from a database
#' @param con \code{\link[DBI]{DBIConnection-class}} object
#' @author John J. Aponte
#' @importFrom  DBI dbListTables
#' @importFrom  DBI dbRemoveTable
#' @export
clean_database <- function(con) {
  invisible(
    lapply(dbListTables(con),function(x){
      cat("DROP TABLE ",x,"\n")
      dbRemoveTable(con,x)})
  )
}

# Utilities for the database
# 20181123 by JJAV
# 20190701 updated after some months of infomal testing
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

##' Make a log of the updates on the database
#'
#' Make a log of the database updates. If the log table does not exists it creates it
#' Make a new entry with the timestamp of the update
#' @param con DBI connection
#' @param tablename the name of the table
#' @param source a manual comment to identify the source of the table
#' @import DBI
#' @importFrom  dplyr filter
#' @importFrom dplyr bind_rows
#' @importFrom lubridate now
#' @importFrom magrittr %>%
write_log <- function(con, tablename, source){
  log <- data.frame(table_name = tablename, timestamp = as.character(lubridate::now()), source = source, stringsAsFactors = F)
  if (dbExistsTable(con,"log")) {
    log <- dbReadTable(con,"log") %>%
      dplyr::filter(table_name != tablename) %>%
      dplyr::bind_rows(log)
  }
  dbWriteTable(con,"log",log, overwrite = TRUE)
}

#' Helper function to include a data.frame in the database and update the log
#' @param con DBI connection
#' @param table the data.frame to be included in the database
#' @param source a manual comment to identify the source of the table
#' @import DBI
#' @export
update_table <- function(con, table, source) {
  tablename <- as.character(substitute(table))
  #cat(tablename,"\n")
  dbBegin(con)
  rexpr <- try({
    dbWriteTable(con, tablename, as.data.frame(table), overwrite = TRUE)
    write_log(con, tablename, source)
  })
  if (inherits(rexpr, "try-error")) {
    dbRollback(con)
    stop(rexpr)
  }
  else{
    dbCommit(con)
  }
}

#' Helper function to drop all tables from a database
#' @param con DBI connection
#' @import DBI
#' @export
clean_database <- function(con) {
  invisible(
    lapply(dbListTables(con),function(x){
      cat("DROP TABLE ",x,"\n")
      dbRemoveTable(con,x)})
  )
}


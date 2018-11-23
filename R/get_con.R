# to connect to a database
# 20181123 by JJAV
# # # # # # # # # # # # # # #

#' Get conection from configuration file
#'
#' The project use odbc to get connection to the database. To keep the
#' details of the connection we use the config.yml read by the
#' \code{\link[config]{get}} function.  See the vignette for details
#'
#' @param configname a string with the name of the value
#' @param file name of the configuration to read from.
#' @author John J. Aponte
#' @return a \code{DBI} connnection
#' @import DBI
#' @importFrom odbc odbc
#' @importFrom config get
#' @export
get_con <- function(configname = "defaultdb", file = "config.yml"){
  dw <- config::get(configname)
  drv <- odbc::odbc()
  theargs <- c(list(drv = drv), dw)
  do.call(dbConnect,theargs)
}

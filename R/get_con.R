# to connect to a database
# 20181123 by JJAV
# # # # # # # # # # # # # # #

#' Get connection from configuration file
#'
#' The project use ODBC to get connection to a database. To keep the
#' parameters of the connection we use the \code{config.yml} read by the
#' \code{\link[config]{get}} function.  See the vignette for details.
#'
#' @param configname a string with the name of the value
#' @param file name of the configuration to read from.
#'
#' @author John J. Aponte
#' @return a \code{DBI} connection
#' @import DBI
#' @importFrom odbc odbc
#' @importFrom config get
#' @export
get_con <-
  function(configname = "defaultdb",
           file = "config.yml") {
    dw <- config::get(configname)
    drv <- odbc::odbc()
    theargs <- c(list(drv = drv), dw)
    return(do.call(dbConnect, theargs))
  }

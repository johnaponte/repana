# to connect to a database
# 20181123 by JJAV
# # # # # # # # # # # # # # #

#' Get conection from configuration file
#'
#' The project use odbc to get connection to the database. To keep the
#' details of the connection we use the config.yml read by the
#' \code{\link[config]{get}} function.  See the vignette for details.
#' If a \code{p_con} object is specified, the connection is passed through
#'
#' @param configname a string with the name of the value
#' @param file name of the configuration to read from.
#' @param p_con a \code{\link[DBI]{DBIConnection-class}} object.
#'
#' @author John J. Aponte
#' @return a \code{DBI} connnection
#' @import DBI
#' @importFrom odbc odbc
#' @importFrom config get
#' @export
get_con <-
  function(configname = "defaultdb",
           file = "config.yml",
           p_con) {
    if (missing(p_con)) {
      dw <- config::get(configname)
      drv <- odbc::odbc()
      theargs <- c(list(drv = drv), dw)
      return(do.call(dbConnect, theargs))
    }
    else {
      return(p_con)
    }
  }

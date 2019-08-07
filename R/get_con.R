# to connect to a database
# 20181123 by JJAV
# # # # # # # # # # # # # # #

#' Get connection from configuration file
#'
#' The project use DBI to get connection to a database. To keep the
#' parameters of the connection we use the \code{config.yml} read by the
#' \code{\link[config]{get}} function.  See the vignette for details.
#'
#' @param configname a string with the name of the value
#' @param file name of the configuration to read from.
#'
#' @author John J. Aponte
#' @return a \code{DBI} connection
#' @import DBI
#' @importFrom config get
#' @importFrom utils getFromNamespace
#' @export
get_con <-
  function(configname = "defaultdb",
           file = "config.yml") {
    theconf <- config::get(configname)
    package <- theconf$package
    dbconnect <- theconf$dbconnect
    othargs <- grep("(package)|(dbconnect)",names(theconf), invert = TRUE, value = TRUE)
    drv <- getFromNamespace(dbconnect,package)
    theargs <- c(list(drv = drv()), theconf[othargs] )
    return(do.call(dbConnect, theargs))
  }

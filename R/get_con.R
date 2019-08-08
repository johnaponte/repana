# to connect to a database
# 20181123 by JJAV
# # # # # # # # # # # # # # #

#' Get a DBI connection reading a  configuration file
#'
#' This function get a DBI connection to a database reading the parameters from a
#' \code{config.yml} file using the \code{\link[config]{get}} function.
#' See the vignette for details.
#'
#' @param configname a string with the name of the configuration
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


#' Get a pool connection reading a configuration file
#'
#' This function get a pool connection to a database reading the parameters from a
#' \code{config.yml} file using the \code{\link[config]{get}} function.
#' See the vignette for details.
#'
#' @param configname a string with the name of the value
#' @param file name of the configuration to read from.
#'
#' @author John J. Aponte
#' @return a \code{\link[pool]{dbPool}} connection object
#' @importFrom pool dbPool
#' @importFrom config get
#' @importFrom utils getFromNamespace
#' @export
get_pool <-
  function(configname = "defaultdb",
           file = "config.yml") {
    theconf <- config::get(configname)
    package <- theconf$package
    dbconnect <- theconf$dbconnect
    othargs <- grep("(package)|(dbconnect)",names(theconf), invert = TRUE, value = TRUE)
    drv <- getFromNamespace(dbconnect,package)
    theargs <- c(list(drv = drv()), theconf[othargs] )
    return(do.call(dbPool, theargs))
  }

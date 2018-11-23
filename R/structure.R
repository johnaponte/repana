# Make the structure of the directory
# 20181123 by JJAV
# # # # # # # # # # # # # # # # # # #


#' Make the structure for a new project
#'
#' Make the following directories
#' \itemize{
#'  \item data to keep the data necessary for the project
#'  \item database to keep the secondary, modified dataset and objects
#'  \item handmade to keep reports and dataset modified by hand or not make by the automatic stream
#'  \item logs  to keep logs of the automatic stream
#'  \item reports to keep the automatic reports
#' }
#' The \code{data}, \code{handmade} are not clean. The rest are clean as they
#' should be reproduced by the automatic stream. Do not forget to include them
#' in \code{.gitignore} if you use \code{git}
#' @author John J. Aponte
#' @export
make_structure <- function() {
  # Make the directories
  lapply(c('data', 'database', 'handmade', 'logs', 'reports'), function(x) {
    if (!dir.exists(x))
      dir.create(x)
  })
  NULL
}

#' Clean the secondary files of the project
#'
#' Delete and make new \code{database}, \code{logs} and \code{reports} directory0
#' @author John J. Aponte
#' @export
clean_structure <- function() {
  lapply(c('database', 'logs', 'reports'), function(x) {
    if (dir.exists(x)) {
      unlink(x, recursive = T)
      dir.create(x)
    }
  })
  NULL
}



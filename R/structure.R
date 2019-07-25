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

  # thanks to will at  https://www.r-bloggers.com/identifying-the-os-from-r/
  get_os <- function() {
    sysinf <- Sys.info()
    if (!is.null(sysinf)) {
      os <- sysinf['sysname']
      if (os == 'Darwin')
        os <- "osx"
    } else {
      ## mystery machine
      os <- .Platform$OS.type
      if (grepl("^darwin", R.version$os))
        os <- "osx"
      if (grepl("linux-gnu", R.version$os))
        os <- "linux"
    }
    tolower(os)
  }

  # write the config.yml if not exists
  if (!file.exists("config.yml")) {
    cat("default:\n", file = "config.yml")
    cat("  dirs:\n", file = "config.yml", append = T)
    cat("    data: _data\n", file = "config.yml", append = T)
    cat("    functions: _functions\n",
        file = "config.yml",
        append = T)
    cat("    handmade: handmade\n",
        file = "config.yml",
        append = T)
    cat("    database: database\n",
        file = "config.yml",
        append = T)
    cat("    reports: reports\n", file = "config.yml", append = T)
    cat("    logs: logs\n", file = "config.yml", append = T)
    cat(
      '  gitignore: !expr c("database","reports","logs")\n',
      file = "config.yml",
      append = T
    )
    cat("  defaultdb:\n", file = "config.yml", append = T)
    driver = "PLEASE SETUP YOUR DRIVERS HERE"
    if (get_os() == "osx" & file.exists("/usr/local/lib/libsqlite3odbc.dylib"))
      driver = "/usr/local/lib/libsqlite3odbc.dylib"
    if (get_os() == "linux" & file.exists("/usr/lib/x86_64-linux-gnu/odbc/libsqlite3odbc.so"))
      driver = "/usr/lib/x86_64-linux-gnu/odbc/libsqlite3odbc.so"
    if (get_os() == "windows")
      driver = "SQLite3 ODBC Driver"
    cat("    driver: ", driver, "\n",  file = "config.yml", append = T)
    cat("    database: database/results.db\n",
        file = "config.yml",
        append = T)
  }

  # Process the .gitignore file
  if (!file.exists(".gitignore")) {
    cat("# Created by make_structure\n", file = ".gitignore")
  }
  xx <- readLines(".gitignore")
  if (get_os() == "osx" & !any(grep("^\\.DS_Store$", xx)))
    cat(".DS_Store\n", file = ".gitignore", append = T)
  if (!any(grepl(paste0("^config.yml$"), xx)))
    cat("config.yml", "\n", file = ".gitignore", append = T)
  in_gitignore <- config::get("gitignore")
  lapply(in_gitignore, function(x) {
    tdir <- config::get("dirs")[[x]]
    if (!any(grepl(paste0("^", tdir, "$"), xx))) {
      cat(tdir, "\n", file = ".gitignore", append = T)
    }
  })

  # Make the directories
  lapply(c(
    config::get("dirs")
  ), function(x) {
    if (!dir.exists(x))
      dir.create(x)
  })
  dir()
}

#' Clean the secondary files of the project
#'
#' Delete and make new \code{database}, \code{logs} and \code{reports} directory
#' @author John J. Aponte
#' @export
clean_structure <- function() {
  lapply( config::get("dirs") , function(x) {
    if (dir.exists(x) &  (x %in% config::get("gitignore"))) {
      unlink(x, recursive = T)
      dir.create(x)
    }
  })
  dir()
}

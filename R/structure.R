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
#' @return the \code{dir} structure
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
    cat(
      "default:\n",
      " dirs:\n",
      "   data: _data\n",
      "   functions: _functions\n",
      "   handmade: handmade\n",
      "   database: database\n",
      "   reports: reports\n",
      "   logs: logs\n",
      " clean_before_new_analysis:\n",
      "   - database\n",
      "   - reports\n",
      "   - logs\n",
      " defaultdb:\n",
      "   package: RSQLite\n",
      "   dbconnect: SQLite\n",
      '   dbname: ":memory:"\n',
      " template:\n",
      "   _template.txt\n",
      file = "config.yml"
    )

  }


  if (!file.exists("_template_spin.R")) {
    fpath <- system.file("templates", "template_spin.txt", package="repana")
    file.copy(fpath,"_template.txt")
  }

  # Process the .gitignore file
  if (!file.exists(".gitignore")) {
    cat("# Created by make_structure\n", file = ".gitignore")
  }
  xx <- trimws(readLines(".gitignore"), "both")
  if (get_os() == "osx" & !any(grep("^\\.DS_Store$", xx)))
    cat(".DS_Store\n", file = ".gitignore", append = T)
  if (!any(grepl(paste0("^config.yml$"), xx)))
    cat("config.yml", "\n", file = ".gitignore", append = T)
  in_gitignore <- config::get("clean_before_new_analysis")
  lapply(in_gitignore, function(x) {
    tdir <- trimws(config::get("dirs")[[x]], "both")
    if (length(tdir) == 0) {
      stop(x,
           " not defined in dirs. check the config.yml file\n")
    }
    if (!any(grepl(paste0("^", tdir, "$"), xx))) {
      cat(tdir, "\n", file = ".gitignore", append = T)
    }
    if (!any(grepl(paste0("^\\*.Rproj$"), xx)))
      cat("*.Rproj", "\n", file = ".gitignore", append = T)

  })


  # Make the 01_clean.R file
  if (!file.exists("01_clean.R")) {
    cat("#' ---\n", file= "01_clean.R")
    cat("#' title: Clean directories\n", file= "01_clean.R", append  = T)
    cat("#' author: Created by repana::makestructure()\n", file= "01_clean.R", append  = T)
    cat("#' date: ", format(Sys.Date()),"\n", file= "01_clean.R", append  = T)
    cat("#' ---\n", file= "01_clean.R", append  = T)
    cat("#' \n", file= "01_clean.R", append  = T)
    cat("#' Clean the directories included in the\n", file= "01_clean.R", append  = T)
    cat("#' __clean_before_new_analysis__ section of config.yml\n", file= "01_clean.R", append  = T)
    cat("#' \n", file= "01_clean.R", append  = T)
    cat("#' Execution date:\n", file= "01_clean.R", append  = T)
    cat("{{ format(Sys.time()) }}\n", file= "01_clean.R", append  = T)
    cat("#' \n", file= "01_clean.R", append  = T)
    cat("repana::clean_structure()\n", file= "01_clean.R", append  = T)
  }

  # Make the directories
  lapply(c(
    config::get("dirs")
  ), function(x) {
    if (!dir.exists(x))
      dir.create(x, recursive = TRUE)
  })
  dir()
}

#' Clean the secondary files of the project
#'
#' Delete and make new \code{database}, \code{logs} and \code{reports} directory
#' @return Invisible, the directories defined by the  clean_before_new_analysis
#' entry in the config.yml file.
#' @author John J. Aponte
#' @export
clean_structure <- function() {
  in_gitignore <- config::get("clean_before_new_analysis")
  if (length(in_gitignore) > 0) {
    message("Make new directories for: \n")
    lapply(in_gitignore, function(x) {
      message(x, "\n")
      tdir <- trimws(config::get("dirs")[[x]], "both")
      if (length(tdir) == 0) {
        stop(x,
             " not defined in dirs. check the config.yml file\n")
      }
      unlink(tdir, recursive = T)
      dir.create(tdir)
    })
  }
  return(invisible(in_gitignore))
}
